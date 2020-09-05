/*
 * @Author: zhang
 * @Date: 2020-06-13 22:54:24
 * @LastEditTime: 2020-06-13 23:32:09
 * @FilePath: /stock_app/lib/model/k/page.dart
 */ 

import 'package:app_stock/ui/pages/chart/chart_state.dart';

import 'k_line_entity.dart';

class KPage{

  KPage(){
    index = 0;
    requestDatas = [];
    requestCompareDatas =[];
    mainState = MainState.FS;
    axisType = AxisType.NORMAL;
    secondaryStates = [SecondaryState.VOL];
    isFullScreen = false;
  }

  int index;

  KLineEntity currentPoint;
  
  List<KLineEntity> requestDatas;
  List<KLineEntity> requestCompareDatas;
  
  MainState mainState;
  AxisType axisType;

  List<SecondaryState> secondaryStates;
  CyqState cyqState;

  bool isFullScreen;

}