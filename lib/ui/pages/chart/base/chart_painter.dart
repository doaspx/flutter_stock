/*
 * @Author: zhanghongtao
 * @Date: 2020-05-29 08:20:15
 * @LastEditTime: 2020-06-13 18:41:19
 * @FilePath: /stock_app/lib/ui/pages/chart/base/chart_painter.dart
 */ 
import 'dart:async';
import 'dart:math';

import 'package:app_stock/model/k/k_line_entity.dart';
import 'package:app_stock/model/k/selected_entity.dart';
import 'package:app_stock/ui/helper/chart_style.dart';
import 'package:app_stock/ui/pages/chart/base/index/ma.dart';
import 'package:flutter/material.dart';
import '../chart_state.dart';

import 'base_painter.dart';
import 'base_rect.dart';
import 'base_renderer.dart';
import 'base_renderer_factory.dart';
import 'index/index_factory.dart';
import 'main_renderer.dart';


class ChartPainter extends BaseChartPainter {
  static get maxScrollX => BaseChartPainter.maxScrollX;
  static get showCount => BaseChartPainter.showCount;
  MainRenderer mMainRenderer; BaseChartRenderer mCyqRenderer;
  List<BaseChartRenderer> mSecondaryRenderer;
  StreamSink<SelectedKEntity> sink;


  ChartPainter({
    @required datas,
    @required scaleX,
    @required scrollX,
    @required isLongPress,
    @required selectX,
    @required selectY,
    @required isFullScreen,
    mainState,
    secondaryStates,
    cyqState,
    this.sink,
    compareDatas,
    axis ,
  }) : super(
            datas: datas,
            compareDatas:compareDatas,
            scaleX: scaleX,
            scrollX: scrollX,
            isLongPress: isLongPress,
            selectX: selectX,
            selectY: selectY,
            mainState: mainState,
            secondaryStates: secondaryStates,
            cyqState: cyqState,
            axis:axis,
            isFullScreen: isFullScreen);

  @override
  void initChartRenderer() {
    mMainRenderer ??= RenderFactory.createMainRender(this, this.mMainRect);    
    mSecondaryRenderer = [];
      for(int i = 0 ;  i < mSecondaryRectCounts; i++){
        BaseChartRenderer renderer =  RenderFactory.createVolRender(this, mSecondaryRects[i]);
        mSecondaryRenderer.add(renderer);
      }
    mCyqRenderer ??= RenderFactory.createCyqRender(this, this.mCyqRect ,this.mMainRenderer);
  }

  final Paint mBgPaint = Paint()..color = ChartColors.bgColor;


  createSecondaryReacts(){
      mSecondaryRects = []; 
      double secondaryHeight = mDisplayHeight * mSecondaryRadio;
      BaseRect topRect = mMainRect;

      for(int i = 0 ;  i < mSecondaryRectCounts; i++){
        BaseRect mSecondaryRect =  
        SecondaryRect.fromLTRB(0, topRect.bottom+ ChartStyle.childPadding, mMainRect.width, (topRect.bottom)  + secondaryHeight, this, secondaryStates[i], i, SecondIndexFactory.create(secondaryStates[i]));
        mSecondaryRects.add(mSecondaryRect);
        topRect = mSecondaryRect;
      }
  }

  @override
  void initData(Size size) {
      super.initData(size);

      double mainHeight = mDisplayHeight * ( 1 - mSecondaryRadio * mSecondaryRectCounts );      
      double volHeight = mDisplayHeight * mSecondaryRadio;
      double mainWidth = mWidth;
      if(cyqState == CyqState.CYQ) mainWidth = mainWidth - cyqWidth ;

      mMainRect = MainRect.fromLTRB(0, ChartStyle.topPadding, mainWidth, ChartStyle.topPadding + mainHeight , 
      mainState, this, MAIndex());

      createSecondaryReacts();

      if(cyqState == CyqState.CYQ) mCyqRect = CyqRect.fromLTRB(mMainRect.right + ChartStyle.rightPadding, ChartStyle.topPadding, 
      mWidth, mMainRect.bottom + volHeight, this, cyqState);    
      
      setSelectedRect();
  }

  @override
  void drawGrid(canvas) {
    mMainRenderer?.drawGrid( canvas, ChartStyle.gridRows, ChartStyle.gridColumns);

    for(int i = 0; i< mSecondaryRectCounts ; i++){
      mSecondaryRenderer[i]?.drawGrid(canvas, ChartStyle.gridRows, ChartStyle.gridColumns);
    }

    mCyqRenderer?.drawGrid(canvas, 0, 0);
  }

  @override
  void drawChart(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(mTranslateX * scaleX, 0.0);
    canvas.scale(scaleX, 1.0);
    for (int i = mStartIndex; datas != null && i <= mStopIndex; i++) {
      KLineEntity curPoint = datas[i];
      if (curPoint == null) continue;
      KLineEntity lastPoint = i == 0 ? curPoint : datas[i - 1];
      double curX = getX(i);
      double lastX = i == mStartIndex ? curX : getX(i - 1);

      mMainRenderer?.drawChart(canvas, size, lastPoint, curPoint, lastX, curX);

      for(int i= 0; i< mSecondaryRectCounts; i++){
        mSecondaryRenderer[i]?.drawChart(canvas, size, lastPoint, curPoint, lastX, curX);
      }
    }
    if (isLongPress == true) drawCrossLine(canvas, size);
    canvas.restore();

    if (isLongPress == false)
      mCyqRenderer?.drawChart(canvas, size, null, null, null, null);
    if (isLongPress == true) {
      drawCrossLineText(canvas, size);
    }
  }

