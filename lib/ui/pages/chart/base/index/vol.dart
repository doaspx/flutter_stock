/*
 * @Author: zhang
 * @Date: 2020-06-09 22:08:04
 * @LastEditTime: 2020-06-13 11:11:53
 * @FilePath: /stock_app/lib/ui/pages/chart/base/index/vol.dart
 */

import 'dart:math';
import 'dart:ui';

import 'package:app_stock/model/k/k_line_entity.dart';
import 'package:app_stock/model/k/volume_entity.dart';
import 'package:app_stock/ui/helper/chart_style.dart';
import 'package:app_stock/ui/pages/chart/chart_state.dart';
import 'package:app_stock/utils/number_util.dart';
import 'package:flutter/material.dart';

import '../base_renderer.dart';
import 'base_index.dart';

class VOLIndex extends BaseIndex<VolumeEntity> {
  BaseChartRenderer _render;

  @override
  calcMaxMinValue(KLineEntity item, int i) {
    maxPrice = max(maxPrice,
        max(item.vol, max(item.mA5Volume ?? 0, item.mA10Volume ?? 0)));
    minPrice = min(minPrice,
        min(item.vol, min(item.mA5Volume ?? 0, item.mA10Volume ?? 0)));
  }

  @override
  void drawChart(VolumeEntity lastPoint, VolumeEntity curPoint, Canvas canvas,
      double lastX, double curX) {
   double r =  ChartStyle.candleWidth / 2;
    double top = _render.getY(curPoint.vol);
    double bottom = _render.chartRect.bottom; //

    if(_render.painter.mainState == MainState.FS){
      canvas.drawLine(
          Offset(curX, top),
          Offset(curX, bottom),
          chartPaint
            ..color = ChartColors.upColor
            ..strokeWidth = 1 / _render.painter.scaleX);

    }else {
      if (curPoint.isDown)
              _render.drawRect(canvas, curX-r, top, curX+r, bottom, chartPaint
              ..color = ChartColors.dnColor
              ..style = PaintingStyle.fill , lineColor: ChartColors.scaleLineColor);
      else
            _render.drawRect(canvas, curX-r, top, curX+r, bottom, chartPaint
              ..color = ChartColors.upColor
              ..style = PaintingStyle.stroke, 
              lineColor: ChartColors.scaleLineColor);
    }



    if (lastPoint.mA5Volume != 0 && lastPoint.mA5Volume != null) {
      _render.drawLine(lastPoint.mA5Volume, curPoint.mA5Volume, canvas, lastX,
          curX, ChartColors.ma5Color);
    }

    if (lastPoint.mA10Volume != 0 && lastPoint.mA10Volume != null) {
      _render.drawLine(lastPoint.mA10Volume, curPoint.mA10Volume, canvas, lastX,
          curX, ChartColors.ma10Color);
    }
  }

  @override
  void registRender(BaseChartRenderer render) {
    _render = render;
  }

  @override
  void drawCrossLineText(canvas, KLineEntity point) {
    List<TextSpan> children = [
      TextSpan(
          text: "成交量：${NumberUtil.volFormat(point.vol)}",
          style: _render.getTextStyle(ChartColors.yAxisTextColor))
    ];

    TextPainter volTp = TextPainter(
        text: TextSpan(children: children), textDirection: TextDirection.ltr);
    volTp.layout();
    double textHeight = volTp.height;
    volTp.paint(canvas, Offset(42, _render.chartRect.top - textHeight));
  }
}
