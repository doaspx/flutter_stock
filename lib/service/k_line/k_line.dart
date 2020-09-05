/*
 * @Author: zhang
 * @Date: 2020-05-26 19:47:40
 * @LastEditTime: 2020-09-05 15:01:39
 * @FilePath: /stock_app/lib/service/k_line/k_line.dart
 */ 

import 'dart:convert';
 
import 'package:app_stock/model/base_response.dart';
import 'package:flutter/services.dart';
 

class KLineService{
  KLineService._();
  
  /// @description: 获取所有股票，加入缓存
  /// @param {type} 
  /// @return: 
  static dynamic loadAllStocks() async {

    var result = await rootBundle.loadString('assets/resources/stocks.json');
    List res =  jsonDecode(result);
    return res;
  }



  
  /// @description: 获取所有股票，加入缓存
  /// @param {type} 
  /// @return: 
  static dynamic loadKLine(Map map) async {
    BaseResponseEntity info = BaseResponseEntity();

    var result = await rootBundle.loadString('assets/resources/k.json');
     info.records =  jsonDecode(result);
    return info;
  }

  static dynamic loadAllFs(Map map) async {

    BaseResponseEntity info = BaseResponseEntity();

        var result = await rootBundle.loadString('assets/resources/fs.json');
     info.record =  jsonDecode(result);
    return info;
  }

}