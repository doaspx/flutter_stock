import 'package:app_stock/ui/components/200_base.dart';
import 'package:app_stock/ui/pages/chart/chart_state.dart';
import 'package:app_stock/utils/number_util.dart';
import 'package:app_stock/view_model/k_line.dart';
import 'package:ffloat/ffloat.dart';
import 'package:flutter/material.dart';

import '../../model/k/k_line_entity.dart';

class TopInfoWidget extends StatefulWidget {
  final KLineEntity currKLine;
  const TopInfoWidget(this.currKLine);

  @override
  _TopInfoWidgetState createState() => _TopInfoWidgetState();
}

class _TopInfoWidgetState extends State<TopInfoWidget> {
  bool hiddenMoreBlock = true;

  Widget moreInfo(KLineEntity k) {
    return Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(bottom: 5, top: 5),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                      '市盈率 ${NullUtil.isNull(k.vol) ? '--' : NumberUtil.amountFormat(k.vol)}'),
                  Text(
                      '流通值 ${NullUtil.isNull(k.amount) ? '--' : NumberUtil.amountFormat(k.amount)}'),
                  Text(
                      '总股本 ${NullUtil.isNull(k.amount) ? '--' : NumberUtil.amountFormat(k.amount)}')
                ])),
        Container(
            padding: EdgeInsets.only(bottom: 5),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                      '市净率 ${NullUtil.isNull(k.vol) ? '--' : NumberUtil.amountFormat(k.vol)}'),
                  Text(
                      '收  益 ${NullUtil.isNull(k.amount) ? '--' : NumberUtil.amountFormat(k.amount)}'),
                  Text(
                      '市盈率 ${NullUtil.isNull(k.amount) ? '--' : NumberUtil.amountFormat(k.amount)}')
                ])),
        Container(
            padding: EdgeInsets.only(bottom: 5),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                      '今 开 ${NullUtil.isNull(k.vol) ? '--' : NumberUtil.amountFormat(k.vol)}'),
                  Text(
                      '涨 停 ${NullUtil.isNull(k.amount) ? '--' : NumberUtil.amountFormat(k.amount)}'),
                  Text(
                      '振 幅 ${NullUtil.isNull(k.amount) ? '--' : NumberUtil.amountFormat(k.amount)}')
                ])),
        Container(
            padding: EdgeInsets.only(bottom: 5),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                      '昨 收 ${NullUtil.isNull(k.vol) ? '--' : NumberUtil.amountFormat(k.vol)}'),
                  Text(
                      '跌 停 ${NullUtil.isNull(k.amount) ? '--' : NumberUtil.amountFormat(k.amount)}'),
                  Text(
                      '委 比 ${NullUtil.isNull(k.amount) ? '--' : NumberUtil.amountFormat(k.amount)}')
                ])),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    KLineEntity k = widget.currKLine;
    return InkWell(
        onTap: () {
          hiddenMoreBlock = !hiddenMoreBlock;
          setState(() {});
        },
        child: DefaultTextStyle(
          child: Container(
              child: Column(children: [
            Container(
                child: Row(children: <Widget>[
              Container(
                  width: 120,
                  padding: EdgeInsets.only(left: 20),
                  child: Text(NullUtil.toLine(k.close), style: TLFont.red_20)),
              Expanded(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                    Text('高' + NullUtil.toLine(k.high)),
                    SizedBox(width: 30),
                    Text('开' + NullUtil.toLine(k.open)),
                    SizedBox(width: 30),
                    Text('低' + NullUtil.toLine(k.low))
                  ]))
            ])),
            Container(
                child: Row(
              children: <Widget>[
                Container(
                    width: 120,
                    padding: EdgeInsets.only(left: 10),
                    child: Row(children: <Widget>[
                      Text(
                          widget.currKLine.diff == null
                              ? '--'
                              : NumberUtil.format(widget.currKLine.diff),
                          style: TextStyle(
                              color: widget.currKLine.isDown
                                  ? Colors.green
                                  : Colors.red)),
                      SizedBox(width: 10),
                      Text(
                          NullUtil.isNull(k.precent)
                              ? '--'
                              : k.precent.toString() + '%',
                          style: TextStyle(
                              color: widget.currKLine.isDown
                                  ? Colors.green
                                  : Colors.red))
                    ])),
                Expanded(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                      Text(
                          '量 ${NullUtil.isNull(k.vol) ? '--' : NumberUtil.amountFormat(k.vol)}'),
                      Text(
                          '额 ${NullUtil.isNull(k.amount) ? '--' : NumberUtil.amountFormat(k.amount)}')
                    ]))
              ]
            )),
            Offstage(offstage: hiddenMoreBlock, child: moreInfo(k))
          ])),
          style: TLFont.black54_12,
        ));
  }
}

