/*
 * @Author: zhanghongtao
 * @Date: 2020-05-29 08:20:15
 * @LastEditTime: 2020-06-13 11:42:51
 * @FilePath: /stock_app/lib/ui/pages/chart/base/main_renderer.dart
 */
import 'package:app_stock/model/k/candle_entity.dart';
import 'package:app_stock/model/k/k_line_entity.dart';
import 'package:app_stock/ui/helper/chart_style.dart';
import 'package:flutter/material.dart';
import '../chart_state.dart' show MainState;
import '../chart_state.dart';
import 'dart:math' as Math;
import 'base_rect.dart';
import 'base_renderer.dart';

class MainRenderer extends BaseChartRenderer<CandleEntity> {
  double mCandleWidth = ChartStyle.candleWidth;
  double mCandleLineWidth = ChartStyle.candleLineWidth;
  MainState state;
  double lineValue;//分时为前收盘，K线为第一个收盘价
  double contentPadding = 18;
  bool isLogAxis = false;
  MainRenderer(MainRect mainRect, this.lineValue, double topPadding, painter)
      : super(
            chartRect: mainRect,
            topPadding: topPadding,
            painter: painter) {

    state = mainRect.mainState;
    chartRect.showIndex.registRender(this);
    if (MainState.FS == state) {
      initFs();//计算最大值最小值
    } else {
      initK();
    }
  }

  initK(){
    var diff = maxValue - minValue; //计算差
      if (painter.isLogAxis == true) {
        
        isLogAxis = true;
        contentPadding = 0;

        minValue = getPriceToLog(minValue);
        maxValue = getPriceToLog(maxValue);
        diff = maxValue - minValue;
      }

      var newScaleY =
          (chartRect.height - contentPadding) / diff; //内容区域高度/差=新的比例
      var newDiff = chartRect.height / newScaleY; //高/新比例=新的差
      var value = (newDiff - diff) / 2; //新差-差/2=y轴需要扩大的值
      this.scaleY = newScaleY;
      if (newDiff > diff) {
        this.maxValue += value;
        this.minValue -= value;
      }
  }

  initFs(){
    var diff = maxValue - minValue; //计算差
      contentPadding = 0;

      double maxDiff = maxValue - lineValue;
      double minDiff = minValue - lineValue;
      
      if (maxDiff < 0) {
        double absDiff = minDiff.abs();
        diff = absDiff * 2;
        maxValue = lineValue + absDiff.abs();
      } else if (minDiff > 0) {
        double absDiff = maxDiff.abs();
        diff = absDiff * 2;
        minValue = lineValue - absDiff.abs();
      } else {
        double absDiff = (maxDiff.abs() - minDiff.abs());
        if (maxDiff.abs() > minDiff.abs()) {
          diff = maxDiff.abs() * 2;
          minValue = minValue - absDiff.abs();
        } else {
          diff = minDiff.abs() * 2;
          maxValue = maxValue + absDiff.abs();
        }
      }
      this.scaleY = (chartRect.height - contentPadding) / diff;     
  }


  @override
  void drawChart(Canvas canvas, Size size, CandleEntity lastPoint,
      CandleEntity curPoint, double lastX, double curX) {
    if (curPoint == null || lastPoint == null) return;
    if (MainState.K == state) {
      drawCandle(curPoint, lastPoint, canvas, curX);
      chartRect.showIndex.drawChart(lastPoint, curPoint, canvas, lastX, curX);
    }
    if (MainState.FS == state) {
      drawBrokenLine(lastPoint.close, curPoint.close, canvas, lastX, curX);
    }
  }

  void drawCyqChart(CandleEntity curPoint, CandleEntity lastPoint,
      Canvas canvas, double curX) {
    //  double x = getX(curPoint.close) + chartRect.left; //x柱子的长度
    double y = getY(curPoint.close);
    double x = chartRect.width / painter.scaleX;
    // double y = getX(curPoint.close);
    // // //double r = mVolWidth / 2;
    //  double top = getY(curPoint.close);

    canvas.drawLine(
        Offset(curX + x, y),
        Offset(curX + x + chartRect.width, y),
        chartPaint
          ..color = Colors.black
          ..strokeWidth = 1);
  }