  @override
  void drawLeftText(canvas) {
    var textStyle = getTextStyle(ChartColors.yAxisTextColor);
    mMainRenderer?.drawLeftText(canvas, textStyle, ChartStyle.gridRows);

    for(int i= 0; i< mSecondaryRectCounts; i++){
        mSecondaryRenderer[i]?.drawLeftText(canvas, textStyle, ChartStyle.gridRows);
    }
  }

  @override
  void drawRightText(canvas) {
    if (MainState.FS == mainState) {
      var textStyle = getTextStyle(ChartColors.yAxisTextColor);
      mMainRenderer?.drawRightText(canvas, textStyle, ChartStyle.gridRows,
          firstValue: mMainRect.mMainMidValue);
    }else if(MainState.K == mainState){
      var textStyle = getTextStyle(ChartColors.yAxisTextColor);
      mMainRenderer?.drawRightText(canvas, textStyle, ChartStyle.gridRows,
          firstValue: mMainRect.mMainMidValue);      
    }
  }

  @override
  void drawBottomText(canvas) {
    var textStyle = getTextStyle(ChartColors.yAxisTextColor);
    String firstValue, midValue, endValue;
    if (mMainRect.mainState == MainState.FS) {
      firstValue = getTime(mMainRect.mStartItem.id);
      if (mMainRect.mMidItem != null) midValue = '11:30'; //getTime(mMidItem.id);
      if (mMainRect.mStopItem != null) endValue = getTime(mMainRect.mStopItem.id);
    }

    if (mMainRect.mainState == MainState.K) {
      firstValue = getDate(mMainRect.mStartItem.id);
      midValue = getDate(mMainRect.mMidItem.id);
      endValue = getDate(mMainRect.mStopItem.id);
    }
    mMainRenderer?.drawBottomTimeText(
        canvas, textStyle, ChartStyle.gridRows, firstValue, midValue, endValue);
  }


  @override
  void drawMaxAndMin(Canvas canvas) {
     mMainRenderer.drawMaxAndMin(canvas);
  }

  @override
  void drawCrossLineText(Canvas canvas, Size size) {
    if (!isLongPress) return;

    var index = calculateSelectedX(selectX);
    KLineEntity point = getItem(index);

    
    bool isLeft = false;
    if (translateXtoX(getX(index)) < mMainRect.width / 2)  isLeft = false;
    else isLeft = true;    

    mMainRenderer.drawCrossLineText(canvas, point, index: index, isLeft: isLeft);

    for(int i= 0 ; i< mSecondaryRectCounts; i++){
      mSecondaryRenderer[i].drawCrossLineText(canvas, point, index:index);
    }

    if (mCyqRenderer != null) {
      Map<double, int> maps = calcY(datas, index);
      int maxTotal = 0;
      maps.forEach((d, i) {
        maxTotal = max(maxTotal, i);
      });
      mCyqRenderer.realDrawChart(canvas, size, maps, maxTotal, point, index);
    }
    sink?.add(SelectedKEntity(point, isLeft));
  }

  Map<double, int> calcY(List<KLineEntity> dataList, int selectIndex) {
    int init = 0;
    if (selectIndex > 150) {
      init = selectIndex - 150;
    }

    Map<double, int> cyqMap = {};
    int maxCyqTotal = 0;
    for (int j = init; j <= selectIndex; j++) {
      for (double m = dataList[j].low; m <= dataList[j].high; m = m + 0.1) {
        if (cyqMap[m] != null) {
          cyqMap[m] = cyqMap[m] + 1;
        } else {
          cyqMap[m] = 1;
        }
        maxCyqTotal = max(maxCyqTotal, cyqMap[m]);
      }
    }
    return cyqMap;
  }

  ///画交叉线
  void drawCrossLine(Canvas canvas, Size size) {
    if (!isLongPress) return;

    var index = calculateSelectedX(selectX);
    KLineEntity point = getItem(index);
    Paint paintY = Paint()
      ..color = Colors.black
      ..strokeWidth = ChartStyle.hvCrossWidth/scaleX
      ..isAntiAlias = true;
    double x = getX(index);

    double y  = getMainY(point.close);//selectY
    // 画纵线
    canvas.drawLine(Offset(x, ChartStyle.topPadding), Offset(x, mDisplayHeight), paintY);

    Paint paintX = Paint()
      ..color = Colors.black
      ..strokeWidth = ChartStyle.hvCrossWidth
      ..isAntiAlias = true;
    // 画横线
    canvas.drawLine(Offset(-mTranslateX, y), Offset(-mTranslateX + mWidth / scaleX, y), paintX);
    canvas.drawCircle(Offset(x, y), 2.0, paintX);

    // //画纵线
    // canvas.drawLine(
    //     Offset(x, ChartStyle.topPadding), Offset(x, mDisplayHeight), paintY);

    // Paint paintX = Paint()
    //   ..color = Colors.black
    //   ..strokeWidth = ChartStyle.hvCrossWidth;

    // // k线图横线
    // canvas.drawLine(
    //     Offset(-mTranslateX, y),
    //     Offset(-mTranslateX + mMainRect.width / scaleX, y),
    //     Paint()
    //       ..color = Colors.black
    //       ..strokeWidth = ChartStyle.hvCrossWidth);
    // canvas.drawCircle(Offset(x, y), 2.0, paintX);
  }

  double getMainY(double y) {
   // if(axis == AxisType.LOG) y = mMainRenderer.getPriceTo
    return mMainRenderer?.getY(y) ?? 0.0;
  }
}
