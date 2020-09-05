/*
 * @Author: zhang
 * @Date: 2020-05-25 21:12:45
 * @LastEditTime: 2020-09-05 14:35:00
 * @FilePath: /stock_app/lib/view_model/k_line.dart
 */
import 'dart:async';
import 'dart:convert';

import 'package:app_stock/cache/k_line.dart';
import 'package:app_stock/model/base_response.dart';
import 'package:app_stock/model/k/k_entrust.dart';
import 'package:app_stock/model/k/page.dart';
import 'package:app_stock/service/k_line/k_line.dart';
import 'package:app_stock/ui/pages/chart/chart_state.dart';
import 'package:app_stock/utils/data_util.dart';
import 'package:app_stock/utils/event_bus_util.dart';
import 'package:app_stock/utils/socket_io_utils.dart';
import 'package:app_stock/utils/sql_util.dart';

import '../model/base_response.dart';
import '../model/k/k_line_entity.dart';
import '../provider/base_model.dart';

class KLineProvider extends BaseModel {
  KLineEntity currKLine;
  EventBus eventBus;

  List<KLineEntity> fsDatas;
  List<KLineEntity> compareDatas;

  List<KLineEntity> compareKDatas;
  List<KLineEntity> kDatas = <KLineEntity>[];
  List<KLineEntity> showDatas;

  KLineEntrust entrust;
  AxisType axisType ;


  bool isFullScreen;

  String m;
  String c;
  String name;

  int currPage; // 0 分时, 1五日, 2 K线 , 3周K， 4月K， 5季K， 6 年K

  int showPageIndex;
 
  KPage pageFs;
  KPage pageK;


  Timer timer;

  bool currChangedPageView;

  KLineProvider({int showIndex}) {
    pageFs = KPage();
    isFullScreen = false;
    currKLine = KLineEntity();
    entrust = KLineEntrust();
    currPage = 0;
    showPageIndex = showIndex ?? 0;
    axisType = AxisType.NORMAL;
  }

  movingInit(){
    

    fsDatas = [];
    showDatas = [];
    compareDatas = null;
    compareKDatas = null;
    kDatas = [];    
    currKLine = KLineEntity();
    entrust = KLineEntrust();
    setIdle();
  }
    

  @override
  void dispose() {
    // timer?.cancel();
    // EventBus.instance.off('fs_line');
    // print('ABC:disponse');
    super.dispose();
  }

  startTimeOut(){
    timer =Timer.periodic(Duration(seconds:5), (_) { handleTimeout(m, c);}) ;
  }

  void handleTimeout(_m, _c){      
    print('reqest: $m$c');
      SocketIoUtils.getInstance().emit('fs_line', {'m': _m.toLowerCase(), 'c':_c});
  }

  changeScreenLayout(){
    isFullScreen = !isFullScreen;
    setIdle();
  }

  //切换Tab
  changeCurrPage(int _currPage, {market, code, stockName}) {
    currPage = _currPage;
    print('选中的 Tab ： $currPage 页面');
    if (market != null) loadDataRoot(market: market, code: code, stockName: stockName);
    else loadDataRoot(market: m, code: c, stockName: name);
  }

  changeAxis(int type){
    axisType = type == 0 ? AxisType.NORMAL : AxisType.LOG;
    setIdle();
  }

  //补全分时信息
  _pickFS(List<KLineEntity> fs) {
    List<KLineEntity> result = [];
    if (fs == null) return null;
    if (fs.length == 0) return fs;
    for (int i = 0; i < fs.length; i++) {
      KLineEntity item = fs[i];
      if (i == 0) {
        if (item.id != 0) result = _addFirstResult(result, item, item.id);
        result.add(item);
      } else {
        KLineEntity lastItem = fs[i - 1];
        if (item.id > lastItem.id + 1) {
          int diff = item.id - lastItem.id - 1;
          result = _addResult(result, lastItem, diff);
        }
        result.add(item);
      }
    }
    return result;
  }

  //补默认结果
  _addFirstResult(List<KLineEntity> result, KLineEntity src, int num) {
    for (int i = 1; i <= num; i++) {
      KLineEntity tmp = KLineEntity();
      tmp.id = i - 1;
      tmp.diff = 0.0;
      tmp.vol = 0.0;
      tmp.amount = 0.0;
      tmp.preDayClose = src.preDayClose;
      tmp.open = src.preDayClose;
      tmp.high = src.high;
      tmp.low = src.low;
      tmp.close = src.preDayClose;
      result.add(tmp);
    }
    return result;
  }

