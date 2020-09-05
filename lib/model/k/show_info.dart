/*
 * @Author: zhang
 * @Date: 2020-06-04 00:05:34
 * @LastEditTime: 2020-06-04 00:06:10
 * @FilePath: /stock_app/lib/model/k/show_info.dart
 */ 
import 'k_line_entity.dart';

class ShowInfoEntity {
  KLineEntity kLineEntity;
  bool isLeft = false;

  ShowInfoEntity(this.kLineEntity,  this.isLeft);
}
