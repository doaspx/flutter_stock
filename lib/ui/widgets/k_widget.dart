/*
 * @Author: zhanghongtao
 * @Date: 2020-05-28 08:25:19
 * @LastEditTime: 2020-06-19 17:21:30
 * @FilePath: \stock_app\lib\ui\widgets\k_widget.dart
 */

import 'dart:async';

import 'package:app_stock/model/k/k_entrust.dart';
import 'package:app_stock/ui/components/200_base.dart';
import 'package:app_stock/ui/helper/chart_style.dart';
import 'package:app_stock/ui/pages/chart/tl_chart.dart';
import 'package:app_stock/ui/widgets/top_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/k_line.dart';
import '../pages/chart/chart_state.dart';

class ContentViewWidget extends StatelessWidget {
  final TabController controller;
  final bool isChangingPage;
  final isFullScreen;
  final Function onDoubleFun;
  final StreamController streamController;
  const ContentViewWidget(
      {this.controller,
      this.isChangingPage,
      this.isFullScreen = false,
      this.onDoubleFun,
      this.streamController});

  List<Widget> createViewList(BuildContext context, KLineProvider provider) {
    List<Widget> result = [];
    for (int i = 0; i < ChartType.index.length; i++) {

      Widget rightWidget = i == 0 ? EntrustWidget() : SizedBox.shrink();
      
      result.add(Container(
          margin: EdgeInsets.only(left: 5, right: 5),
          child: Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                Expanded(
                    child: TLChartWidget(provider.showDatas ?? [],
                        compareDatas: provider.compareKDatas,
                        streamController: streamController,
                        axis: provider.axisType,
                        mainState: i == 0 ? MainState.FS : MainState.K,
                        isFullScreen: isFullScreen,
                        secondaryStates: provider.currSecondItems,
                        onChangeState: (int index, state) =>
                            provider.changeSecondaryState(index, state),
                        onDoubleTap: onDoubleFun,
                        cyqState: (i != 0 && isFullScreen)
                            ? CyqState.CYQ
                            : CyqState.NONE,
                        chartType: i)),
                rightWidget
              ]))));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    print(' ----------------------> ContentViewWidget Created');

    KLineProvider provider = isChangingPage == true 
        ? KLineProvider()
        : Provider.of<KLineProvider>(context, listen: false);

    return TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: createViewList(context, provider));
  }
}

class EntrustWidget extends StatelessWidget {
  const EntrustWidget();

  Widget getItem(EntrustEntity entity) {
    return Expanded(
        child: Row(
      children: <Widget>[
        Text(entity.typeName + (entity.index).toString(),
            style: TLFont.black54_10),
        SizedBox(width: 10),
        Text(NullUtil.toLine(entity.price), style: TLFont.red_10),
        SizedBox(width: 10),
        Expanded(
            child: Container(
                padding: EdgeInsets.only(right: 5),
                child: Text(NullUtil.toLine(entity.amount),
                    textAlign: TextAlign.right, style: TLFont.black54_10)))
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    KLineProvider provider = Provider.of<KLineProvider>(context);
    List<Widget> alls = [];
    alls.add(Container(
        color: Colors.grey[350],
        alignment: Alignment.center,
        width: 120,
        height: 20,
        child: Text(
          '5档委托',
          style: TLFont.black54_10,
        )));

    int saleCount = provider.entrust.entrustBuy.length;

    for (int i = saleCount - 1; i >= 0; i--) {
      alls.add(getItem(provider.entrust.entrustSale[i]));
    }

    alls.add(Divider());

    int buyCount = provider.entrust.entrustBuy.length;

    for (int i = 0; i < buyCount; i++) {
      alls.add(getItem(provider.entrust.entrustBuy[i]));
    }

    return Container(
        width: 120,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: alls));
  }
}
