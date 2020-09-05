

import 'dart:math';

import 'package:app_stock/model/k/k_line_entity.dart';
import 'package:app_stock/ui/pages/chart/chart_state.dart';
import 'date_util.dart';

class DataUtil  {
  static calculate(List<KLineEntity> dataList, List<SecondaryState> states, { Function onEnd, type, convert = true}) {
        if (dataList == null) return;
        states ?? [];

        if(type >= 2 && convert)  dataList = _convertKData(dataList, type);
        List<SecondaryState> calcedStates = [];

        for(int i = 0 ; i<states.length; i++){
          if(calcedStates.indexOf(states[i]) >=0) continue; 
          
          _calcMA(dataList);

          if(states[i] == SecondaryState.VOL) _calcVolumeMA(dataList);
          else if(states[i] == SecondaryState.KDJ)  _calcKDJ(dataList);
          else if(states[i] == SecondaryState.MACD)  _calcMACD(dataList);
          calcedStates.add(states[i]);
        }

        if(onEnd != null) onEnd(dataList);
  }



  //更新最后一条数据
  static updateLastData(List<KLineEntity> dataList) {
    if (dataList == null) return;
  }

  static _convertKData(List<KLineEntity> dataList, int type){
    List<KLineEntity> result = [];
    if(dataList.length == 1 || dataList.length == 0) result = dataList;

    KLineEntity tmp;
    for(int i= 0; i<dataList.length ; i++ ){
        //print('!!!!!!!!!!!!!!!!!!=>${DateUtil.getYearByIndex(dataList[i].id)} ====> ${DateUtil.getDateByIndex(dataList[i].id)}');   
        KLineEntity curr = dataList[i];

        KLineEntity pre = i == 0? null : dataList[i-1];
        bool isSame = DateUtil.isInSameByIndexType(pre==null ? null : pre.id , curr.id, type);
        if(!isSame){ //第一条
          if(pre != null)  result.add(tmp);
            tmp = KLineEntity();
            tmp.id = curr.id;
            tmp.open = curr.open;
            tmp.high = curr.high;
            tmp.low = curr.low;
            tmp.close = curr.close;
            tmp.amount = tmp.amount + curr.amount;
            tmp.vol = tmp.vol +curr.vol;            
        }
        else { //中间
          tmp.id = curr.id;
          tmp.high = max(tmp.high??0, curr.high);
          tmp.low = min(tmp.low??0, curr.low);
          tmp.close = curr.close ;
          tmp.amount = tmp.amount + curr.amount;
          tmp.vol = tmp.vol + curr.vol;              
        }

        if(i == dataList.length - 1){
          result.add(tmp);
        }
    }      
    return result;
  }


  static _calcMA(List<KLineEntity> dataList, [bool isLast = false]) {
    double ma5 = 0;
    double ma10 = 0;
    double ma20 = 0;
    double ma30 = 0;

    int i = 0;
    if (isLast && dataList.length > 1) {
      i = dataList.length - 1;
      var data = dataList[dataList.length - 2];
      ma5 = data.ma5Price * 5;
      ma10 = data.ma10Price * 10;
      ma20 = data.ma20Price * 20;
      ma30 = data.ma30Price * 30;
    }
    for (; i < dataList.length; i++) {
      KLineEntity entity = dataList[i];
      final closePrice = entity.close;
      ma5 += closePrice;
      ma10 += closePrice;
      ma20 += closePrice;
      ma30 += closePrice;

      if (i == 4) {
        entity.ma5Price = ma5 / 5;
      } else if (i >= 5) {
        ma5 -= dataList[i - 5].close;
        entity.ma5Price = ma5 / 5;
      } else {
        entity.ma5Price = 0;
      }
      if (i == 9) {
        entity.ma10Price = ma10 / 10;
      } else if (i >= 10) {
        ma10 -= dataList[i - 10].close;
        entity.ma10Price = ma10 / 10;
      } else {
        entity.ma10Price = 0;
      }
      if (i == 19) {
        entity.ma20Price = ma20 / 20;
      } else if (i >= 20) {
        ma20 -= dataList[i - 20].close;
        entity.ma20Price = ma20 / 20;
      } else {
        entity.ma20Price = 0;
      }
      if (i == 29) {
        entity.ma30Price = ma30 / 30;
      } else if (i >= 30) {
        ma30 -= dataList[i - 30].close;
        entity.ma30Price = ma30 / 30;
      } else {
        entity.ma30Price = 0;
      }
    }
  }

  static void _calcVolumeMA(List<KLineEntity> dataList, [bool isLast = false]) {
    double volumeMa5 = 0;
    double volumeMa10 = 0;

    int i = 0;
    if (isLast && dataList.length > 1) {
      i = dataList.length - 1;
      var data = dataList[dataList.length - 2];
      volumeMa5 = data.mA5Volume * 5;
      volumeMa10 = data.mA10Volume * 10;
    }

    for (; i < dataList.length; i++) {
      KLineEntity entry = dataList[i];

      volumeMa5 += entry.vol;
      volumeMa10 += entry.vol;

      if (i == 4) {
        entry.mA5Volume = (volumeMa5 / 5);
      } else if (i > 4) {
        volumeMa5 -= dataList[i - 5].vol;
        entry.mA5Volume = volumeMa5 / 5;
      } else {
        entry.mA5Volume = 0;
      }

      if (i == 9) {
        entry.mA10Volume = volumeMa10 / 10;
      } else if (i > 9) {
        volumeMa10 -= dataList[i - 10].vol;
        entry.mA10Volume = volumeMa10 / 10;
      } else {
        entry.mA10Volume = 0;
      }
    }
  }

