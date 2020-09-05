/*
 * @Author: zhanghongtao
 * @Date: 2020-05-29 12:10:51
 * @LastEditTime: 2020-05-29 12:12:01
 * @FilePath: \stock_app\lib\model\k\secondary_entity.dart
 */ 
import 'package:app_stock/model/k/volume_entity.dart';

import 'kdj_entity.dart';
import 'macd_entity.dart';

mixin SecondaryEntity on KDJEntity, MACDEntity, VolumeEntity{
  
}
