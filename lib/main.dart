/*
 * @Author: zhanghongtao
 * @Date: 2020-05-26 08:24:10
 * @LastEditTime: 2020-06-20 08:52:32
 * @FilePath: /stock_app/lib/main.dart
 */

import 'dart:io';

import 'package:app_stock/utils/sp_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import 'config/router.dart';
import 'utils/event_bus_util.dart';
import 'utils/sql_util.dart';
import 'view_model/system/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SQLProvider.init(true);
  await SpUtil.init();
  await EventBus.init();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  //SocketIoUtils.getInstance();
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  runApp(AppRoot());
}

class AppRoot extends StatelessWidget {
  const AppRoot({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: ThemeModel())],
      child: AppMain(),
    );
  }
}

class AppMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
      builder: (context, model, child) {
        return ColorFiltered(
          colorFilter: ColorFilter.mode(model.filterColor, BlendMode.modulate),
          child: OKToast(
              backgroundColor: Colors.black54,
              textStyle: TextStyle(fontSize: 16),
              textPadding: EdgeInsets.all(10),
              duration: Duration(seconds: 2),
              child: MaterialApp(
                //checkerboardOffscreenLayers
                debugShowCheckedModeBanner: true,
                onGenerateRoute: Router.generateRoute,
                initialRoute: RouteName.index,
                localizationsDelegates: [
                  //此处
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                theme: model.themeData(),
                supportedLocales: [
                  //此处
                  const Locale('zh', 'CH'),
                  const Locale('en', 'US'),
                ],
              )),
        );
      },
    );
  }
}
