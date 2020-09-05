/*
 * @Author: zhang
 * @Date: 2020-05-23 00:58:35
 * @LastEditTime: 2020-05-26 15:56:04
 * @FilePath: \stock_app\lib\model\k\fs_entity.dart
 */ 

 import '../../utils/number_util.dart';

mixin FsEntity{
  double preDayClose;  //前收盘
  double open;
  double close; 
  double diff;
  get precent{
    if(close == null) return null;
    return NumberUtil.getNumByValueDouble((close / open - 1) * 100);
  } //没有乘100
  get isDown {
    if(diff == null) return true;
    if (diff < 0)
      return true;
    else
      return false;
  }
}  