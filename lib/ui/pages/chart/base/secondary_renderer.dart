/*
 * @Author: zhanghongtao
 * @Date: 2020-05-26 08:24:09
 * @LastEditTime: 2020-06-13 11:47:30
 * @FilePath: /stock_app/lib/ui/pages/chart/base/secondary_renderer.dart
 */
import 'dart:ui';

import 'package:app_stock/model/k/k_line_entity.dart';
import 'package:app_stock/model/k/secondary_entity.dart';
import 'package:app_stock/ui/helper/chart_style.dart';
import 'package:app_stock/utils/number_util.dart';
import 'package:flutter/material.dart';
import 'base_rect.dart';
import 'base_renderer.dart';

class SecondaryRenderer extends BaseChartRenderer<SecondaryEntity> {
  double mVolWidth = ChartStyle.volWidth;

  SecondaryRenderer(BaseRect secondaryRect, double topPadding, painter, {this.mVolWidth})
      : super(
            chartRect: secondaryRect,
            topPadding: topPadding,
            painter: painter) {
    chartRect.showIndex.registRender(this);
  }

  @override
  void drawChart(Canvas canvas, Size size, SecondaryEntity lastPoint,
      SecondaryEntity curPoint, double lastX, double curX) {
    chartRect.showIndex.drawChart(lastPoint, curPoint, canvas, lastX, curX);
  }

  @override
  void drawGrid(Canvas canvas, int gridRows, int gridColumns) {
    //画 Tag begin
    Paint tagPainter = Paint()
      ..filterQuality = FilterQuality.high
      ..strokeWidth = 1
      ..style = PaintingStyle.fill
      ..color = Colors.grey[300];

    double r = 1.0;

    canvas.drawRect(
        Rect.fromLTRB(
            chartRect.left + r,
            chartRect.top - ChartStyle.childPadding + r,
            chartRect.left + 40,
            chartRect.top - r),
        tagPainter);

    TextSpan tag = TextSpan(
        text: '${enumToString(chartRect.getState().toString())}',
        style: getTextStyle(Colors.black));
    TextPainter tp = TextPainter(text: tag, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, Offset(chartRect.left + 5, chartRect.top - tp.height));
    //画 Tag end
    
    double columnSpace = chartRect.width / gridColumns;
    for (int i = 0; i <= gridColumns; i++) {
      if (i == 0 || i == gridColumns) {
        canvas.drawLine(Offset(columnSpace * i, chartRect.top - topPadding),
            Offset(columnSpace * i, chartRect.bottom), gridPaint);
      }
      //vol垂直线
      else
        drawDashLine(canvas,columnSpace * i, chartRect.top,
            columnSpace * i, chartRect.bottom, gridPaint, type:1);
    }

    double rowSpace = chartRect.height / gridRows;

    canvas.drawLine(Offset(0, chartRect.top),
        Offset(chartRect.width, chartRect.top), gridPaint);

    drawDashLine(canvas, 0, rowSpace * 2 + chartRect.top,
        chartRect.width, rowSpace * 2 + chartRect.top, gridPaint);

    canvas.drawLine(Offset(0, chartRect.bottom),
        Offset(chartRect.width, chartRect.bottom), gridPaint);
  }

  @override
  void drawBottomTimeText(Canvas canvas, textStyle, int gridColumns, String s,
      String m, String e) {}

  @override
  void drawLeftText(canvas, textStyle, int gridRows) {
    TextSpan span = TextSpan(
        text: "最大值:${NumberUtil.volFormat(maxValue)}", style: textStyle);
    TextPainter tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, Offset(0, chartRect.top));
  }

  String enumToString(o) => o.toString().split('.').last;

  @override
  void drawRightText(canvas, textStyle, int gridRows, {double firstValue}) {}

  @override
  void drawCrossLineText(
      canvas, KLineEntity point, {double x, double y, int index, bool isLeft}) {
        chartRect.showIndex.drawCrossLineText(canvas, point);
  }
}
