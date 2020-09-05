
import 'package:app_stock/ui/helper/screen_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';  

/// 加载中
class BusyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              child: CupertinoActivityIndicator(),
              height: 50.0,
              width: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}


class LoadingWidget extends StatelessWidget {
  //子布局
  final Widget child;

  //加载中是否显示
  final bool loading;

  //进度提醒内容
  final String msg;

  //加载中动画
  final Widget progress;

  //背景透明度
  final double alpha;

  //字体颜色
  final Color textColor;

  LoadingWidget(
      {Key key,
      @required this.loading,
      this.msg = '加载中... ',
      this.progress = const CircularProgressIndicator(),
      this.alpha = 0.2,
      this.textColor = Colors.white,
      @required this.child})
      : assert(child != null),
        assert(loading != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    widgetList.add(child);
    if (loading) {
      Widget layoutProgress = Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(color: Colors.grey[700], borderRadius: BorderRadius.circular(4.0)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              progress,
              Container(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                child: Text(
                  msg,
                  style: TextStyle(color: textColor, fontSize: 15.0,fontWeight: FontWeight.normal, decoration: TextDecoration.none),
                ),
              )
            ],
          ),
        ),
      );
      widgetList.add(Opacity(
        opacity: alpha,
        child: Container(color: Colors.grey),
      ));
      widgetList.add(layoutProgress);
    }
    return Stack(
      children: widgetList,
    );
  }
}


class LoginWidget extends StatelessWidget {
  final String message;
  final VoidCallback onPressed;

  const LoginWidget({this.message, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      onPressed: this.onPressed,
      image:
          Icon(Icons.sentiment_dissatisfied, size: 60, color: Colors.grey[600]),
      title: '信息提示',
      message: message,
      buttonTextData: '点击登录',
    );
  }
}

/// 页面无数据
class EmptyWidget extends StatelessWidget {
  final String message;
  final Widget buttonText;
  final VoidCallback onPressed;

  const EmptyWidget({this.message, this.buttonText, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      onPressed: this.onPressed,
      image:
          Icon(Icons.sentiment_dissatisfied, size: 60, color: Colors.grey[600]),
      title: '没有数据',
      buttonText: buttonText,
      message: '',
      buttonTextData: '刷新重试',
    );
  }
}

class ErrorWidget extends StatelessWidget {
  final int error;
  final String title;
  final String message;
  final Widget image;
  final Widget buttonText;
  final String buttonTextData;
  final VoidCallback onPressed;

  ErrorWidget({
    Key key,
    @required this.error,
    this.image,
    this.title,
    this.message,
    this.buttonText,
    this.buttonTextData,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var defaultImage;
    var defaultTitle;
    var errorMessage = message;
    String defaultTextData = '重试';
    switch (error) {
      case 1:
        defaultImage = Transform.translate(
          offset: Offset(-50, 0),
          child: const Icon(IconData(0xe678), size: 100, color: Colors.grey),
        );
        defaultTitle = '网络连接异常,请检查网络或稍后重试';
        errorMessage = ''; // 网络异常移除message提示
        break;
      default:
        defaultImage =
            const Icon(IconData(0xe600), size: 100, color: Colors.grey);
        defaultTitle = '加载失败';
        break;
    }

    return BaseWidget(
      onPressed: this.onPressed,
      image: image ?? defaultImage,
      title: title ?? defaultTitle,
      message: message ?? errorMessage,
      buttonTextData: buttonTextData ?? defaultTextData,
      buttonText: buttonText,
    );
  }
}

/// 基础Widget
class BaseWidget extends StatelessWidget {
  final String title;
  final String message;
  final Widget image;
  final Widget buttonText;
  final String buttonTextData;
  final VoidCallback onPressed;

  BaseWidget(
      {Key key,
      this.image,
      this.title,
      this.message,
      this.buttonText,
      @required this.onPressed,
      this.buttonTextData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var titleStyle = Theme.of(context)
        .textTheme
        .subhead
        .copyWith(color: Colors.grey, fontSize: SU.font(60));
    var messageStyle = titleStyle.copyWith(
        color: titleStyle.color.withOpacity(0.7), fontSize: SU.font(40));
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          image ?? Icon(IconData(0xe600), size: 80, color: Colors.grey[500]),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  title ?? '加载失败',
                  style: titleStyle,
                ),
                SizedBox(height: 20),
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 200, minHeight: 150),
                  child: SingleChildScrollView(
                    child: Text(message ?? '', style: messageStyle),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: BaseButton(
              child: buttonText,
              textData: buttonTextData,
              onPressed: onPressed,
            ),
          ),
        ],
      ),
    );
  }
}

/// 公用Button
class BaseButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final String textData;

  const BaseButton({@required this.onPressed, this.child, this.textData})
      : assert(child == null || textData == null);

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      child: child ??
          Text(
            textData ?? '重 试',
            style: TextStyle(fontSize: SU.font(50)),
          ),
      textColor: Colors.grey,
      onPressed: onPressed,
      highlightedBorderColor: Colors.blue,
    );
  }
}