class SettingWidget extends StatefulWidget {
  final KLineProvider provider;
  const SettingWidget(this.provider);

  @override
  _SettingWidgetState createState() => _SettingWidgetState();
}

class _SettingWidgetState extends State<SettingWidget> {
  FFloatController ffloatControler = FFloatController();
  Widget ffloat;

  @override
  void dispose() {
    ffloatControler.dispose();
    super.dispose();
  }

  @override
  void initState() {
    initFfloat();
    super.initState();
  }

  initFfloat() {
    ffloat = FFloat((setter) => createSetting(widget.provider, setter),
        controller: ffloatControler,
        color: Colors.grey[350],
        corner: FFloatCorner.all(5),
        triangleOffset: Offset(-5, 0),
        triangleAlignment: TriangleAlignment.end,
        alignment: FFloatAlignment.bottomRight,
        canTouchOutside: true,
        anchor: InkWell(
            onTap: () {
              if (ffloatControler.isShow == true)
                ffloatControler.dismiss();
              else
                ffloatControler.show();
            },
            child: Icon(Icons.settings, size: 15, color: Colors.grey[400])));
  }

  getTagButtons(provider, setter) {
    List<Widget> widgets = [];
    for (int i = 1; i <= 4; i++) {
      widgets.add(ActionChip(
          backgroundColor: provider.currSecondaryCount == i
              ? Colors.grey
              : Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
          label: Text(i.toString()),
          onPressed: () => setter(() => provider.changeCurrSecondaryItems(i))));
    }
    return widgets;
  }

  getAxisButtons(provider, setter) {
    List<Widget> widgets = [];
    widgets.add(ActionChip(
        backgroundColor: provider.axisType == AxisType.NORMAL
            ? Colors.grey
            : Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
        label: Text('普通坐标'),
        onPressed: () => setter(() => provider.changeAxis(0))));

    widgets.add(ActionChip(
        backgroundColor: provider.axisType == AxisType.LOG
            ? Colors.grey
            : Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
        label: Text('对数坐标'),
        onPressed: () => setter(() => provider.changeAxis(1))));
    return widgets;
  }

  Future redirect() async {
    // var result = await Navigator.of(context).pushReplacement(TlCupertinoPageRoute(builder: (context)=>widget));
    // if (result != null) model.initData();
  }

  Widget createSetting(provider, setter) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      height: 300,
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('副标数量', style: TLFont.black54_10),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: getTagButtons(provider, setter)),
          Text('坐标', style: TLFont.black54_10),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: getAxisButtons(provider, setter)),
          InkWell(
              onTap: () {
                ffloatControler.dismiss();

                List item = [
                  [
                    '上证指数',
                    () async {
                      Navigator.of(context).pop();
                      provider.loadCompareData('sh', '000001');
                    }
                  ],
                  [
                    '深圳成指',
                    () async {
                      Navigator.of(context).pop();
                      provider.loadCompareData('sz', '000001');
                    }
                  ],
                  [
                    '自定义',
                    () async {
                      Navigator.of(context).pop();
                      return await redirect();
                    }
                  ],
                  [
                    '取消叠加',
                    () async {
                      Navigator.of(context).pop();
                      provider.cancelCompareData();
                    }
                  ]
                ];
                TLDialog.showModalMenu(context, item);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('叠加', style: TLFont.black54_10),
                  Icon(Icons.keyboard_arrow_right, size: 24)
                ],
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // KLineProvider provider = Provider.of<KLineProvider>(context, listen: false);

    // KLineEntity kEntity = provider.currKLine;

    return Container(
      height: 25,
      padding: EdgeInsets.only(top: 3, bottom: 3, right: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Container(
                padding: EdgeInsets.only(left: 5),
                child: Row(children: <Widget>[])),
          ),
          Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 10),
              width: 50,
              child: ffloat)
        ],
      ),
    );
  }
}

class NullUtil {
  NullUtil._();
  static String toLine(var info, {isLoading: false}) {
    if (isNull(info) || info == 0 || isLoading) return '--';
    return NumberUtil.getNumByValueDouble(double.parse(info.toString()))
        .toString();
  }

  static bool isNull(var info) {
    if (info == null) return true;
    return false;
  }
}
