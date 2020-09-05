/*
 * @Author: zhanghongtao
 * @Date: 2020-05-20 00:20:15
 * @LastEditTime: 2020-06-13 18:41:09
 * @FilePath: /stock_app/lib/ui/pages/chart/base/base_painter.dart
 */ 

import 'package:app_stock/model/k/k_line_entity.dart';
import 'package:app_stock/ui/helper/chart_style.dart';
import 'package:app_stock/utils/date_format_util.dart';
import 'package:app_stock/utils/number_util.dart';
import 'package:flutter/material.dart' show Canvas, Color, CustomPainter, Size, TextStyle, required;
import '../chart_state.dart' ;
import 'base_rect.dart';

abstract class BaseChartPainter extends CustomPainter {
  //Size mainSize; //主屏幕宽度
  
  double mDataLen = 0.0; //数据占屏幕总长度
  int mItemCount = 0; //数组的数量

  static double maxScrollX = 0.0; //偏移量
  static int showCount = 0;

  List<KLineEntity> datas; //数据列表
  List<KLineEntity> compareDatas;

  MainState mainState = MainState.NONE;

  List secondaryStates;

  CyqState cyqState = CyqState.NONE;

  double scaleX = 1.0,selectX, selectY; //缩放比例，
  
  double  scrollX = 0.0; //初始偏移量
  double mTranslateX = -double.maxFinite; //偏移量
  double mPointWidth = ChartStyle.pointWidth; //点与点的距离
  bool isLongPress = false;

  //3块区域大小与位置
  MainRect mMainRect;
  double mDisplayHeight, mWidth; //mDisplayHeight: 效果图总高度（size.height）, mWidth :size.width

  int mStartIndex = 0, mStopIndex = 0 , mMidIndex = 0;

  BaseRect mCyqRect;

  int   mSecondaryRectCounts ;
  double mSecondaryRadio;
  List<BaseRect> mSecondaryRects;

  double mMarginRight = 0; 

  double cyqWidth = 120;

  bool isFullScreen;

  AxisType axis ; //坐标系类型


  BaseChartPainter(
      {
      @required this.datas,
      @required this.scaleX,
      @required this.scrollX,
      @required this.isLongPress,
      @required this.selectX,
      @required this.selectY,
      @required this.mainState,
      @required this.secondaryStates,
      @required this.cyqState,
      @required this.isFullScreen,
      this.axis = AxisType.LOG,
      this.compareDatas,}) {
    mItemCount = datas?.length ?? 0;
    mDataLen = mItemCount * mPointWidth;
    mSecondaryRectCounts = secondaryStates.length;
    
 
  }

  bool get isLogAxis => axis == AxisType.LOG;

  @override
  void paint(Canvas canvas, Size size) {
  
    if(MainState.FS == mainState) {//add
      mDataLen = size.width - mMarginRight;
      mPointWidth = mDataLen / 241;
    }   

    mDisplayHeight = size.height * 1 - ChartStyle.topPadding- ChartStyle.bottomDateHigh;
    mWidth = size.width;
    initData(size); 
    calculateValue();
    initChartRenderer();

    canvas.save();
    canvas.scale(1, 1);
    drawGrid(canvas);
    
    if (datas != null && datas.isNotEmpty) {
      drawChart(canvas, size);
      drawLeftText(canvas);
      drawBottomText(canvas); //分时 FS 
      drawRightText(canvas); //百分百 FS 
      drawMaxAndMin(canvas);
    }
    canvas.restore();
  }



  void initData(Size size) {
        
    if(isFullScreen == true) mSecondaryRectCounts = 1;    
    if(cyqState == CyqState.NONE) cyqWidth = 0;

    if(mSecondaryRectCounts == 1) mSecondaryRadio = 0.4;
    else if(mSecondaryRectCounts == 2)  mSecondaryRadio = 0.25;
    else if(mSecondaryRectCounts == 3) mSecondaryRadio = 0.2;
    else mSecondaryRadio = 0.15;
  }

  setSelectedRect(){
      double mainWidth = mWidth;
      if(cyqState == CyqState.CYQ) mainWidth = mainWidth - cyqWidth ;

      //限定 x;
      if(selectX < 0) selectX = 0;
      else if(selectX > mainWidth) selectX = mainWidth;

      //限定 y;
      // if(selectY < ChartStyle.topPadding) {
      //   selectY = ChartStyle.topPadding;                
      // }else if(selectY >= mMainRect.bottom){    
      //   selectY =    mMainRect.bottom; 
      // }
  }

  findLocation(double pressDY){
     BaseRect selectBaseRect;
      if(mMainRect.bottom+ ChartStyle.childPadding <= pressDY && pressDY < mDisplayHeight){
        for(int i = 0; i< mSecondaryRects.length; i++){
          if(mSecondaryRects[i].top < pressDY && pressDY <= mSecondaryRects[i].bottom){
            selectBaseRect = mSecondaryRects[i];
            break;
          }
        }
      } else if(ChartStyle.topPadding < pressDY && pressDY <= mMainRect.bottom){
            selectBaseRect = mMainRect;
      }
      else {
        selectBaseRect = null;
      }    
      return selectBaseRect;
  }


