

import 'package:app_stock/ui/index.dart';
import 'package:app_stock/ui/widgets/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteName {
  static const String login = 'login';
  static const String index = 'index';

  static const String stock_index = 'stock_index';

  static const String stock_index_second = 'stock_index_second';
  static const String stock_full_index = 'stock_full_index';
  static const String stock_text = 'stock_text';
}

class Router {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.login:
        return FadeRouteBuilder(StockIndex());      
      case RouteName.index:
        return FadeRouteBuilder(IndexPage());
      case RouteName.stock_index:
        return FadeRouteBuilder(StockIndex());
      //  case RouteName.stock_index_second:
      //    return FadeRouteBuilder(StockIndexSecond());
      //  case RouteName.stock_text:
      //    return FadeRouteBuilder(StockText());

      // case RouteName.stock_full_index:{
        
      //     return CupertinoPageRoute(builder: (context)=>
      //         FullStockPage(settings.arguments));
      // }
      default:
        return TlCupertinoPageRoute(builder: (context)=>
            Scaffold(
                  body: Center(
                    child: Text('没有配置该路由： ${settings.name}'),
                  ),
                ));
    }
  }
}


class NoAnimRouteBuilder extends PageRouteBuilder {
  final Widget page;

  NoAnimRouteBuilder(this.page)
      : super(
            opaque: false,
            pageBuilder: (context, animation1, animation2) => page,
            transitionDuration: Duration(milliseconds: 0),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) => child);
}

class SlideTopRouteBuilder extends PageRouteBuilder {
  final Widget page;

  SlideTopRouteBuilder(this.page)
      : super(
            pageBuilder: (context, animation, secondaryAnimation) => page,
            transitionDuration: Duration(milliseconds: 800),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    SlideTransition(
                      position: Tween<Offset>(
                              begin: Offset(0.0, -1.0), end: Offset(0.0, 0.0))
                          .animate(CurvedAnimation(
                              parent: animation, curve: Curves.fastOutSlowIn)),
                      child: child,
                    ));
}

class TlCupertinoPageRoute<T> extends CupertinoPageRoute<T> {
  TlCupertinoPageRoute({
    @required WidgetBuilder builder,
    String title,
    RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  })  : assert(builder != null),
        assert(maintainState != null),
        assert(fullscreenDialog != null),
        assert(opaque),
        super(
            builder: builder,
            title: title,
            settings: settings,
            maintainState: maintainState,
            fullscreenDialog: fullscreenDialog);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);


}

class FadeRouteBuilder extends PageRouteBuilder {
 
  final Widget widget;
 
  FadeRouteBuilder(this.widget)
  : super(
    transitionDuration: const Duration(milliseconds: 500), //设置动画时长500毫秒
    pageBuilder: (
     context,animation,secondaryAnimation){
      return widget;
    },
    transitionsBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child
    ){
      return FadeTransition(
        opacity: Tween<double>(
          begin: 0,
          end: 1
        )
        .animate(CurvedAnimation(parent: animation, curve: Curves.linear)),
        child: child,
      );
    }
 
  );
 
 
}