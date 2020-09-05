/*
 * @Author: zhanghongtao
 * @Date: 2020-05-26 08:24:08
 * @LastEditTime: 2020-06-15 20:28:07
 * @FilePath: /stock_app/lib/ui/components/204_ProviderWidget.dart
 */ 
import 'package:app_stock/config/router.dart';
import 'package:app_stock/provider/base_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '203_pageWidget.dart'; 

/// Provider封装类 页面调用此类进行
/// 方便数据初始化
class ProviderWidget<T extends ChangeNotifier> extends StatefulWidget {
  final Widget Function(BuildContext context, T value, Widget child) builder;
  final T model;
  final Widget child;
  final Function(T) onReady;
  final Function(T) autoDispose;
  final bool isSlowDown;

  ProviderWidget(
      {@required this.builder,
      @required this.model,
      this.child,
      this.onReady,
      this.autoDispose,
      this.isSlowDown = true});

  @override
  _ProviderWidgetState<T> createState() => _ProviderWidgetState<T>();
}

class _ProviderWidgetState<T extends ChangeNotifier>
    extends State<ProviderWidget<T>> {
  T model;

  @override
  void initState() {
    if (widget.onReady != null) widget.onReady(widget.model);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (_) => widget.model,
      child: Consumer<T>(
        builder: (context, model, child) {
          if (model is BaseModel) {
            BaseModel b = model;
            if (widget.isSlowDown) {
              if (b.unAuthorized) {
                return LoginWidget(
                    message: b.errorInfo.message,
                    onPressed: () {
                       return Navigator.of(context).pushNamedAndRemoveUntil(RouteName.login, (route) => false);
                    });
              } else if (b.isLoading) {
                return LoadingWidget(
                  loading: true,
                  msg: b.loadingMsg,
                  child: widget.builder(context, model, child),
                );
              } else if (b.isBusy) {
                return BusyWidget();
              } else if (b.isError) {
                print(b.errorInfo.message);
                Fluttertoast.showToast(
                    msg: b.errorInfo.message, gravity: ToastGravity.CENTER);
              }
            }
          }

          return widget.builder(context, model, child);
        },
        child: widget.child,
      ),
    );
  }
}