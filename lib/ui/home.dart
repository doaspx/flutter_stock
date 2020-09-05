/*
 * @Author: zhang
 * @Date: 2020-06-20 08:27:29
 * @LastEditTime: 2020-06-25 17:25:01
 * @FilePath: /stock_app/lib/ui/home.dart
 */

import 'package:app_stock/ui/components/200_base.dart';
import 'package:app_stock/ui/widgets/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Backdrop(
        backTitle: const Text('Options'),
        backLayer: TopOneWidget(),
        frontHeading: Container(height: 10.0),
        frontAction: BackButtonIcon(),
        frontTitle: Text('Flutter gallery'),
        frontLayer: TopTwoWidget(),
      );
  }
}

class TopOneWidget extends StatelessWidget {
  const TopOneWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _TopInfo(), //180
      GridViewUsed(),//150
      SizedBox(height: 10),
    ]);
  }
}

class _TopInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 180,
        child: Swiper(
            loop: false,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return Image.asset("assets/images/show${index + 1}.jpg",
                  fit: BoxFit.cover);
            },
            itemCount: 3,
            pagination: new SwiperPagination(),
            autoplay: true,
            viewportFraction: 1 // 两张图片之间的间隔
            ));
  }
}

class GridViewUsed extends StatelessWidget {
  GridViewUsed();

  Widget getGridItem(BuildContext context, int iconInt, String name,
      Color color, double size) {
    return Container(
        alignment: Alignment.bottomCenter,
        margin: EdgeInsets.all(0),
        child: InkWell(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    width: 35,
                    height: 35,
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, color: color),
                    child: Icon(IconData(iconInt, fontFamily: 'stockChartIcon'),
                        size: size, color: Colors.white)),
                SizedBox(
                  height: 5,
                ),
                Text(
                  name.toString(),
                  style: TLFont.black54_12,
                )
              ]),
          onTap: () {},
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 150,
        alignment: Alignment.topCenter,
        color: Theme.of(context).cardColor,
        padding: EdgeInsets.all(0),
        margin: EdgeInsets.all(0),
        child: GridView.count(
            padding: EdgeInsets.only(top: 0, bottom: 10),
            shrinkWrap: true,
            childAspectRatio: 3 / 2,
            crossAxisCount: 4,
            children: [
              getGridItem(context, 0xe629, '研报中心',
                  Color.fromRGBO(253, 115, 119, 1), 15),
              getGridItem(context, 0xe615, '公司公告',
                  Color.fromRGBO(253, 195, 107, 1), 20),
              getGridItem(context, 0xe621, '统计报表',
                  Color.fromRGBO(110, 163, 239, 1), 22),
              getGridItem(context, 0xe75e, '问财选股',
                  Color.fromRGBO(252, 118, 119, 1), 20),
              getGridItem(
                  context, 0xe609, '企业库', Color.fromRGBO(253, 115, 119, 1), 22),
              getGridItem(context, 0xe61d, '财经日历',
                  Color.fromRGBO(110, 163, 239, 1), 20),
              getGridItem(context, 0xe623, '语音同译',
                  Color.fromRGBO(253, 115, 119, 1), 22),
              getGridItem(
                  context, 0xe63b, '更多工具', Color.fromRGBO(253, 180, 70, 1), 22),
            ]));
  }
}

class TopTwoWidget extends StatefulWidget {
  TopTwoWidget({Key key}) : super(key: key);

  @override
  _TopTwoWidgetState createState() => _TopTwoWidgetState();
}

class _TopTwoWidgetState extends State<TopTwoWidget>
    with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    controller = TabController(vsync: this, length: 4);
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          HomeTabBar(controller),
          MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: Expanded(child: HomeTabView(controller)))
        ]));
  }
}

class HomeTabBar extends StatelessWidget {
  final TabController _tabController;
  const HomeTabBar(this._tabController);

  @override
  Widget build(BuildContext context) {
    List<String> tabInfos = ['路演', '要闻', '7X24', '研报'];

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

class HomeTabView extends StatelessWidget {
  final TabController _tabController;
  const HomeTabView(this._tabController);

  Widget createList({context, title, subtitle, total}) {
    return ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(title + index.toString()),
            subtitle: Text(subtitle),
            dense: true,
          );
        },
        itemCount: total);
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          createList(
              context: context, title: '新闻内容', subtitle: '火狐50研习社', total: 100),
          createList(
              context: context, title: '资讯内容', subtitle: '火狐50研习社', total: 100),
          createList(
              context: context, title: '资金信息', subtitle: '火狐50研习社', total: 100),
          createList(
              context: context, title: '公告信息', subtitle: '火狐50研习社', total: 100),
        ]);
  }
}
