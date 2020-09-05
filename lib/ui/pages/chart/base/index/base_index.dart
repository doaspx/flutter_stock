/*
 * @Author: zhang
 * @Date: 2020-06-01 00:42:29
 * @LastEditTime: 2020-06-10 15:12:46
 * @FilePath: \stock_app\lib\ui\pages\lib\base\index\base_index.dart
 */ 

import 'dart:ui';

import 'package:app_stock/model/k/k_line_entity.dart';
import 'package:app_stock/ui/pages/chart/base/base_renderer.dart';
import 'package:flutter/material.dart';

 abstract class BaseIndex<T>{
  double maxPrice = -double.maxFinite;
  double minPrice = double.maxFinite;
  
   Paint chartPaint = Paint()
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.high
    ..strokeWidth = 1.0
    ..color = Colors.red;

  void registRender(BaseChartRenderer render){}

  void calcMaxMinValue(KLineEntity item, int i){}

  void drawChart(T lastPoint, T curPoint, Canvas canvas, double lastX, double curX){}

  void drawCrossLineText(canvas, KLineEntity point){}
}