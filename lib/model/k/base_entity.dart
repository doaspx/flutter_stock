/*
 * @Author: zhang
 * @Date: 2020-05-23 00:58:35
 * @LastEditTime: 2020-06-03 14:21:03
 * @FilePath: \stock_app\lib\model\k\base_entity.dart
 */ 

import 'package:app_stock/model/k/kdj_entity.dart';
import 'package:app_stock/model/k/macd_entity.dart';
import 'package:app_stock/model/k/secondary_entity.dart';
import 'package:app_stock/model/k/volume_entity.dart';

import 'candle_entity.dart';
import 'cyq_entity.dart';
import 'fs_entity.dart';
import 'k_base_info.dart';

class KBaseEntity  with CandleEntity,FsEntity,CyqEntity,KBaseInfoEntity, KDJEntity, MACDEntity,VolumeEntity, SecondaryEntity{}
 