/*
 * @Author: zhang
 * @Date: 2020-06-01 20:19:44
 * @LastEditTime: 2020-06-08 10:44:19
 * @FilePath: \stock_app\lib\view_model\system\theme.dart
 */ 

import 'package:app_stock/utils/sp_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
 

class ThemeModel extends State<StatefulWidget> with ChangeNotifier,TickerProviderStateMixin {
  
  static const TLThemeUserDarkMode = 'TLThemeUserDarkMode';

  bool userDarkMode;
  
  MaterialColor _themeColor;

  Color filterColor;
  AnimationController animController;
  Animation<Color> animation;  


  ThemeModel() {
    userDarkMode = SpUtil.instance.getBool(TLThemeUserDarkMode) ?? false;
    if(userDarkMode == false) filterColor = Colors.white;
    else filterColor = Colors.grey[600];

    animController = AnimationController(vsync: this, duration:Duration(milliseconds: 1500));
    animation = ColorTween(begin: Colors.white,end: Colors.grey[600]).animate(animController)
    ..addListener((){
      filterColor = animation.value;
      notifyListeners();
    });

   _themeColor = Colors.primaries[15];
  }


  void switchTheme({bool serDarkMode, MaterialColor color}) {
    userDarkMode = !userDarkMode;

    
    if(userDarkMode == false)  animController.forward();
    else animController.reverse();

     SpUtil.instance.putBool(TLThemeUserDarkMode, userDarkMode);
  }
  
  
  themeData({bool platformDarkMode: false}) {
    var isDark = platformDarkMode || userDarkMode;

    var themeColor = _themeColor;
    var accentColor = isDark ? themeColor.withOpacity(1) : _themeColor.withOpacity(1);
    var themeData = ThemeData(
          primarySwatch: themeColor,
          accentColor: accentColor,

      brightness: Brightness.light,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
                      
          fontFamily: 'Montserrat',
        );

     themeData = themeData.copyWith(
       scaffoldBackgroundColor: Color.fromRGBO(255, 255, 255, 1),
     );
    return themeData;
  }



  @override
  Widget build(BuildContext context) {
    return null;
  }
}
