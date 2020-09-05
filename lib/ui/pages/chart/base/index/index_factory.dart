/*
 * @Author: zhang
 * @Date: 2020-06-09 22:18:34
 * @LastEditTime: 2020-06-09 22:23:57
 * @FilePath: /stock_app/lib/ui/pages/chart/base/index/index_factory.dart
 */ 
import 'package:app_stock/ui/pages/chart/base/index/kdj.dart';
import 'package:app_stock/ui/pages/chart/base/index/macd.dart';
import 'package:app_stock/ui/pages/chart/base/index/vol.dart';
import 'package:app_stock/ui/pages/chart/chart_state.dart';

import 'base_index.dart';

class SecondIndexFactory{
   static BaseIndex create(SecondaryState state){
      switch (state) {
        case SecondaryState.VOL:
          return VOLIndex();
        case SecondaryState.KDJ:
          return KDJIndex();
        case SecondaryState.MACD:
          return MACDIndex();
        case SecondaryState.NONE:
          return null;
        defult: return null;
      }
   }
}