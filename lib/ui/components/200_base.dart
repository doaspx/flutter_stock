/*
 * @Author: zhanghongtao
 * @Date: 2020-05-26 08:24:08
 * @LastEditTime: 2020-06-27 14:28:55
 * @FilePath: /stock_app/lib/ui/components/200_base.dart
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TLFont {


  static const TextStyle white_12 =
      TextStyle(fontSize: 12, color: Colors.white, letterSpacing: 1); 
  static const TextStyle white_13 =
      TextStyle(fontSize: 13, color: Colors.white, letterSpacing: 1); 
  static const TextStyle white_14 =
      TextStyle(fontSize: 14, color: Colors.white, letterSpacing: 1); 
  static const TextStyle white_16 =
      TextStyle(fontSize: 16, color: Colors.white, letterSpacing: 1); //股票头字体

  static const TextStyle white_18 =
      TextStyle(fontSize: 18, color: Colors.white, letterSpacing: 1); 

  static const TextStyle black54_10 =
      TextStyle(fontSize: 10, color: Colors.black54, letterSpacing: 1);
  static const TextStyle black54_11 =
      TextStyle(fontSize: 11, color: Colors.black54, letterSpacing: 1);
  static const TextStyle black54_12 =
      TextStyle(fontSize: 12, color: Colors.black54, letterSpacing: 1);
  static const TextStyle black54_13 =
      TextStyle(fontSize: 13, color: Colors.black54, letterSpacing: 1);
  static const TextStyle black54_14 =
      TextStyle(fontSize: 14, color: Colors.black54, letterSpacing: 1);
  static const TextStyle black54_16 =
      TextStyle(fontSize: 14, color: Colors.black54, letterSpacing: 1);


  static const TextStyle black_12 =
      TextStyle(fontSize: 12, color: Colors.black, letterSpacing: 1);

  static const TextStyle red_20 =
      TextStyle(fontSize: 20, color: Colors.red, letterSpacing: 1);
  static const TextStyle red_16 =
      TextStyle(fontSize: 16, color: Colors.red, letterSpacing: 1);
  static const TextStyle red_14 =
      TextStyle(fontSize: 14, color: Colors.red, letterSpacing: 1);
  static const TextStyle red_12 =
      TextStyle(fontSize: 12, color: Colors.red, letterSpacing: 1);
  static const TextStyle red_10 =
      TextStyle(fontSize: 10, color: Colors.red, letterSpacing: 1);
}

class TLDialog {
  static Future confirm(context, content, {title: '温馨提示'}) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: content == null
                ? null
                : Padding(
                    padding: EdgeInsets.only(top: 5), child: Text(content)),
            actions: <Widget>[
              FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: new Text(
                  '取 消',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              FlatButton(
                onPressed: () async {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  '确 定',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          );
        });
  }

  static Future showModalMenu(context, List arr) {
    List<Widget> list = List<Widget>();
    for (int i = arr.length - 1; i >= 0; i--) {
      List item = arr[i];
      Widget widget;
      if (item[0] is String)
        widget = Text(
          item[0],
          style: TLFont.black54_10.copyWith(color: Colors.grey),
        );
      else
        widget = item[0];
      list.insert(
          0,
          CupertinoActionSheetAction(
            onPressed: () {
              return item[1]();
            },
            child: widget,
          ));
    }
    return showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            actions: list,
            cancelButton: CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "关 闭",
                  style: TLFont.black54_10.copyWith(color: Colors.grey),
                )),
          );
        });
  }
}

class TLAppBar {
  static Widget top(context, title,
      {List<Widget> actions, bottom, bool leading = true}) {
    return PreferredSize(
      preferredSize: Size.fromHeight(48),
      child: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).accentColor,
        automaticallyImplyLeading: false,
        leading: leading == false
            ? null
            : InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.keyboard_arrow_left,
                    size: 28, color: Colors.white)), //#Color
        title: Text(title, style: TLFont.white_16),
        centerTitle: true,
        actions: actions,
        bottom: bottom,
      ),
    );
  }
}
