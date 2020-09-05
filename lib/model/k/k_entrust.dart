/*
 * @Author: zhang
 * @Date: 2020-05-23 13:54:30
 * @LastEditTime: 2020-06-07 18:25:19
 * @FilePath: /stock_app/lib/model/k/k_entrust.dart
 */ 
 

import 'dart:convert';

import 'package:app_stock/utils/number_util.dart';

class EntrustEntity {
  int type; //0买 1卖
  get typeName{
    if(type == 0) return '买';
    else if(type == 1) return '卖';
    else return '';
  }
  int index; //买卖 序号
  double price;
  int amount;
  EntrustEntity(this.index, this.type, this.amount, this.price);
}

class KLineEntrust{
  List<EntrustEntity> entrustBuy;

  List<EntrustEntity> entrustSale;

  KLineEntrust(){
    entrustBuy = [];
    entrustSale = [];
  }

  KLineEntrust.fromArray(List requestWt, preDayClose){

      entrustBuy = [];
      entrustSale = [];
    if(requestWt.length == 0) return;
      List a = jsonDecode(requestWt[0]);

      entrustBuy = [];
      for (int i = 0, j = 1; i < 5; i++, j++) {
        if (a[i] != null)
          entrustBuy.add(EntrustEntity(j, 0, a[i + 5],
              NumberUtil.getNumByValueDouble(a[i] + preDayClose)));
        else
          entrustBuy.add(EntrustEntity(j, 0, null, null));
      }

      for (int i = 10, j = 1; i <= 14; i++, j++) {
        if (a[i] != null) {
          entrustSale.add(EntrustEntity(j, 1, a[i + 5],
              NumberUtil.getNumByValueDouble(a[i] + preDayClose)));
        } else
          entrustSale.add(EntrustEntity(j, 1, null, null));
      }
  }

}

// mixin KEntrustEntity {
//   List<EntrustEntity> entrustBuy;
//   List<EntrustEntity> entrustSale;
// }