  //补默认结果
  _addResult(List<KLineEntity> result, KLineEntity src, int num) {
    for (int i = 1; i <= num; i++) {
      KLineEntity tmp = KLineEntity();
      tmp.id = src.id + i;
      tmp.diff = 0.0;
      tmp.vol = 0.0;
      tmp.amount = 0.0;
      tmp.preDayClose = src.preDayClose;
      tmp.open = src.close;
      tmp.high = src.close;
      tmp.low = src.close;
      tmp.close = src.close;
      result.add(tmp);
    }
    return result;
  }

  //加载对比数据
  loadCompareData(_m, _c) async {
    if (currPage == 1) await loadCompareK(_m, _c);
    else if (currPage == 0) await loadCompareKlineFs(_m, _c);
  }

  //取消对比
  cancelCompareData() async {
    compareDatas = null;
    compareKDatas = null;
    setIdle();
  }

  //加载对比K线
  loadCompareK(m, c) async {
    compareKDatas = await _loadKData(m, c);

    if (compareKDatas.length < kDatas.length) {
      int diff = kDatas.length - compareKDatas.length;
      for (int i = 0; i < diff; i++) {
        compareKDatas.insert(0, null);
      }
    } else if (kDatas.length < compareKDatas.length) {
      compareKDatas.removeRange(0, compareKDatas.length - kDatas.length);
    }
    setIdle();
  }

  //加载对比分时线
  loadCompareKlineFs(m, c) async {
    compareDatas = await _loadFsData(m, c, updateCurrK: false, updatedWt: false); 

    notifyListeners();
  }

  loadDataRoot(
      {market, code, stockName, isFirst = false, defaultSelectK}) async {
    showDatas = [];
    setIdle();
    if (isFirst == true && code == null) {
      List list = KLineCache.getLastCode();
      m = list[0];
      c = list[1];
      name = list[2];
    } else {
      m = market;
      c = code;
      name = stockName;
    }

     if (defaultSelectK != null) currKLine = defaultSelectK;

    print('begin load Fs data');
    fsDatas = await _loadFsData(m, c, stockName:name);
    print('end load Fs data');

    print('begin calc Fs data');
    DataUtil.calculate(fsDatas, currSecondItems,type: currPage,convert: false, onEnd: (datas) {
      if(currPage==0) showDatas = datas;

        print('end calc fs data callBack');
    //  setIdle();
    });
    
    print('end calc fs data'); 

    print('begin load K data');
    kDatas = await _loadKData(m, c);
    print('end load K data');

    print('begin calc K data');
    DataUtil.calculate(kDatas, currSecondItems, type: currPage,  onEnd: (datas) {
     if(currPage>=1) showDatas = datas;
     print('update');
      setIdle();
    });
    
  
    print('end calc K data');
    KLineCache.setLastCode(m, c, name);
    if (isFirst == true) _loadAllStocks();
  }


  Future<List<KLineEntity>> _loadKData(_m, _c) async {
    List list;

    List<KLineEntity> result = <KLineEntity>[];

    List<int> cacheIndex = [];
    List<String> cacheStr = [];
    bool isRequest = false;
    int lastId;
    try {
      List cacheResult = KLineCache.getKCache(_m, _c) ?? [];

      cacheIndex = cacheResult[0];
      cacheStr = cacheResult[1];
      result = cacheResult[2];

      if (result.length > 0) {
        lastId = result.last.id;
      }

      BaseResponseEntity entity =
          await KLineService.loadKLine({'m': _m, 'c': _c, 'maxId': lastId});

      list = entity.records;
      isRequest = true;

      if (list == null) return [];

      List requestResult = list;
      //测试使用 -begin
      if (lastId != null) {
        requestResult = list.where((item) {
          return jsonDecode(item)[0] >= lastId;
        }).toList();
      }

      for (int i = 0; i < requestResult.length; i++) {
        String item = requestResult[i];
        List jsonArr = jsonDecode(item);
        KLineEntity tmp = KLineEntity.fromArray2K(jsonArr);

        int index = cacheIndex.indexOf(tmp.id);
        if (index >= 0) {
          cacheStr[index] = jsonEncode(tmp.toJson());
          result[index] = tmp;
        } else {
          cacheStr.add(jsonEncode(tmp.toJson()));
          result.add(tmp);
        }
      }

      if (isRequest == true) KLineCache.saveKCache(cacheStr, m, c);

      return result;
    } catch (e) {
      setError(e);
      print(e);
      print('K:获取数据失败,获取本地数据');
      return [];
    } finally {}
  }


