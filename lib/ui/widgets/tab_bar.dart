/*
 * @Author: zhanghongtao
 * @Date: 2020-05-26 14:48:39
 * @LastEditTime: 2020-06-19 16:49:51
 * @FilePath: \stock_app\lib\ui\widgets\tab_bar.dart
 */

import 'package:app_stock/ui/components/200_base.dart';
import 'package:flutter/material.dart';

class ZxDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  ZxDelegate(this.child);

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      child;

  @override
  double get maxExtent => 45;

  @override
  double get minExtent => 45;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class ZxTabBar extends StatelessWidget {
  final TabController _tabController;
  const ZxTabBar(this._tabController);

  @override
  Widget build(BuildContext context) {
    List<String> tabInfos = ['新闻', '盘口', '资金', '公告', 'F10'];

    return Container(
        color: Colors.white,
        child: TabBar(
            isScrollable: false,
            indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
            controller: _tabController,
            tabs: tabInfos
                .map<Widget>(
                    (str) => Tab(child: Text(str, style: TLFont.black54_10)))
                .toList()));
  }
}

class ZxTabView extends StatelessWidget {
  final TabController _tabController;
  const ZxTabView(this._tabController);

  @override
  Widget build(BuildContext context) {
    Widget createList({title, subtitle, total}) {
      return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => ListTile(
                title: Text(title + index.toString()),
                subtitle: Text(subtitle),
                dense: true,
              ),
          itemCount: total);
    }

    return TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          createList(title: '新闻内容', subtitle: '火狐50研习社', total: 10),
          createList(title: '资讯内容', subtitle: '火狐50研习社', total: 100),
          createList(title: '资金信息', subtitle: '火狐50研习社', total: 100),
          createList(title: '公告信息', subtitle: '火狐50研习社', total: 100),
          createList(title: 'F10信息', subtitle: '火狐50研习社', total: 100)
        ]);
  }
}
