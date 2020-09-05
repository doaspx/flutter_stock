/*
 * @Author: zhang
 * @Date: 2020-05-23 00:58:34
 * @LastEditTime: 2020-06-13 11:44:09
 * @FilePath: /stock_app/lib/ui/pages/chart/base/base_renderer.dart
 */ 

import 'package:app_stock/model/k/k_line_entity.dart';
import 'package:app_stock/ui/helper/chart_style.dart';
import 'package:app_stock/utils/number_util.dart';
import 'package:flutter/material.dart';

import 'base_painter.dart';
import 'base_rect.dart';

abstract class BaseChartRenderer<T> {
  double maxValue, minValue;
  double scaleY;
  double topPadding;
  BaseRect chartRect;
  BaseChartPainter painter;
  
 Paint chartPaint = Paint()
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.high
    ..strokeWidth = 1.0
    ..color = Colors.red;
    
  final Paint gridPaint = Paint()
    ..isAntiAlias = true
    ..filterQuality = FilterQuality.high
    ..strokeWidth = 0.5
    ..color = ChartColors.gridColor;

  BaseChartRenderer(
      {@required this.chartRect,
      @required this.topPadding,
      @required this.painter}
      ) {
    maxValue = chartRect.maxValue;
    minValue = chartRect.minValue;
    scaleY = chartRect.height / (maxValue - minValue); 
  }
 

  //scaleY = chartRect.height / (maxValue - minValue); 
  //scaleY = (y - top) / maxValue - price; 
  //maxValue - price  =  (y - top) /scaleY  
  double getY(double price) {
    price = convertPrice(price);
    double y =  (maxValue - price) * scaleY + chartRect.top; 
    return y;
  }

  double convertPrice(price){
    return price;
  }

  
  double getPrice(double y) {
   double price =  maxValue - ((y - chartRect.top) / scaleY );
   return price;
  }

  String format(double n) {
    return NumberUtil.format(n);
  }

  void drawGrid(Canvas canvas, int gridRows, int gridColumns);

  void drawLeftText(canvas, textStyle, int gridRows);

  void drawBottomTimeText(Canvas canvas, textStyle, int gridColumns, String f, String m, String e);

  void drawRightText(canvas, textStyle, int gridRows, {double firstValue});

  void drawCrossLineText(canvas, KLineEntity point, {double x, double y, int index}){}
  
  void drawChart( Canvas canvas, Size size, T lastPoint, T curPoint, double lastX, double curX);

  void drawLine(double lastPrice, double curPrice, Canvas canvas, double lastX, double curX, Color color) {
    double lastY = getY(lastPrice);
    double curY = getY(curPrice);
    chartPaint..color = color;//..strokeWidth = 1/painter.scaleX/4
    if(painter.scaleX < 0.5) {
      chartPaint..strokeWidth = 0.6/painter.scaleX ;
    }else{
      chartPaint..strokeWidth = 1;
    }
    canvas.drawLine(Offset(lastX, lastY), Offset(curX, curY), chartPaint);
  }

  TextStyle getTextStyle(Color color){
    return TextStyle(fontSize: ChartStyle.defaultTextSize,color: color);
  }

  void drawRect(Canvas canvas, double l, double t, double r, double b, Paint chartPaint,{Color lineColor}){
    if( painter.scaleX < 0.5) {
      Paint linePaint = chartPaint;
      linePaint.strokeWidth = 1 /painter.scaleX ;
      if(lineColor != null) linePaint.color = lineColor;
      canvas.drawLine(Offset((l+r)/2, t), Offset((l+r)/2, b), linePaint);
    }
    else canvas.drawRect(
          Rect.fromLTRB(l, t, r, b), chartPaint);
  }

  void drawDashLine(Canvas canvas, double x0, double y0, double x1, double y1, Paint paint, {type = 0}){
    if(type == 0){
      for(double x = x0; x<= x1; x+=6){
        canvas.drawLine(Offset(x, y0), Offset(x+3, y1), paint);
      }
    }else{
      for(double y = y0; y<= y1; y+=6){
        canvas.drawLine(Offset(x0, y), Offset(x1, y+3), paint);
      }
    }
  }

  TextPainter getTextPainter(text, {color = Colors.white}) {
    TextSpan span = TextSpan(text: "$text", style: getTextStyle(color));
    TextPainter tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    tp.layout();
    return tp;
  }    


  void realDrawChart(Canvas canvas, Size size,Map<double, int> map ,int maxtotal, KLineEntity point, int index) {}

  void drawMaxAndMin(Canvas canvas){}
}
