

import 'package:flutter_screenutil/flutter_screenutil.dart';

class SU {
  SU._();
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

class ImageHelper {
  static String asset(String name) {
    return "assets/images/" + name;
  }
}
