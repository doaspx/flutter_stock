/*
 * @Author: zhanghongtao
 * @Date: 2020-06-19 09:26:57
 * @LastEditors: zhanghongtao
 * @LastEditTime: 2020-06-19 16:43:48
 * @FilePath: \stock_app\lib\ui\widgets\full_widget.dart
 */ 
import 'package:app_stock/ui/components/200_base.dart';
import 'package:app_stock/ui/helper/chart_style.dart';
import 'package:app_stock/utils/sql_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/k_line.dart';

class HTabViewControlWidget extends StatelessWidget {
  final TabController kController;
  HTabViewControlWidget(this.kController);

  void loadData(KLineProvider provider, item) async {
    provider.loadDataRoot(
        market: item['code'].substring(0, 2),
        code: item['code'].substring(2),
        stockName: item['name']);
  }

  @override
  Widget build(BuildContext context) {
    
    KLineProvider provider = Provider.of<KLineProvider>(context);

    return Container(
        padding: EdgeInsets.all(0),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Expanded(
              child: TabBar(
                  isScrollable: false,
                  controller: kController,
                  labelColor: Colors.red,
                  indicatorPadding:
                      EdgeInsets.only(left: 50, right: 50, bottom: 5),
                  tabs: ChartType.titles
                      .map((item) => Tab(
                          child: Container(
                              height: 15,
                              child: Text(item, style: TLFont.black54_11))))
                      .toList())),
          Container(
              width: 400,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    RaisedButton(
                        onPressed: () async {
                          SqlUtil sql = SqlUtil.setTable('stock_list');
                          List list = await sql.pre(provider.m + provider.c);
                          if (list == null)
                            return null;
                          else if (list.length > 0) {
                            provider.showPageIndex = provider.showPageIndex - 1;
                            return loadData(provider, list[0]);
                          } else
                            return null;
                        },
                        child: Text("上一页"),
                        color: Colors.redAccent[100],
                        textColor: Colors.white),
                    SizedBox(width: 10),
                    RaisedButton(
                        onPressed: () async {
                          SqlUtil sql = SqlUtil.setTable('stock_list');
                          List list = await sql.next(provider.m + provider.c);
                          if (list == null)
                            return null;
                          else if (list.length > 0) {
                            provider.showPageIndex = provider.showPageIndex + 1;
                            return loadData(provider, list[0]);
                          } else
                            return null;
                        },
                        child: Text("下一页"),
                        color: Colors.redAccent[100],
                        textColor: Colors.white)
                  ]))
        ]));
  }
}
