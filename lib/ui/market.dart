/*
 * @Author: zhang
 * @Date: 2020-06-20 08:28:43
 * @LastEditTime: 2020-06-25 17:46:13
 * @FilePath: /stock_app/lib/ui/market.dart
 */
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';

import 'components/100_index.dart';

class MarketPage extends StatefulWidget {
  MarketPage({Key key}) : super(key: key);

  @override
  _MarketPageState createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {

  ScrollController controller;

  @override
  void initState() {
    controller = ScrollController();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TLAppBar.top(context, '行情中心', leading:false),
        backgroundColor: Color.fromRGBO(238, 238, 238, 1),
        body: MarketListWidget(controller: controller,)
        );
  }
}


class MarketTopWidget extends StatelessWidget {
  const MarketTopWidget({Key key}) : super(key: key);

  Widget createItem({String k, String name, Color color}) {
    return Column(children: [
      Container(
          margin: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(3)),
          child: Text(
            k,
            style: TLFont.white_18.copyWith(letterSpacing: 8),
            overflow: TextOverflow.ellipsis,
          )),
      Container(
          padding: EdgeInsets.only(bottom: 4),
          child: Text(name, style: TLFont.black_12))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        createItem(
            k: '融', name: '融资融券', color: Color.fromRGBO(46, 156, 248, 1)),
        Container(width: 1, height: 50, color: Colors.grey[400]),
        createItem(
            k: '新', name: '新兴概念', color: Color.fromRGBO(240, 211, 42, 1)),
        Container(width: 1, height: 50, color: Colors.grey[400]),
        createItem(k: '榜', name: '龙虎榜', color: Color.fromRGBO(253, 106, 46, 1))
      ]),
    );
  }
}

class MarketListWidget extends StatefulWidget {
  final  ScrollController controller;
  MarketListWidget({Key key, this.controller}) : super(key: key);

  @override
  _MarketListWidgetState createState() => _MarketListWidgetState();
}

class _MarketListWidgetState extends State<MarketListWidget> {
  final List groups = ['top','大盘指数', '热门行业', '热门概念', '涨幅榜', '跌幅榜'];
  final List<Widget> groupWidget =     [  SizedBox.shrink(),   ExpansionCardItemWidget(headerName: '大盘指数', count: 2),
        ExpansionCardItemWidget(headerName: '热门行业', count: 1),
        ExpansionCardItemWidget(headerName: '热门概念', count: 1),
        ExpansionCardItemWidget(headerName: '涨幅榜', count: 10, isList: true),
        ExpansionCardItemWidget(headerName: '跌幅榜', count: 10, isList: true)];
  bool isExpansion = true;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
   //   controller: controller,
      itemCount: groups.length,
      itemBuilder: (BuildContext context, int index) {
        if(index == 0) return MarketTopWidget();
        return CardWidget(headerName: groups[index], widget: groupWidget[index]);
      },
    );
  }
}

class CardWidget extends StatefulWidget {
  final String headerName ;
  final Widget widget;
  CardWidget({Key key, this.headerName, this.widget}) : super(key: key);

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  bool isExpansion = true;

  @override
  Widget build(BuildContext context) {
    return StickyHeader(
          //  controller: controller,
            header: InkWell(
              onTap: (){
                setState(() {
                  isExpansion = !isExpansion;
                });
              },
              child: Container(
                decoration: BoxDecoration(color:Color.fromRGBO(238, 238, 238, 1)),
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 5, top:10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [!isExpansion
                        ? Icon(Icons.keyboard_arrow_right, color: Colors.redAccent)
                        : Icon(Icons.keyboard_arrow_down, color: Colors.redAccent),
                          SizedBox(width: 5,),
                          Text(widget.headerName, style: TLFont.red_12,)
                        ]
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.only(right:10),
                      child: Icon(Icons.more_horiz, color: Colors.redAccent,)
                    ),
                  ]
                ),
              )
            ),
            content: AnimatedSwitcher(duration: Duration(milliseconds: 0), child:isExpansion ? widget.widget : SizedBox.shrink()));
  }
}



class ExpansionCardItemWidget extends StatefulWidget {
  final String headerName;
  final int count;
  final bool isList;
  const ExpansionCardItemWidget(
      {@required this.headerName, @required this.count, this.isList = false});

  @override
  _ExpansionCardItemWidgetState createState() =>
      _ExpansionCardItemWidgetState();
}

class _ExpansionCardItemWidgetState extends State<ExpansionCardItemWidget> {
  bool isExpansion = true;

  Widget cardRowList() {
    List<Widget> cards = [];

    for (int i = 0; i < widget.count; i++) {
      if (i != 0)
        cards.add(Container(
          height: 1,
          color: Colors.grey[400],
          margin: EdgeInsets.symmetric(horizontal: 20),
        ));
      cards.add(ListTile(
        contentPadding: EdgeInsets.only(left: 20, right: 20),
        title: DefaultTextStyle(
            style: TLFont.red_14,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '茂业商业',
                  style: TLFont.black54_16,
                ),
                Text('4.65'),
                Text('+10%')
              ],
            )),
        subtitle: Text('600828.SH'),
        dense: true,
      ));
    }

    return Container(
        color: Colors.white,
        child: Column(
          children: cards,
        ));
  }

  Widget cardGridList() {
    List<Widget> cards = [];

    for (int i = 0; i < widget.count; i++) {
      if (i != 0)
        cards.add(Container(
            height: 1,
            color: Colors.grey[400],
            margin: EdgeInsets.symmetric(horizontal: 20)));
      cards.add(cardGridRow());
    }

    return Container(
        color: Colors.white,
        child: Column(
          children: cards,
        ));
  }

  Widget cardGridRow() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      CardItemWidget(),
      Container(width: 1, height: 50, color: Colors.grey[400]),
      CardItemWidget(),
      Container(width: 1, height: 50, color: Colors.grey[400]),
      CardItemWidget(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return widget.isList == false ? cardGridList() : cardRowList();
  }
}

class CardItemWidget extends StatelessWidget {
  const CardItemWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 13),
        child: Column(children: [
          Text('上证指数'),
          SizedBox(height: 3),
          Text('2967.63', style: TextStyle(fontSize: 15, color: Colors.red)),
          SizedBox(height: 3),
          Text('+ 28.31 +0.96%',
              style: TextStyle(fontSize: 10, color: Colors.red))
        ]));
  }
}