  //计算 maxScrollX， mStartIndex， mStopIndex 
  calculateValue() {
    if (datas == null || datas.isEmpty) return;

    double offsetX = getMinTranslateX();
    mTranslateX = scrollX + offsetX;
    maxScrollX = offsetX.abs();
    
    mStartIndex = indexOfTranslateX(xToTranslateX(0));
    mStopIndex = indexOfTranslateX(xToTranslateX(mMainRect.width));
    mMidIndex = indexOfTranslateX(xToTranslateX(mMainRect.width/2));
    showCount = mStopIndex - mStartIndex;

    if (datas == null || datas.isEmpty) return;

    for (int i = mStartIndex; i <= mStopIndex; i++) {
      var item = datas[i];
      mMainRect.calcMaxMinValue(item, i);
      for(int j= 0 ;j< mSecondaryRects.length; j++){
        mSecondaryRects[j].calcMaxMinValue(item, i);
      }
    } 
  }

  int indexOfTranslateX(double translateX) {
    return _indexOfTranslateX(translateX, 0, mItemCount - 1);
  }

  int _indexOfTranslateX(double translateX, int start, int end) {
    if (end == start || end == -1)  return start; 
    if (end - start == 1) {
      double startValue = getX(start);
      double endValue = getX(end);
      return (translateX - startValue).abs() < (translateX - endValue).abs() ? start : end;
    }
    int mid = start + (end - start) ~/ 2;
    double midValue = getX(mid);
    if (translateX < midValue) {
      return _indexOfTranslateX(translateX, start, mid);
    } else if (translateX > midValue) {
      return _indexOfTranslateX(translateX, mid, end);
    } else {
      return mid;
    }
  }

  ///@param position index 值
  double getX(int position) {
    double x = position * mPointWidth + mPointWidth / 2;
    return x;
  }

  Object getItem(int position) {
    if (datas != null) {
      return datas[position];
    } else {
      return null;
    }
  }

  double getMinTranslateX() { 
    var x = -mDataLen + mMainRect.width / scaleX -  mPointWidth / 2;
    x = x >= 0 ? 0.0 : x;
    if (x >= 0) {
      double diff = mMainRect.width/scaleX - getX(datas.length);
      if (diff < mMarginRight) {
        x = x - (mMarginRight - diff);
      } else   mMarginRight = diff;
    } else if (x < 0)  x = x - mMarginRight;
    return x >= 0 ? 0.0 : x;
  }

  int calculateSelectedX(double selectX) {
    int mSelectedIndex = indexOfTranslateX(xToTranslateX(selectX));
    if (mSelectedIndex < mStartIndex) {
      mSelectedIndex = mStartIndex;
    }
    if (mSelectedIndex > mStopIndex) {
      mSelectedIndex = mStopIndex;
    }
    return mSelectedIndex;
  }

  ///translateX转化为view中的x 
  double translateXtoX(double translateX) {
    return (translateX + mTranslateX) * scaleX;
  }

  //偏移
  double xToTranslateX(double x) {
    return -mTranslateX + x / scaleX;
  }

  TextStyle getTextStyle(Color color) {
    return TextStyle(fontSize: ChartStyle.defaultTextSize, color: color);
  }

  String format(double n) {
    return NumberUtil.format(n);
  }

  double getEndX(){
    return -mTranslateX + (mMainRect.width+ChartStyle.pointWidth/2) / scaleX ;
  }

  @override
  bool shouldRepaint(BaseChartPainter oldDelegate) {
    return true;
  }


  String getDate(int date) {
    DateTime first = DateTime(2005, 1, 1);

    DateTime target = first.add(Duration(days: date));
    return dateFormat(target, [yyyy, '/', mm, '/', d]);
  }

  String getTime(int time) {
    DateTime now = DateTime.now();
    DateTime first = DateTime(now.year, now.month, now.day, 9, 30);

    DateTime second = DateTime(now.year, now.month, now.day, 11, 31);
    DateTime t1 = first.add(Duration(minutes: time));
    if (t1.millisecondsSinceEpoch > second.millisecondsSinceEpoch) {
      t1 = t1.add(Duration(minutes: 90));
    }

    return dateFormat(t1, [HH, ':', nn]);
  }
  

  void initChartRenderer();

  //画网格
  void drawGrid(canvas);

  //画图表
  void drawChart(Canvas canvas, Size size);

  //画左边值
  void drawLeftText(canvas);

  //画右边值(百分比)
  void drawRightText(canvas);

  void drawBottomText(canvas);

  //画最大最小值
  void drawMaxAndMin(Canvas canvas);

  //交叉线值
  void drawCrossLineText(Canvas canvas, Size size);
}