  static void _calcMACD(List<KLineEntity> dataList, [bool isLast = false]) {
    double ema12 = 0;
    double ema26 = 0;
    double dif = 0;
    double dea = 0;
    double macd = 0;

    int i = 0;
    if (isLast && dataList.length > 1) {
      i = dataList.length - 1;
      var data = dataList[dataList.length - 2];
      dif = data.dif;
      dea = data.dea;
      macd = data.macd;
    }

    for (; i < dataList.length; i++) {
      KLineEntity entity = dataList[i];
      final closePrice = entity.close;
      if (i == 0) {
        ema12 = closePrice;
        ema26 = closePrice;
      } else {
        // EMA（12） = 前一日EMA（12） X 11/13 + 今日收盘价 X 2/13
        ema12 = ema12 * 11 / 13 + closePrice * 2 / 13;
        // EMA（26） = 前一日EMA（26） X 25/27 + 今日收盘价 X 2/27
        ema26 = ema26 * 25 / 27 + closePrice * 2 / 27;
      }
      // DIF = EMA（12） - EMA（26） 。
      // 今日DEA = （前一日DEA X 8/10 + 今日DIF X 2/10）
      // 用（DIF-DEA）*2即为MACD柱状图。
      dif = ema12 - ema26;
      dea = dea * 8 / 10 + dif * 2 / 10;
      macd = (dif - dea) * 2;
      entity.dif = dif;
      entity.dea = dea;
      entity.macd = macd;
    }
  }

  static void _calcKDJ(List<KLineEntity> dataList, [bool isLast = false]) {
    double k = 0;
    double d = 0;

    int i = 0;
    if (isLast && dataList.length > 1) {
      i = dataList.length - 1;
      var data = dataList[dataList.length - 2];
      k = data.k;
      d = data.d;
    }

    print('KDJ====>${dataList.length}');
    for (; i < dataList.length; i++) {
      KLineEntity entity = dataList[i];
      final double closePrice = entity.close;
      int startIndex = i - 13;
      if (startIndex < 0) {
        startIndex = 0;
      }
      double max14 = -double.maxFinite;
      double min14 = double.maxFinite;
      for (int index = startIndex; index <= i; index++) {
        max14 = max(max14, dataList[index].high);
        min14 = min(min14, dataList[index].low);
      }
      double rsv = 100 * (closePrice - min14) / (max14 - min14);
      if (rsv.isNaN) {
        rsv = 0;
      }
      if (i == 0) {
        k = 50;
        d = 50;
      } else {
        k = (rsv + 2 * k) / 3;
        d = (k + 2 * d) / 3;
      }
      if (i < 13) {
        entity.k = 0;
        entity.d = 0;
        entity.j = 0;
      } else if (i == 13 || i == 14) {
        entity.k = k;
        entity.d = 0;
        entity.j = 0;
      } else {
        entity.k = k;
        entity.d = d;
        entity.j = 3 * k - 2 * d;
      }
    }
  }

  static void _calcCYQ(List<KLineEntity> dataList, [bool isLast = false]){
      // for (int i = 0; i < dataList.length; i++) {
      //   print('iiiiii------$i');
      //   Map<double, int> cyqMap ={};
      //   int maxCyqTotal = 0;
      //   KLineEntity entry = dataList[i];
      //   int init = 0;
      //   if(i > 120){
      //     init = i - 120;
      //   }

      //   for(int j= init; j<=i ;j++){
      //     double dif = (dataList[j].high - dataList[j].low)/20;
      //     for(double m = dataList[j].low; m<= dataList[j].high; m = m + dif){
      //       if(cyqMap[m] != null){
      //         cyqMap[m] = cyqMap[m] + 1;
      //       } else {
      //         cyqMap[m] = 1;
      //       }
      //       maxCyqTotal = max(maxCyqTotal, cyqMap[m]);
      //     }
      //   }
      //   entry.cyqMap = cyqMap;
      //   entry.maxCyqTotal = maxCyqTotal;
      // }
      // print('ttttt');
  }


  static Map<double, int>  calcY(List<KLineEntity> dataList,int selectIndex){
        int init = 0;
        if(selectIndex > 120){
          init = selectIndex - 120;
        }

        Map<double, int> cyqMap ={};
        int maxCyqTotal = 0;
      for (int j = init; j <= selectIndex; j++) {
        

        KLineEntity entry = dataList[j];

        double dif = (dataList[j].high - dataList[j].low)/20;
        for(double m = dataList[j].low; m<= dataList[j].high; m = m + dif){
          if(cyqMap[m] != null){
            cyqMap[m] = cyqMap[m] + 1;
          } else {
            cyqMap[m] = 1;
          }
          maxCyqTotal = max(maxCyqTotal, cyqMap[m]);
        }
        entry.cyqMap = cyqMap;
        entry.maxCyqTotal = maxCyqTotal;
      }
      return cyqMap;
  }

}
