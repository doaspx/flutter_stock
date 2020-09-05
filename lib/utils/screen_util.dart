/*
 * @Author: zhang
 * @Date: 2020-05-25 23:38:31
 * @LastEditTime: 2020-05-26 08:50:52
 * @FilePath: \stock_app\lib\utils\screen_util.dart
 */ 
import 'package:flutter_screenutil/flutter_screenutil.dart';

class S {
  S._();
  
  static num height(num n){
    return ScreenUtil().setHeight(n);
  }

  
  static num width(num n){
    return ScreenUtil().setWidth(n);
  }

  
  static num font(num n){
    return ScreenUtil().setSp(n);
  }
}