  Future<List<KLineEntity>> _loadFsData(_m, _c, {stockName, updatedWt: true, updateCurrK: true}) async {
    if(updateCurrK == true){
      currKLine = KLineEntity();
      currKLine.m = m;
      currKLine.c = c;
      currKLine.name = name;

    //  setIdle(); 
    }

    bool isRequest = false;
    List<KLineEntity> result = [];
    List<int> cacheIndex = [];

    List requestFs = [];
    double preDayClose;
    List requestWt = [];
    int requestDay ;

    kDatas = [];
    try {
      List cacheResult = await KLineCache.getFSCache(_m, _c);

      cacheIndex = cacheResult[0];
      result = cacheResult[2];

      if (result.length > 0) preDayClose = result.first.preDayClose;

      BaseResponseEntity entity = await KLineService.loadAllFs({
        'm': _m.toLowerCase(),
        'c': _c,
        'maxId': result.length > 0 ? result.last?.id : null
      });

      requestWt = entity.record['wt'] ?? [];
      requestFs = entity.record['fs'] ?? [];
      requestDay = entity.record['day'] ?? null;

      if (requestFs.length == 0 || requestDay == null)  return null;
      else {
        isRequest = true;
        if (preDayClose == null) preDayClose = jsonDecode(requestFs[0])[4] / 10000;
      }

      for (int i = 0; i < requestFs.length; i++) {
        List jsonArr = jsonDecode(requestFs[i]);
        if (i == 0 && preDayClose == null) preDayClose = jsonArr[4];
        KLineEntity tmp = KLineEntity.fromArray2KFs(jsonArr, preDayClose);
        int index = cacheIndex.indexOf(tmp.id);
        if (index >= 0) {
          result[index] = tmp;
        } else {
          cacheIndex.add(tmp.id);
          result.add(tmp);
        }
      }

      result.sort((a, b) {  return a.id.compareTo(b.id);  });

      result = _pickFS(result);

      if(updateCurrK == true) currKLine = KLineEntity.fromArrayToCurrentInfo(_m, _c, stockName,  jsonDecode(requestFs.last));
      if(updatedWt == true) entrust = KLineEntrust.fromArray(requestWt, preDayClose);
      
      if (isRequest == true) await KLineCache.saveFSCache(result, requestDay, _m, _c);
      return result;
    } catch (e) {
      print('FS 获取数据失败,获取本地数据');
      setError(e);
    } 
  }

  _updateLastData(_m, _c, List fsArr){
     //取最新的记录
     //当前股票
     if(m == _m ){
       print('Data length: ${fsArr.length}');
       if(fsDatas != null && fsDatas.length > 0 && fsArr.length > 0){
          
            KLineEntity entity = KLineEntity.fromArrayToCurrentInfo(m, c, name, jsonDecode(fsArr.last));
            KLineEntity kEntity = KLineEntity.fromArray2KFs(jsonDecode(fsArr.last), jsonDecode(fsArr.last)[4]/10000);
            currKLine = entity;
            if(fsDatas.last.id == kEntity.id){
              fsDatas[kEntity.id] = kEntity;
            }  else if(fsDatas.last.id < kEntity.id)        {
                fsDatas.add(kEntity);
            }
            setIdle();
       }
      // _addData(_m, _c, fsArr);
       if(kDatas != null && kDatas.length > 0){

       }
     }
  }

  // _addData(_m, _c, List fsArr){
  //    //取最新的记录
  //    //当前股票
  //    if(m == _m ){
  //      if(fsDatas != null && fsDatas.length > 0){
  //           KLineEntity entity = KLineEntity.fromArray2KFs(fsArr.last, 0);
  //           if(fsDatas.last.id < entity.id){
  //             fsDatas.add(entity);
  //           }
       
  //      }
  //      if(kDatas != null && kDatas.length > 0){

  //      }
  //    }
  // }  

  //加载股票列表
  void _loadAllStocks() async {
    SqlUtil sql = SqlUtil.setTable('stock_list');
    int total = await sql.count();
    if (total == 0) {
      List<dynamic> entity = await KLineService.loadAllStocks();
      if (entity == null) return;
      await sql.insertAll(
          "insert into stock_list (code,name,jc) values ", entity);
    }


      void getData(String period) async {

  }
  }


  get currSecondaryCount => currSecondItems.length;
  List<SecondaryState> currSecondItems = [SecondaryState.VOL];
  List<SecondaryState> allSecondItems = [
    SecondaryState.VOL,
    SecondaryState.VOL,
    SecondaryState.VOL,
    SecondaryState.VOL
  ];

  changeCurrSecondaryItems(int settingCount) {
    currSecondItems = [];
    for (int i = 0; i < settingCount; i++) {
      currSecondItems.add(allSecondItems[i]);
    }
    notifyListeners();
  }

  changeSecondaryState(int index, state) async {
    allSecondItems[index] = state;

    setIdle();
    DataUtil.calculate(currPage==0 ? fsDatas: kDatas, [state], type: currPage,  onEnd: (datas) {
      showDatas = datas;
      setIdle();
    });
  }
}
