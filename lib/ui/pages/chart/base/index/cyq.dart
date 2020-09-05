/*
 * @Author: zhang
 * @Date: 2020-06-09 23:07:18
 * @LastEditTime: 2020-06-09 23:14:41
 * @FilePath: /stock_app/lib/ui/pages/chart/base/index/cyq.dart
 */ 
// /*
//  * @Author: zhang
//  * @Date: 2020-06-09 23:07:18
//  * @LastEditTime: 2020-06-09 23:07:18
//  * @FilePath: /stock_app/lib/ui/pages/chart/base/index/cyq.dart
//  */ 

// import 'dart:math';
// import 'dart:ui';

// import 'package:app_stock/model/k/candle_entity.dart';
// import 'package:app_stock/model/k/cyq_entity.dart';
// import 'package:app_stock/model/k/k_line_entity.dart';
// import 'package:app_stock/ui/helper/chart_style.dart';
// import 'package:app_stock/ui/pages/chart/base/base_renderer.dart';
// import 'package:app_stock/ui/pages/chart/base/index/base_index.dart';

// class CYQIndex extends BaseIndex<CyqEntity>{

//   @override
//   calcMaxMinValue(KLineEntity item, int i){

//       maxPrice = item.high;
//       minPrice = item.low;

//       if (item.ma5Price != null && item.ma5Price != 0) {
//         maxPrice = max(maxPrice, item.ma5Price ?? 0);
//         minPrice = min(minPrice, item.ma5Price);
//       }
//       if (item.ma10Price != null && item.ma10Price != 0) {
//         maxPrice = max(maxPrice, item.ma10Price);
//         minPrice = min(minPrice, item.ma10Price);
//       }
//       if (item.ma20Price != null && item.ma20Price != 0) {
//         maxPrice = max(maxPrice, item.ma20Price);
//         minPrice = min(minPrice, item.ma20Price);
//       }
//       if (item.ma30Price != null && item.ma30Price != 0) {
//         maxPrice = max(maxPrice, item.ma30Price);
//         minPrice = min(minPrice, item.ma30Price);
//       }
//   }

//   @override
//   void drawChart(CandleEntity lastPoint, CandleEntity curPoint, Canvas canvas, double lastX, double curX) {
//       if(_render == null) return;
//         if (lastPoint.ma5Price != 0 && lastPoint.ma5Price != null) {
//           _render.drawLine(lastPoint.ma5Price, curPoint.ma5Price, canvas, lastX, curX,
//               ChartColors.ma5Color);
//         }
//         if (lastPoint.ma10Price != 0 && lastPoint.ma10Price != null) {
//           _render.drawLine(lastPoint.ma10Price, curPoint.ma10Price, canvas, lastX, curX,
//               ChartColors.ma10Color);
//         }
//         if (lastPoint.ma30Price != 0 && lastPoint.ma30Price != null) {
//           _render.drawLine(lastPoint.ma30Price, curPoint.ma30Price, canvas, lastX, curX,
//               ChartColors.ma30Color);
//         }  
//   }


//   BaseChartRenderer _render;
//   @override
//   void registRender(BaseChartRenderer render) {
//       _render = render;
//   }
// }