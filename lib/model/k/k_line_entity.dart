/*
 * @Author: zhang
 * @Date: 2020-05-23 00:58:35
 * @LastEditTime: 2020-06-12 22:36:50
 * @FilePath: /stock_app/lib/model/k/k_line_entity.dart
 */ 


import 'base_entity.dart';

class KLineEntity extends KBaseEntity  {
  double preDayClose;
  double open;
  double high;
  double low;
  double close;
  double vol;
  double amount;
  int liutong;
  int fuquan;
  int id;
  KLineEntity(){
    amount = 0.0;
    vol = 0.0;
  }

  //0.报价差  1.成交量差(万股) 2.成交额差(万元)  3.time idx 4.前收盘价*10000
  //0.报价差  1.成交量差(万股) 2.成交额差(万元)  3.time idx
  //0.报价差  1.成交量差(万股) 2.成交额差(万元)  3.time idx 4.前收盘价*10000 5.当前成交量 6.当前成交额 7.上一成交量 8.上一成交额 9.时间搓 10.是否是第一条记录 11.开 12.高 13.低
  KLineEntity.fromArray2KFs(List currItem, double _preDayClose) { 
    diff = currItem[0].toDouble();    
    vol = (currItem[1] *100).toDouble();
    amount = (currItem[2]*100).toDouble();
    id = currItem[3];
    preDayClose = _preDayClose;
    open = preDayClose;
    high =diff + preDayClose;
    low = diff + preDayClose;
    close = diff + preDayClose;
  }

  KLineEntity.fromArrayToCurrentInfo(_m, _c, _name, List currItem) { 
    if(currItem.length > 5){
      m = _m;
      c = _c;
      name = _name;   
      diff = currItem[0].toDouble();    
      id = currItem[3];  
      preDayClose = (currItem[4]/10000).toDouble();
      vol = (currItem[5]).toDouble();
      amount = (currItem[6]/100).toDouble();
      open = currItem[11].toDouble();
      high = currItem[12].toDouble();
      low = currItem[13].toDouble();
      close = diff + preDayClose;
    }
  }  
  
  // 0.day_diff 1.流通盘index 2.open 3.high 4.low 5.close 6.volume 7.amount 8.复权index
  KLineEntity.fromArray2K(List json) {
    id = (json[0] as num)?.toInt(); 
    liutong = (json[1] as num)?.toInt(); 
    open = (json[2] as num)?.toDouble();
    high = (json[3] as num)?.toDouble();    
    low = (json[4] as num)?.toDouble();
    close = (json[5] as num)?.toDouble();
    diff = close - open;    
    vol = (json[6] as num)?.toDouble();
    amount = (json[7] as num)?.toDouble();
    fuquan = (json[8] as num)?.toInt();
  }

  KLineEntity.fromJson(Map<String, dynamic> json) {
    id = (json['id'] as num)?.toInt(); 
    liutong = (json['liutong'] as num)?.toInt(); 
    open = (json['open'] as num)?.toDouble();
    high = (json['high'] as num)?.toDouble();    
    low = (json['low'] as num)?.toDouble();
    close = (json['close'] as num)?.toDouble();
    if(close != null && open != null) diff = close - open;    
    vol = (json['vol'] as num)?.toDouble();
    amount = (json['amount'] as num)?.toDouble();
    fuquan = (json['fuquan'] as num)?.toInt();
    preDayClose = (json['preDayClose'] as num)?.toDouble();
  }

  @override
  String toString() {
    return "{'id': $id,'liutong':$liutong, 'open': $open, 'high': $high, 'low': $low, 'close': $close,diff:$diff, vol: $vol, amount:$amount, fuquan:$fuquan }";
  }

  Map toJson() => <String, dynamic>{
      "id": id,
      "liutong": liutong,
      "open": open,
      "high": high,
      "low": low,
      "close": close,
      "diff": diff,
      "vol": vol,
      "amount": amount,
      "fuquan": fuquan,
      "preDayClose":preDayClose
    };
}