  void drawCandle(CandleEntity curPoint, CandleEntity lastPoint, Canvas canvas,
      double curX) {
    var high = getY(curPoint.high);
    var low = getY(curPoint.low);
    var open = getY(curPoint.open);
    var close = getY(curPoint.close);

    double r = mCandleWidth / 2;


    double max ,min;
    chartPaint.strokeWidth = 1 / painter.scaleX;
    if (curPoint.close > curPoint.open) {
      max = close;
      min = open;
      chartPaint.color = ChartColors.upColor;
      // canvas.drawRect(
      //     Rect.fromLTRB(curX - r, close, curX + r, open), chartPaint..style=PaintingStyle.stroke);

      drawRect(canvas, curX - r, close, curX + r, open, chartPaint..style=PaintingStyle.stroke);
    } else {

      min = close;
      max = open;
      if (curPoint.open == curPoint.close) {
        if (curPoint.open > lastPoint.close)
          chartPaint.color = ChartColors.upColor;
        else chartPaint.color = ChartColors.dnColor;
      } else  chartPaint.color = ChartColors.dnColor;
      
      drawRect(canvas, curX - r, open, curX + r, close, chartPaint..style=PaintingStyle.fill);
    }
    canvas.drawLine(Offset(curX, high), Offset(curX, max), chartPaint);
    canvas.drawLine(Offset(curX, min), Offset(curX, low), chartPaint);
  }

  Path mLinePath;
  Paint mLinePaint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0
    ..color = ChartColors.kLineColor;

  //画折线图
  drawBrokenLine(double lastPrice, double curPrice, Canvas canvas, double lastX,
      double curX) {
    mLinePath ??= Path();

    if (lastX == curX) lastX = 0; //起点位置填充
    mLinePath.moveTo(lastX, getY(lastPrice));
    mLinePath.lineTo(curX, getY(curPrice));

    canvas.drawPath(mLinePath, mLinePaint);
    mLinePath.reset();
  }

  @override
  void drawLeftText(canvas, textStyle, int gridRows) {
    if(!isLogAxis){
      double rowSpace = chartRect.height / gridRows;
      for (var i = 0; i <= gridRows; ++i) {
        double position = 0;
        double positinLine = (gridRows - i) * rowSpace;

        if (i == 0) {
          position = positinLine - contentPadding / 2;
        } else if (i == gridRows) {
          position = positinLine + contentPadding / 2;
        } else {
          position = positinLine;
        }
        var value = getPrice(position);
        TextSpan span = TextSpan(text: "${format(value)}", style: textStyle);
        TextPainter tp =
            TextPainter(text: span, textDirection: TextDirection.ltr);
        tp.layout();
        double y;

        if (i == gridRows) {
          y = positinLine;
        } else {
          y = positinLine - tp.height;
        }
        tp.paint(canvas, Offset(0, y));
      }      
    }else{
      for (double p = this.minValue, i = 0.0; p <= this.maxValue; p++, i++) {

        var value = getPriceFromLog(p);
        TextSpan span = TextSpan(text: "${format(value)}", style: textStyle);
        TextPainter tp =
            TextPainter(text: span, textDirection: TextDirection.ltr);
        tp.layout();
        double y = super.getY(p);
        if(i == 0){
          y = y - tp.height;
        }
        tp.paint(canvas, Offset(0, y));
      }
    }
  }

