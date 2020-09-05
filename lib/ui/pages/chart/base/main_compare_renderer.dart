/*
 * @Author: zhang
 * @Date: 2020-05-27 20:52:24
 * @LastEditTime: 2020-06-10 23:22:23
 * @FilePath: /stock_app/lib/ui/pages/chart/base/main_compare_renderer.dart
 */ 


import 'dart:ui';

import 'package:app_stock/model/k/candle_entity.dart';
import 'package:app_stock/model/k/k_line_entity.dart';
import 'package:app_stock/ui/helper/chart_style.dart';
import 'package:app_stock/ui/pages/chart/base/base_rect.dart';
import 'package:app_stock/ui/pages/chart/base/main_renderer.dart';
import 'package:app_stock/ui/pages/chart/chart_state.dart';
import 'package:flutter/material.dart';

import 'dart:math' as Math;
import '../chart_state.dart';

class MainCompareRenderer extends MainRenderer {

  double maxPercent ;
  double minPercent;
  MainRect mainRect;
  double compareValue;//第一根的收盘价
  MainCompareRenderer(this.mainRect,   double topPadding,  painter ) : 
  super(mainRect, mainRect.mMainMidValue, topPadding, painter){
      double mMainCompareMaxPercent;
      double mMainCompareMinPercent;
      double mainMaxPercent;
      double mainMinPercent ;

      compareValue = mainRect.mMainCompareMidValue;
      if(!isLogAxis){
         mainMaxPercent =   getPercent(maxValue , super.lineValue);
         mainMinPercent =   getPercent(minValue , super.lineValue);

         mMainCompareMaxPercent = getPercent(mainRect.mMainCompareMaxValue, compareValue);
         mMainCompareMinPercent = getPercent(mainRect.mMainCompareMinValue, compareValue);
      }else{
         mainMaxPercent = maxValue ;
         mainMinPercent =   minValue ;

         mMainCompareMaxPercent = getPriceToLog(mainRect.mMainCompareMaxValue, line: compareValue);
         mMainCompareMinPercent = getPriceToLog(mainRect.mMainCompareMinValue, line: compareValue);
      }


      maxPercent = Math.max(mainMaxPercent, mMainCompareMaxPercent);
      minPercent = Math.min(mainMinPercent, mMainCompareMinPercent);

      if(MainState.K == mainRect.mainState){
          double diff = maxPercent - minPercent;
         // this.scaleY = (chartRect.height - contentPadding) / (maxPercent - minPercent);    
          var newScaleY = (chartRect.height - contentPadding) / diff; //内容区域高度/差=新的比例
          var newDiff = chartRect.height / newScaleY; //高/新比例=新的差
          var value = (newDiff - diff) / 2; //新差-差/2=y轴需要扩大的值
          if (newDiff > diff) {
            this.scaleY = newScaleY;
            this.maxPercent += value;
            this.minPercent -= value;
          }         
      }else if(MainState.FS == mainRect.mainState){
        if (maxPercent < 0) {
          maxPercent = minPercent.abs();
        } else if (minPercent > 0) {
          minPercent = 0 - maxPercent.abs();
        } else {
          if (maxPercent.abs() > minPercent.abs()) {
            minPercent = 0 - maxPercent.abs();
          } else {
            maxPercent = minPercent.abs();
          }
        }     
        
        this.scaleY = (chartRect.height - contentPadding) / (maxPercent.abs()*2);    
      }
  }
  
  Paint mCompareLinePaint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0
    ..color = ChartColors.dnCompareColor;

    @override
  void drawChart(Canvas canvas, Size size, CandleEntity lastPoint, CandleEntity curPoint, double lastX,
      double curX) {
        super.drawChart(canvas, size, lastPoint, curPoint, lastX, curX);

        for (int i = painter.mStartIndex; painter.compareDatas != null && i <= painter.mStopIndex; i++) {
          if(painter.compareDatas[i] == null ) continue;          
          KLineEntity curPoint = painter.compareDatas[i];
          KLineEntity lastPoint = (i == 0 || painter.compareDatas[i-1]==null) ? curPoint : painter.compareDatas[i - 1];
          double curX = painter.getX(i);
          double lastX = i == 0 ? curX : painter.getX(i - 1);

          if (MainState.K == mainRect.mainState) {
              drawCompareseCandle(curPoint, lastPoint, canvas, curX);
          }
          if (MainState.FS == mainRect.mainState) {
            drawComparseBrokenLine(lastPoint.close, curPoint.close, canvas, lastX, curX);
          }
        }
  }

