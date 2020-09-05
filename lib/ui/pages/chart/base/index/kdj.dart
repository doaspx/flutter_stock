/*
 * @Author: zhang
 * @Date: 2020-06-01 00:42:29
 * @LastEditTime: 2020-06-10 13:50:42
 * @FilePath: \stock_app\lib\ui\pages\lib\base\index\kdj.dart
 */ 


import 'dart:math';
import 'dart:ui';

import 'package:app_stock/model/k/k_line_entity.dart';
import 'package:app_stock/model/k/kdj_entity.dart';
import 'package:app_stock/ui/helper/chart_style.dart';
import 'package:flutter/material.dart';

import '../base_renderer.dart';
import 'base_index.dart';

class KDJIndex extends BaseIndex<KDJEntity>{
  
  BaseChartRenderer _render;
  
  @override
  calcMaxMinValue(KLineEntity item, int i){
      if(item.k != null && item.d != null && item.j != null){
        maxPrice = max(maxPrice, max(item.k, max(item.d, item.j)));
        minPrice = min(minPrice, min(item.k, min(item.d, item.j)));   
      }     
  }

  @override
  void drawChart(KDJEntity lastPoint, KDJEntity curPoint, Canvas canvas, double lastX, double curX) {
       if(curPoint.k == null && curPoint.d == null && curPoint.j==null) return;

        if (lastPoint.k != 0) _render.drawLine(lastPoint.k, curPoint.k, canvas, lastX, curX, ChartColors.kColor);
        if (lastPoint.d != 0) _render.drawLine(lastPoint.d, curPoint.d, canvas, lastX, curX, ChartColors.dColor);
        if (lastPoint.j != 0) _render.drawLine(lastPoint.j, curPoint.j, canvas, lastX, curX, ChartColors.jColor);   
  }


  @override
  void registRender(BaseChartRenderer render) {
      _render = render;
  }

  @override
  void drawCrossLineText(canvas, KLineEntity point) {
        List<TextSpan> children = [
          if (point.k != 0)
            TextSpan(
                text: "K:${_render.format(point.k)}   ",
                style: _render.getTextStyle(ChartColors.kColor)),
          if (point.dif != 0)
            TextSpan(
                text: "D:${_render.format(point.d)}   ",
                style: _render.getTextStyle(ChartColors.dColor)),
          if (point.dea != 0)
            TextSpan(
                text: "J:${_render.format(point.j)}   ",
                style: _render.getTextStyle(ChartColors.jColor)),
        ];

    TextPainter volTp = TextPainter(
        text: TextSpan(children: children), textDirection: TextDirection.ltr);
    volTp.layout();
    double textHeight = volTp.height;
    volTp.paint(canvas, Offset(42, _render.chartRect.top - textHeight));
  }


}