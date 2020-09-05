/*
 * @Author: zhanghongtao
 * @Date: 2020-05-28 08:37:54
 * @LastEditTime: 2020-06-16 09:20:08
 * @FilePath: \stock_app\lib\ui\pages\lib\base\base_renderer_factory.dart
 */ 

import '../../../helper/chart_style.dart';
import '../chart_state.dart';
import 'base_painter.dart';
import 'base_rect.dart';
import 'base_renderer.dart';
import 'cyq_render.dart';
import 'main_compare_renderer.dart';
import 'main_renderer.dart';
import 'secondary_renderer.dart';

class RenderFactory{  
    static BaseChartRenderer createMainRender(BaseChartPainter painter, MainRect rect){
        if(painter.compareDatas == null) return MainRenderer(rect,rect.mMainMidValue, ChartStyle.topPadding, painter,); 
        else {
              return  MainCompareRenderer(rect, ChartStyle.topPadding,  painter );
        }
     }

    static BaseChartRenderer createVolRender(BaseChartPainter painter, SecondaryRect rect){
      if(rect.secondaryState != SecondaryState.NONE)  return SecondaryRenderer(
        rect, ChartStyle.childPadding, painter, mVolWidth: ChartStyle.volWidth);
        else return null;
     }


    static BaseChartRenderer createCyqRender(BaseChartPainter painter, CyqRect cyqRect, BaseChartRenderer mMainRenderer){
      if(painter.cyqState == CyqState.CYQ)  return CyqRenderer(
          painter.mCyqRect,
          mMainRenderer,
          painter.mMainRect.mMainMaxValue,
          painter.mMainRect.mMainMinValue,
          ChartStyle.rightPadding,
          painter);
       else return  null;
     }      
}