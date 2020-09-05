import 'package:flutter/material.dart';

class TLCard extends StatelessWidget {
  final Widget cardInfo;
  final Color cardColor;

  TLCard(this.cardInfo, {this.cardColor});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      margin: EdgeInsets.only(left: 10, top: 6, right: 10),
      color: cardColor ?? Theme.of(context).cardColor.withOpacity(0.95),
      child: cardInfo,
    );
  }
}

//每个Card 的分割线部分
class TLCardInfo extends StatelessWidget {
  final List<Widget> listInfo;
  final bool haveHeader;
  final bool isWarp; //是否包一层
  TLCardInfo(this.listInfo, {this.haveHeader = true, this.isWarp = false});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      separatorBuilder: (BuildContext context, int index) {
        if (index == 0)
          return Divider(
            height: 3.0,
            indent: 5,
            endIndent: 5,
            color: Colors.grey.withOpacity(0.7),
          );
        return Divider(
          height: 1.0,
          indent: 15,
          endIndent: 5,
          color: Theme.of(context).dividerColor,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        Widget widget = listInfo[index];

        if (haveHeader && index == 0) {
          if (widget is TLCardInfoHeaderRow) return widget;
          return TLCardInfoHeaderRow(widget);
        }
        if (!isWarp)
          return widget;
        else
          return TLCardInfoTextRow(widget);
      },
      itemCount: listInfo.length,
    );
  }
}

//文本框的样式
class TLCardInfoTextRow extends StatelessWidget {
  final Widget item;
  final Color rowColor;
  TLCardInfoTextRow(this.item, {this.rowColor});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: rowColor,
        padding: EdgeInsets.only(
          left: 15,
          right: 5,
        ),
        child: item);
  }
}

class TLCardInfoRow extends StatelessWidget {
  final List<Widget> list;
  final Color rowColor;
  TLCardInfoRow(this.list, {this.rowColor});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: rowColor,
        padding: EdgeInsets.only(top: 13, left: 15, right: 5, bottom: 13),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: list,
        ));
  }
}

class TLCardInfoMulRow extends StatelessWidget {
  final List<List<Widget>> list;
  final Color rowColor;
  TLCardInfoMulRow(this.list, {this.rowColor});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: rowColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: list.map((items) {
            return TLCardInfoRow(items);
          }).toList(),
        ));
  }
}

class TLCardInfoHeaderRow extends StatelessWidget {
  final Widget item;
  final Color rowColor;
  TLCardInfoHeaderRow(this.item, {this.rowColor});

  @override
  Widget build(BuildContext context) {
    // return  Container(
    //   margin: EdgeInsets.only(top:15, bottom: 15),
    //   color: Theme.of(context).accentColor.withOpacity(0.5),//rowColor==null?Colors.transparent:rowColor,//
    //   child: Container(
    //     color: rowColor==null?Theme.of(context).cardColor.withOpacity(0.95):rowColor,
    //     margin: EdgeInsets.only(left: 3.4, ),
    //     padding: EdgeInsets.only(left:12, right:  5),
    //     child: item
    //   )
    // );
    return Container(
      margin: EdgeInsets.only(top: 15, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
                width: 5,
                height: 20,
              color: Theme.of(context).accentColor.withOpacity(0.5)), //Theme.of(context).accentColor.withOpacity(0.5),
          Expanded(
            child: Container(
                color: Colors.transparent,
                margin: EdgeInsets.only(  left: 3,  ),
                padding: EdgeInsets.only(left: 12, right: 5),
                  child:item)
          )
        ],
      ),
    );
  }
}
