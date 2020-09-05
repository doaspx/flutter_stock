/*
 * @Author: zhang
 * @Date: 2020-05-23 11:24:13
 * @LastEditTime: 2020-06-13 11:56:19
 * @FilePath: /stock_app/lib/ui/helper/chart_style.dart
 */ 
import 'package:flutter/material.dart' show Color;

class ChartColors {
  ChartColors._();

  //背景颜色
  static const Color bgColor = Color(0xff0D141E);
  static const Color kLineColor =Color.fromRGBO(171, 171, 255, 1);

  static const Color kCompareLineColor = Color(0xffee3d3d);

  
  static const Color scaleLineColor = Color.fromRGBO(200, 100, 105, 1);

  static const Color gridColor = Color.fromRGBO(220, 220, 220, 1);
  static const Color upColor = Color.fromRGBO(213, 91, 94, 1);
  static const Color dnColor = Color.fromRGBO(10, 103, 12, 1);

  static const Color upCompareColor = Color(0xff7b68ee);
  static const Color dnCompareColor = Color(0xff7b68ee);

  static const Color volColor = Color(0xff4729AE); 
  

  static const Color ma5Color = Color.fromRGBO(135, 135, 135, 1);
  static const Color ma10Color = Color.fromRGBO(235, 187, 85, 1);
  static const Color ma30Color = Color.fromRGBO(48, 49, 138, 1);

  static const Color kColor = Color.fromRGBO(54, 86, 154, 1);
  static const Color dColor = Color.fromRGBO(115, 115, 112, 1);
  static const Color jColor = Color.fromRGBO(160, 60, 66, 1);

  static const Color macdColor = Color(0xff4729AE);
  static const Color difColor = Color.fromRGBO(103, 102, 100, 1);
  static const Color deaColor = Color.fromRGBO(53, 49, 141, 1);

  static const Color yAxisTextColor = Color(0xff60738E); //y轴刻度

  static const Color maxMinTextColor = Color(0xff000000); //最大最小值的颜色


  //选中后显示值背景的填充颜色
  static const Color markerBgColor = Color(0xff616161);

}

class ChartStyle {
  ChartStyle._();

  //点与点的距离
  static const double pointWidth = 6.0;

  //蜡烛宽度
  static const double candleWidth = 4;

  //蜡烛中间线的宽度
  static const double candleLineWidth = 1;

  //vol柱子宽度
  static const double volWidth = 1;

  static const double macdWidth = 3.0;
  
  //vol K 线柱子宽度
  static const double volKWidth = 2;
 


  //水平交叉线宽度
  static const double hvCrossWidth = 1;

  //网格
  static const int gridRows = 4, gridColumns = 4;

  static const double topPadding = 0.0, bottomDateHigh = 10.0, childPadding = 15.0, rightPadding = 10;

  static const double defaultTextSize = 10.0;
}

class ChartType {
  static Map<String , String> Info = {
    'FS': "分时",
    'K': "日K",
    'WK': "周K",
    'MK': "月K",
    'QK': "季K",
    'YK': "年K",
  };
  static List<String> get titles {
    return Info.values.toList();
  }

  static List<String> get index {
    return Info.keys.toList();
  }
  
}