  @override
  void drawRightText(canvas, textStyle, int gridRows, {double firstValue}) {
    if (state == MainState.FS) {
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
        double value = getPrice(position);
        var percent = value / firstValue - 1;
        TextSpan span =
            TextSpan(text: "${format(percent * 100)}%", style: textStyle);
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
  }

  void drawBottomTimeText(Canvas canvas, textStyle, int gridColumns,
      String firstValue, String midValue, String endValue) {
    double columnSpace = chartRect.width / gridColumns;
    String value = '';
    for (int i = 0; i <= gridColumns; i++) {
      if (i == 0 || i == gridColumns || i == 2) {
        if (i == 0)
          value = firstValue;
        else if (i == gridColumns)
          value = endValue;
        else
          value = midValue;
        TextSpan span = TextSpan(text: value, style: textStyle);
        TextPainter tp =
            TextPainter(text: span, textDirection: TextDirection.ltr);
        tp.layout();
        double y = painter.mDisplayHeight + ChartStyle.topPadding;
        double x = columnSpace * i;

        if (i == gridColumns) {
          x = x - tp.width;
        } else if (i == 2) {
          x = x - tp.width / 2;
        }
        tp.paint(canvas, Offset(x, y));
      }
    }
  }

  @override
  void drawGrid(Canvas canvas, int gridRows, int gridColumns) {
    //画竖线
    double columnSpace = chartRect.width / gridColumns;
    for (int i = 0; i <= gridColumns; i++) {
        if (i == 0 || i == gridColumns) {
          canvas.drawLine(Offset(columnSpace * i, topPadding),
              Offset(columnSpace * i, chartRect.bottom), gridPaint);
        }
        else{
          if (MainState.FS == state) {
              drawDashLine(canvas, columnSpace * i, topPadding, columnSpace * i, chartRect.bottom, gridPaint, type:1);
           } 
        }
    }

    if (!isLogAxis) {
      double rowSpace = chartRect.height / gridRows;
      for (int i = 0; i <= gridRows; i++) {
          if(i == 0 || i == gridRows){
                 canvas.drawLine(Offset(0, rowSpace * i + topPadding),
            Offset(chartRect.width, rowSpace * i + topPadding), gridPaint);
          }else{
            drawDashLine(canvas, 0, rowSpace * i + topPadding, chartRect.width, rowSpace * i + topPadding, gridPaint);
          }
      }
    } else {
      double rowSpace = chartRect.height / gridRows;
      for (int i = 0; i <= gridRows; i = i + gridRows) {
        canvas.drawLine(Offset(0, rowSpace * i + topPadding),
            Offset(chartRect.width, rowSpace * i + topPadding), gridPaint);
      }
      for (double p = this.minValue; p <= this.maxValue; p++) {
        canvas.drawLine(Offset(0, super.getY(p)), Offset(chartRect.width, super.getY(p)),
            gridPaint);
      }
    }
  }

  @override
  double getY(double price,{lineValue }) {
    if(isLogAxis == true) price =  getPriceToLog(price, line:lineValue);
    return super.getY(price); 
  }
  
  double getPriceToLog(double pt, {line}) {
    double log = Math.log(pt / (line??this.lineValue)) / Math.log(1 + 0.1);
    return log;
  }

  double getPriceFromLog(double log) {
    double pt = this.lineValue * Math.pow((1 + 0.1), log);
    return pt;
  }


  Paint selectPointPaint = Paint()
    ..isAntiAlias = true
    ..strokeWidth = 0.5
    ..color = ChartColors.markerBgColor;
  @override
  void drawCrossLineText(canvas, KLineEntity point,{double x, double y, int index, bool isLeft}) {
    
    double yPrcie = point.close;// mMainRenderer.getPrice(selectY);

    double y = getY(point.close);//selectY

    TextPainter tp = getTextPainter(format(yPrcie), color: Colors.white);
    double textHeight = tp.height;
    double textWidth = tp.width;
    double r = textHeight / 2; //文字 1/2 高度
    double lrPadding = 10;

      double x = 1;
      canvas.drawRect(
          Rect.fromLTRB(x, y - r, textWidth + 2 * lrPadding, y + r),
          selectPointPaint); //画左标签 背景
      tp.paint(canvas, Offset(x + lrPadding, y - textHeight / 2)); //画 左文字

    TextPainter dateTp;
    if (painter.mainState == MainState.FS)
      dateTp = getTextPainter(painter.getTime(point.id), color: Colors.white);
    else if (painter.mainState == MainState.K)
      dateTp = getTextPainter(painter.getDate(point.id), color: Colors.white);
    textWidth = dateTp.width;
    textHeight = dateTp.height;
    r = textHeight / 2;
    canvas.drawRect(
        Rect.fromLTRB(painter.selectX - textWidth / 2 - lrPadding, painter.mMainRect.height,
            painter.selectX + textWidth / 2 + lrPadding, painter.mMainRect.height + r * 2),
        selectPointPaint); // 画 日期 下
    dateTp.paint(canvas, Offset(painter.selectX - textWidth / 2, painter.mMainRect.height));

  }

  @override
  void drawMaxAndMin(Canvas canvas) {

    MainRect mMainRect = painter.mMainRect;
    //绘制最大值和最小值
    double x = painter.translateXtoX(painter.getX(mMainRect.mMainMinIndex));
    double y = getY(mMainRect.mMainLowMinValue);
    if (x < mMainRect.width / 2) {
      //画右边
      TextPainter tp = getTextPainter("── ${format(mMainRect.mMainLowMinValue)}",
          color: ChartColors.maxMinTextColor);
      tp.paint(canvas, Offset(x, y - tp.height / 2));
    } else {
      TextPainter tp = getTextPainter("${format(mMainRect.mMainLowMinValue)} ──",
          color: ChartColors.maxMinTextColor);
      tp.paint(canvas, Offset(x - tp.width, y - tp.height / 2));
    }

    x = painter.translateXtoX(painter.getX(mMainRect.mMainMaxIndex));
    y = getY(mMainRect.mMainHighMaxValue);
    if (x < mMainRect.width / 2) {
      //画右边
      TextPainter tp = getTextPainter("── ${format(mMainRect.mMainHighMaxValue)}",
          color: ChartColors.maxMinTextColor);
      tp.paint(canvas, Offset(x, y - tp.height / 2));
    } else {
      TextPainter tp = getTextPainter("${format(mMainRect.mMainHighMaxValue)} ──",
          color: ChartColors.maxMinTextColor);
      tp.paint(canvas, Offset(x - tp.width, y - tp.height / 2));
    }
  }
}