  void drawCompareseCandle(CandleEntity curPoint, CandleEntity lastPoint, Canvas canvas,
      double curX) {
    if(curPoint == null) return;
    var high = getY(curPoint.high, lineValue: compareValue);
    var low = getY(curPoint.low, lineValue: compareValue);
    var open = getY(curPoint.open, lineValue: compareValue);
    var close = getY(curPoint.close, lineValue: compareValue);
    double r = mCandleWidth / 2;

    mCompareLinePaint.strokeWidth = 1;
    if (curPoint.close > curPoint.open) {
      mCompareLinePaint.color = ChartColors.upCompareColor;
      canvas.drawRect(Rect.fromLTRB(curX - r, close, curX + r, open), mCompareLinePaint..style = PaintingStyle.stroke);
      
      canvas.drawLine(Offset(curX , high),Offset(curX , close),mCompareLinePaint);
      canvas.drawLine(Offset(curX , low),Offset(curX , open),mCompareLinePaint);
    } else {
      if (curPoint.open == curPoint.close) {
        if (curPoint.open > lastPoint.close)
          mCompareLinePaint.color = ChartColors.upCompareColor;
        else
          mCompareLinePaint.color = ChartColors.dnCompareColor;
      } else
        mCompareLinePaint.color = ChartColors.dnCompareColor;
      canvas.drawRect(
          Rect.fromLTRB(curX - r, open, curX + r, close), mCompareLinePaint..style=PaintingStyle.fill);
          
      canvas.drawLine(Offset(curX , high),Offset(curX , open),mCompareLinePaint);
      canvas.drawLine(Offset(curX , low),Offset(curX , close),mCompareLinePaint);
    }
    
  }

    //画折线图
  drawComparseBrokenLine(double lastPrice, double curPrice, Canvas canvas, double lastX, double curX) {
    mLinePath ??= Path();

    if (lastX == curX) lastX = 0; //起点位置填充
    mLinePath.moveTo(lastX, getY(lastPrice, lineValue:compareValue));
    mLinePath.lineTo(curX, getY(curPrice, lineValue:compareValue));

    canvas.drawPath(mLinePath, mCompareLinePaint);
    mLinePath.reset();
  }

  @override
  void drawRightText(canvas, textStyle, int gridRows, {double firstValue}) {
    double rowSpace = chartRect.height / gridRows;
    for (var i = 0; i <= gridRows; ++i) {
      double positinLine = (gridRows - i) * rowSpace + topPadding;
      double position = 0;
      if (i == 0) {
        position = positinLine - contentPadding / 2;
      } else if (i == gridRows) {
        position = positinLine + contentPadding / 2;
      } else {
        position = positinLine;
      }
      double percent = getPrice(position);
     // var percent = value / firstValue - 1;
      TextSpan span =
          TextSpan(text: "${format(percent)}%", style: textStyle);
      TextPainter tp =
          TextPainter(text: span, textDirection: TextDirection.ltr);
      tp.layout();
      double y;
      if (i == gridRows) {
        y = positinLine;
      } else {
        y = positinLine - tp.height;
      }
      tp.paint(canvas, Offset(chartRect.width - tp.width, y));
    }
  }

  @override
  void drawGrid(Canvas canvas, int gridRows, int gridColumns) {
    super.drawGrid(canvas, gridRows, gridColumns);
  }

    @override
  void drawLeftText(canvas, textStyle, int gridRows) {
    
  }

  double getPrice(double y,) {
   double price =  maxPercent - ((y - chartRect.top) / scaleY );
   return price;
  }


  double getY(double price,{lineValue}) {
    double y;
    if(isLogAxis == true){
     y = super.getY(price, lineValue: lineValue);
    } else {
      y =  (maxPercent - getPercent(price, lineValue?? super.lineValue)) * scaleY + chartRect.top; 
    }
    return y;
  }

  
  double getPercent(double preValue, double lineValue){
    return  ((preValue - lineValue) / lineValue) * 100;
  }

}