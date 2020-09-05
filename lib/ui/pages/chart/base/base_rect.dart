/*
    * @Author: zhang
    * @Date: 2020-05-28 20:23:48
 * @LastEditTime: 2020-06-19 17:30:49
 * @FilePath: \stock_app\lib\ui\pages\chart\base\base_rect.dart
    */
import 'dart:math';

import 'package:app_stock/model/k/k_line_entity.dart';
import 'package:app_stock/ui/pages/chart/base/base_painter.dart';
import 'package:app_stock/ui/pages/chart/base/index/base_index.dart';
import 'package:app_stock/ui/pages/chart/chart_state.dart';
import 'package:flutter/material.dart';

import '../chart_state.dart';

abstract class BaseRect extends Rect {
  Rect rect;
  BaseChartPainter painter;
  BaseIndex showIndex;
  double maxValue = -double.maxFinite, minValue = double.maxFinite;

  BaseRect.fromLTRB(
      double left, double top, double right, double bottom, this.painter, this.showIndex)
      : super.fromLTRB(left, top, right, bottom);

  void calcMaxMinValue(KLineEntity item, int index);

  double getPercent(double preValue, double lineValue) {
    return ((preValue - lineValue) / lineValue) * 100;
  }

   getState();

  get mStartIndex => painter.mStartIndex;

  get mStopIndex => painter.mStopIndex;

  get mMidIndex => painter.mMidIndex;
}

class MainRect extends BaseRect {
  KLineEntity mStartItem, mStopItem, mMidItem; //日期或者时间
  double mMainMaxValue = -double.maxFinite, mMainMinValue = double.maxFinite;
  double mMainMidValue = -double.maxFinite;

  int mMainMaxIndex = 0, mMainMinIndex = 0;

  double mMainCompareMaxValue = -double.maxFinite, mMainCompareMinValue = double.maxFinite;
  double mMainCompareMidValue = -double.maxFinite;

  double mMainHighMaxValue = -double.maxFinite,
      mMainLowMinValue = double.maxFinite; //绘制最大值和最小值
  MainState mainState;

  MainRect.fromLTRB(double left, double top, double right, double bottom,
      this.mainState, BaseChartPainter painter, showIndex)
      : super.fromLTRB(left, top, right, bottom, painter, showIndex);

  @override
  void calcMaxMinValue(KLineEntity item, int i) {
    if (i == mStartIndex)  mStartItem = item;
    if (i == mMidIndex)  mMidItem = item;
    if (i == mStopIndex) mStopItem = item;

    if (MainState.FS == mainState) {
      
      if (i == mStartIndex)   {
        print('计算FS');
        mMainMidValue = item.preDayClose ?? item.close; 
      }
      maxValue = mMainMaxValue = max(mMainMaxValue, item.close);
      minValue = mMainMinValue = min(mMainMinValue, item.close);

      if (painter.compareDatas != null && i < painter.compareDatas.length) {
        if(i == mStartIndex) {          
          mMainCompareMidValue = painter.compareDatas[mStartIndex].preDayClose;
        }
        mMainCompareMaxValue = max(mMainCompareMaxValue,  painter.compareDatas[i].close,);
        mMainCompareMinValue = min(mMainCompareMinValue,  painter.compareDatas[i].close,);
        
      }
    } else {      
      if (i == mStartIndex)   {
        print('计算K');
        mMainMidValue = item.close; 
      }

      if (painter.compareDatas != null &&
          i < painter.compareDatas.length &&
          painter.compareDatas[i] != null &&
          painter.compareDatas[mStartIndex] != null) {
        if(i == mStartIndex) mMainCompareMidValue = painter.compareDatas[mStartIndex].close;
        mMainCompareMaxValue = max(mMainCompareMaxValue, painter.compareDatas[i].close,);
        mMainCompareMinValue = min(mMainCompareMinValue,  painter.compareDatas[i].close,);
      }

     // print('calc MaxMin:${item.high}, ${item.low}');
  //    if(item.high == null || item.low == null )return;
      showIndex.calcMaxMinValue(item, i);
       maxValue = mMainMaxValue = max(mMainMaxValue, showIndex.maxPrice);
       minValue = mMainMinValue = min(mMainMinValue, showIndex.minPrice);

      if (mMainHighMaxValue < item.high) {
        mMainHighMaxValue = item.high; //最大值，最小值使用
        mMainMaxIndex = i;
      }
      if (mMainLowMinValue > item.low) {
        mMainLowMinValue = item.low;
        mMainMinIndex = i;
      }
    }
  }


  @override
  getState() {
    return mainState;
  }
}

class SecondaryRect extends BaseRect {

    SecondaryState secondaryState;//外部使用，及打标签
    int index; 
  SecondaryRect.fromLTRB(double left, double top, double right, double bottom,
      BaseChartPainter painter, this.secondaryState, this.index, showIndex)
      : super.fromLTRB(left, top, right, bottom, painter, showIndex);

  @override
  void calcMaxMinValue(KLineEntity item, int index) {
        showIndex.calcMaxMinValue(item, index);
        maxValue = showIndex.maxPrice;
        minValue = showIndex.minPrice;
  }
  @override
  getState() {
    return secondaryState;
  }
}

class CyqRect extends BaseRect {
  //double mCyqMaxValue = -double.maxFinite, mCyqMinValue = double.maxFinite;
  Map<double, int> cyqMap = {};
  int cyqMaxTotal = 0;
  CyqState cyqState;
  CyqRect.fromLTRB(double left, double top, double right, double bottom,
      BaseChartPainter painter, this.cyqState)
      : super.fromLTRB(left, top, right, bottom, painter, null);

  @override
  void calcMaxMinValue(KLineEntity item, int index) {
    maxValue = max(maxValue, item.close);
    minValue = 0;
    for (double i = item.low; i < item.high; i = i + 0.1) {
      if (cyqMap[i] != null) {
        cyqMap[i] = cyqMap[i] + 1;
      } else {
        cyqMap[i] = 1;
      }
      cyqMaxTotal = max(cyqMaxTotal, cyqMap[i]);
    }
  }


  @override
  getState() {
    return cyqState;
  }
}
