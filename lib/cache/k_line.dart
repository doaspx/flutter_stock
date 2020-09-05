/*
 * @Author: zhanghongtao
 * @Date: 2020-06-02 18:19:06
 * @LastEditTime: 2020-06-08 13:18:03
 * @FilePath: \stock_app\lib\cache\k_line.dart
 */ 
import 'dart:convert';

import 'package:app_stock/config/const.dart';
import 'package:app_stock/model/k/k_line_entity.dart';
import 'package:app_stock/utils/date_util.dart';
import 'package:app_stock/utils/sp_util.dart';

class KLineCache {
    static getKCache(String m, String c)  {
    m = m.toLowerCase();
    List<String> caches = SpUtil.instance.getStringList(Const.KLineDataHeader + m + c) ?? [];

    List<int> cacheIndex = [];
    List<String> cacheStr = [];
    List<KLineEntity> result = caches.map<KLineEntity>((item) {
        KLineEntity tmp = KLineEntity.fromJson(jsonDecode(item));
        cacheIndex.add(tmp.id);
        cacheStr.add(item);
        return tmp;
    }).toList();
    return [cacheIndex, cacheStr, result];
  }
  
  static saveKCache(List<String> list,  String m, String c) {
    m = m.toLowerCase();
    
    SpUtil.instance.putStringList(Const.KLineDataHeader + m + c, list);
  }
 
  //可以合并
  static  getFSCache( String m, String c)  async{
    m = m.toLowerCase();
    String key = Const.FsLineDataHeader + m + c;   
    List<int> cacheIndex = [];
    List<String> cacheStr = [];   
    List<KLineEntity> result = [];
    List<String> caches = SpUtil.instance.getStringList(key) ?? [];

    int day = SpUtil.instance.getInt(key+'_day');
    int currDay = DateUtil.getIndexByDate(DateTime.now());
    
    if(day != currDay)return [cacheIndex, cacheStr, result];

    result = caches.map<KLineEntity>((item) {
        KLineEntity tmp = KLineEntity.fromJson(jsonDecode(item));
        cacheIndex.add(tmp.id);
        cacheStr.add(item);        
        return tmp;
        
    }).toList();
    return [cacheIndex, cacheStr, result];
  }  

  
  static saveFSCache(List<KLineEntity> list, int day , String m, String c) async {        
    m = m.toLowerCase();

    List<String> caches = List(list.length);
    for(int i = 0 ; i< list.length; i++){
      caches[list[i].id] = jsonEncode(list[i].toJson());
    }

    String key = Const.FsLineDataHeader + m + c;
    
    await SpUtil.instance.putStringList(key , caches);   
    await SpUtil.instance.putInt(key + '_day', day);
  }  


  static List getLastCode()  {
    return ['sh','600519','贵州茅台'];
    String json = SpUtil.instance.getString(Const.LastViewStockInfo);
    List result = [];
    if (json == null)     result = ['sh','603160','汇顶科技'];
    else  result = jsonDecode(json); 
    
      return result;
  }

  static setLastCode(m, c, name) async {
    SpUtil.instance.putString(Const.LastViewStockInfo, jsonEncode([m.toLowerCase(), c, name]));
  }
}