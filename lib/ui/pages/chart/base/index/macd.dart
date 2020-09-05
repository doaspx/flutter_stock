/*
 * @Author: zhang
 * @Date: 2020-06-09 21:49:22
 * @LastEditTime: 2020-06-12 20:55:59
 * @FilePath: /stock_app/lib/ui/pages/chart/base/index/macd.dart
 */ 
import 'dart:math';
import 'dart:ui';

import 'package:app_stock/model/k/k_line_entity.dart';
import 'package:app_stock/model/k/macd_entity.dart';
import 'package:app_stock/ui/helper/chart_style.dart';
import 'package:flutter/material.dart';

import '../base_renderer.dart';
import 'base_index.dart';

class MACDIndex extends BaseIndex<MACDEntity>{
  
  BaseChartRenderer _render;
  
  @override
  calcMaxMinValue(KLineEntity item, int i){
        if(item.macd != null && item.dif != null && item.dea != null){
          maxPrice= max(maxPrice, max(item.macd, max(item.dif, item.dea)));
          minPrice = min(minPrice, min(item.macd, min(item.dif, item.dea)));  
        }  
  }

  @override
  void drawChart(MACDEntity lastPoint, MACDEntity curPoint, Canvas canvas, double lastX, double curX) {
        if(curPoint.macd == null && curPoint.dif == null && curPoint.dea==null) return;

        double macdY = _render.getY(curPoint.macd);
        double r = ChartStyle.macdWidth / 2;
        double zeroy = _render.getY(0);     
        if (curPoint.macd > 0) {
          canvas.drawRect(
              Rect.fromLTRB(curX - r, macdY, curX + r, zeroy), chartPaint..color = ChartColors.upColor);
        } 
        else canvas.drawRect(Rect.fromLTRB(curX - r, zeroy, curX + r, macdY), chartPaint..color = ChartColors.dnColor);
        
        if (lastPoint.dif != 0) {
          _render.drawLine(lastPoint.dif, curPoint.dif, canvas, lastX, curX, ChartColors.difColor);
        }
        if (lastPoint.dea != 0) {
          _render.drawLine(lastPoint.dea, curPoint.dea, canvas, lastX, curX, ChartColors.deaColor);
        }    
  }


  @override
  void registRender(BaseChartRenderer render) {
      _render = render;
  }

  @override
  void drawCrossLineText(canvas, KLineEntity point) {
        List<TextSpan> children  = [
          if (point.dif != 0)
            TextSpan(
                text: "DIF:${_render.format(point.dif)}    ",
                style: _render.getTextStyle(ChartColors.kColor)),
          if (point.dea != 0)
            TextSpan(
                text: "DEA:${_render.format(point.dea)}    ",
                style: _render.getTextStyle(ChartColors.dColor)),
          if (point.macd != 0)
            TextSpan(
                text: "M:${_render.format(point.macd)}    ",
                style: _render.getTextStyle(ChartColors.jColor)),
        ];

    TextPainter volTp = TextPainter(
        text: TextSpan(children: children), textDirection: TextDirection.ltr);
    volTp.layout();
    double textHeight = volTp.height;
    volTp.paint(canvas, Offset(42, _render.chartRect.top - textHeight));
  }
}