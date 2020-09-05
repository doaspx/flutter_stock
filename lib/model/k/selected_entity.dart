/*
 * @Author: zhang
 * @Date: 2020-05-23 00:58:35
 * @LastEditTime: 2020-05-25 21:48:08
 * @FilePath: /app_stock/lib/model/k/selected_entity.dart
 */ 
import 'k_line_entity.dart';

class SelectedKEntity {
  KLineEntity kLineEntity;
  bool isLeft = false; 

  SelectedKEntity(this.kLineEntity,  this.isLeft);
}
