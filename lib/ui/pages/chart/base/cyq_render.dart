/*
 * @Author: zhang
 * @Date: 2020-05-23 00:58:34
 * @LastEditTime: 2020-06-10 22:29:56
 * @FilePath: /stock_app/lib/ui/pages/chart/base/cyq_render.dart
 */ 
import 'dart:ui'; 
import 'package:app_stock/model/k/cyq_entity.dart';
import 'package:app_stock/model/k/k_line_entity.dart';
import 'package:app_stock/ui/helper/chart_style.dart';
import 'package:app_stock/ui/pages/chart/chart_state.dart';
import 'package:flutter/material.dart';
import 'base_painter.dart';
import 'base_rect.dart';
import 'base_renderer.dart';
import 'main_renderer.dart';

class CyqRenderer extends BaseChartRenderer<CyqEntity> {

  double maxYValue, minYValue;
  MainRenderer mainRenderer;
  CyqRect cyqRect;
  CyqRenderer( this.cyqRect,  this.mainRenderer , this.maxYValue, this.minYValue ,double topPadding, BaseChartPainter painter)
      : super(chartRect: cyqRect, topPadding: topPadding, painter: painter){
           scaleY = chartRect.height / (maxYValue - minYValue); 

  }

  @override
  void drawBottomTimeText(Canvas canvas, textStyle, int gridColumns, String f, String m, String e) {

  }

  @override
  void drawChart(Canvas canvas, Size size, CyqEntity lastPoint, CyqEntity curPoint, double lastX, double curX) {
    double line = painter.datas[painter.datas.length - 1].close;
    cyqRect.cyqMap.forEach((d, i){
        if(line >= d) chartPaint..color = ChartColors.dnColor..strokeWidth= 1;
        else chartPaint..color = ChartColors.upColor..strokeWidth= 1;
        double y;
       if(painter.axis == AxisType.LOG)  y = mainRenderer.getY(mainRenderer.getPriceToLog(d)); 
       else y = mainRenderer.getY(d); 
       double h = getLongByClose(i, cyqRect.cyqMaxTotal);
       
      canvas.drawLine(Offset(chartRect.left, y),
      Offset(chartRect.left+ h, y), 
     chartPaint);
    });
  }

  void realDrawChart(Canvas canvas, Size size ,Map<double, int>cyqMap, int maxTotal ,KLineEntity point, int index) {
    double line = point.close;
    cyqMap.forEach((d, i){
        if(line >= d) chartPaint..color = ChartColors.upColor..strokeWidth= 1;
        else chartPaint..color = ChartColors.dnColor..strokeWidth= 1;
      double y = mainRenderer.getY(d); 
      double h = getLongByClose(i,maxTotal);
       
      canvas.drawLine(Offset(chartRect.left, y),
      Offset(chartRect.left+ h, y), 
     chartPaint);
    });
  }


  @override
  void drawGrid(Canvas canvas, int gridRows, int gridColumns) {
    //画左线
    canvas.drawLine(Offset(chartRect.left, chartRect.top), Offset(chartRect.left, chartRect.bottom), gridPaint);
    //画下线
    canvas.drawLine(Offset(chartRect.left, chartRect.bottom), Offset(chartRect.right, chartRect.bottom), gridPaint);
    //画右线
    canvas.drawLine(Offset(chartRect.right, chartRect.top), Offset(chartRect.right, chartRect.bottom), gridPaint);
    //画Top
    canvas.drawLine(Offset(chartRect.left, chartRect.top), Offset(chartRect.right, chartRect.top), gridPaint);
  }

  double getLongByClose(int total,int cyqMaxTotal) {
    double pre = 120 / cyqMaxTotal;
    double y =  total * pre;
    return y;
  }

  @override
  void drawLeftText(canvas, textStyle, int gridRows) {

  }

  @override
  void drawRightText(canvas, textStyle, int gridRows, {double firstValue}) {

  }

}
