/*
 * @Author: zhang
 * @Date: 2020-06-20 08:33:41
 * @LastEditTime: 2020-06-27 23:46:19
 * @FilePath: /stock_app/lib/ui/my.dart
 */

import 'package:app_stock/ui/components/200_base.dart';
import 'package:flutter/material.dart';

import 'components/100_index.dart';

class MyPage extends StatefulWidget {
  MyPage({Key key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final ScrollController scrollController = ScrollController();

  double _opacity = 0;

  @override
  void initState() {
    scrollController.addListener(() {
      print(scrollController.positions.elementAt(0).pixels);
      double pix = scrollController.positions.elementAt(0).pixels;
      if(pix >= 48) _opacity = 1;
      else if (pix > 0) {
        setState(() {
          _opacity = pix / 48;
        });
      } else {
         _opacity = 0;
      }

      setState(() {
        });
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: Stack(children: [
              TopListWidget(controller: scrollController),
              Opacity(
                opacity: _opacity,
                child: Container(
                  height: 90,
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 45),
                      child: Text("首页", style: TLFont.white_16),
                    ),
                  ),
                ),
              )
            ])));
  }
}

class TopOneWidget extends StatelessWidget {
  const TopOneWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
          height: 250,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Color.fromRGBO(238, 128, 82, 1),
                Color.fromRGBO(252, 88, 48, 1)
              ]))),
      Positioned(
        top: 100,
        left: 20,
        child: Row(children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                border: Border.fromBorderSide(
                    BorderSide(color: Colors.white, width: 1)),
                color: Color.fromRGBO(85, 96, 127, 1),
                shape: BoxShape.circle),
            child: Icon(IconData(0xe6da, fontFamily: 'stockChartIcon'),
                size: 35, color: Colors.white),
          ),
          SizedBox(width: 10),
          Text('风流倜傥的老猫025', style: TLFont.white_18)
        ]),
      ),
      Positioned(
        bottom: 1,
        left: 0,
        child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: Row(children: [
              Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Text(
                      '0',
                      style: TLFont.white_13,
                    ),
                    Text(
                      '关注',
                      style: TLFont.white_13,
                    )
                  ])),
              Container(
                width: 1,
                margin: EdgeInsets.symmetric(vertical: 15),
                color: Colors.white,
              ),
              Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Text(
                      '0',
                      style: TLFont.white_13,
                    ),
                    Text(
                      '新消息',
                      style: TLFont.white_13,
                    )
                  ])),
            ])),
      )
    ]);
  }
}

class TopListWidget extends StatelessWidget {
  final ScrollController controller;
  const TopListWidget({Key key, this.controller}) : super(key: key);

  Widget picWidget({int iconInt, double size = 18, Color color}) {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(
        IconData(iconInt, fontFamily: 'stockChartIcon'),
        size: size,
        color: Colors.white,
      ),
    );
  }

  Widget createItem({iconInt, color, double size, title, subTitle}) {
    return Column(children: [
      ListTile(
        dense: true,
        leading: picWidget(iconInt: iconInt, color: color, size: size),
        title: Text(
          title,
          style: TLFont.black54_16,
        ),
        subtitle: Text(subTitle),
        trailing: Icon(
          Icons.keyboard_arrow_right,
          color: Colors.grey[500],
        ),
      ),
      Container(
        height: 1,
        margin: EdgeInsets.symmetric(horizontal: 20),
        color: Colors.grey[300],
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      shrinkWrap: true,
      children: <Widget>[
        TopOneWidget(),
        createItem(
            iconInt: 0xe622,
            color: Color.fromRGBO(33, 143, 231, 1),
            size: 19,
            title: 'Supercall',
            subTitle: '在线路演交流，支持阅读后即焚'),
        createItem(
            iconInt: 0xe64a,
            color: Color.fromRGBO(238, 89, 71, 1),
            size: 17,
            title: '交易',
            subTitle: 'A股交易，多家券商'),
        createItem(
            iconInt: 0xe600,
            color: Color.fromRGBO(247, 150, 72, 1),
            size: 19,
            title: '手工记账',
            subTitle: '交易流水更加清晰'),
        createItem(
            iconInt: 0xe713,
            color: Color.fromRGBO(55, 154, 248, 1),
            size: 15,
            title: '策略组合',
            subTitle: '研究成果组合跟踪'),
        createItem(
            iconInt: 0xe60f,
            color: Color.fromRGBO(29, 189, 138, 1),
            size: 18,
            title: '观点发布',
            subTitle: '投资观点以文字方式发布'),
        createItem(
            iconInt: 0xe656,
            color: Color.fromRGBO(82, 108, 153, 1),
            size: 24,
            title: '舆情监控',
            subTitle: '全网抓取舆情信息'),
        createItem(
            iconInt: 0xe620,
            color: Color.fromRGBO(29, 191, 138, 1),
            size: 22,
            title: '微信助手',
            subTitle: '将若干微信群信息去重、分类管理'),
        createItem(
            iconInt: 0xe62d,
            color: Color.fromRGBO(237, 89, 75, 1),
            size: 22,
            title: 'AI语音同译',
            subTitle: '语音录制+同步转换文字，支持在线编辑'),
        createItem(
            iconInt: 0xe613,
            color: Color.fromRGBO(245, 152, 72, 1),
            size: 22,
            title: 'K线训练营',
            subTitle: '交易员盘感训练必备'),
        createItem(
            iconInt: 0xe64b,
            color: Color.fromRGBO(241, 87, 72, 1),
            size: 22,
            title: '收藏',
            subTitle: '全局感兴趣信息收藏'),
        createItem(
            iconInt: 0xe771,
            color: Color.fromRGBO(81, 109, 152, 1),
            size: 22,
            title: '设置',
            subTitle: '通用设置&账号安全'),
      ],
    );
  }
}
