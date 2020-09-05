/*
 * @Author: zhang
 * @Date: 2020-05-23 00:58:35
 * @LastEditTime: 2020-06-12 22:52:19
 * @FilePath: /stock_app/lib/model/k/volume_entity.dart
 */ 
mixin VolumeEntity {

  double open;
  double close;
  double vol;
  double diff;
   get isDown {
    if(diff == null) {
      if(open == null || close == null) return true;
      return close - open  > 0 ?false: true;
    }
    if (diff < 0)
      return true;
    else
      return false;
  }
  double mA5Volume =0;
  double mA10Volume = 0;
}
