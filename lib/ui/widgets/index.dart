import 'dart:async';

import 'package:app_stock/model/k/k_line_entity.dart';
import 'package:app_stock/model/k/selected_entity.dart';
import 'package:app_stock/ui/widgets/full_widget.dart';
import 'package:app_stock/utils/sql_util.dart';
import 'package:app_stock/view_model/k_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../components/100_index.dart';
import '../helper/chart_style.dart';
import '../widgets/k_widget.dart';
import '../widgets/tab_bar.dart';
import '../widgets/top_widget.dart';

class StockIndex extends StatelessWidget {
  const StockIndex({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<KLineProvider>(
        onReady: (model) {
          model.loadDataRoot(isFirst: true);
        },
        builder: (context, model, child) {
          if (!model.isFullScreen)
            return VerticalScreenPage(provider: model);
          else
            return FullScreenPage(provider: model);
        },
        model: KLineProvider());
  }
}

class FullScreenPage extends StatefulWidget {
  final KLineProvider provider;
  FullScreenPage({this.provider});

  @override
  _FullScreenPageState createState() => _FullScreenPageState();
}

class _FullScreenPageState extends State<FullScreenPage>
    with SingleTickerProviderStateMixin {
  StreamController<SelectedKEntity> streamController;
  TabController kController;
  KLineProvider provider;

  @override
  void initState() {
    provider = widget.provider;

    streamController = StreamController();
    kController =
        TabController(vsync: this, length: 6, initialIndex: provider.currPage);
    kController.addListener(() {
      if (kController.indexIsChanging)
        widget.provider.changeCurrPage(kController.index);
    });

    // 这个方法把状态栏和虚拟按键隐藏掉
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
    super.initState();
  }

  @override
  void dispose() {
    kController?.dispose();
    streamController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: <Widget>[
          SafeArea(child: FullScreenPageWidget(streamController, kController)),
          Positioned(
              right: 20,
              top: 10,
              child: InkWell(
                  highlightColor: Colors.transparent,
                  radius: 0.0,
                  onTap: () {
                    provider.changeScreenLayout();
                  },
                  child: Icon(Icons.close, size: 25, color: Colors.black)))
        ]));
  }
}

class FullScreenPageWidget extends StatelessWidget {
  final StreamController streamController;
  final TabController kController;
  FullScreenPageWidget(this.streamController, this.kController);

  @override
  Widget build(BuildContext context) {
    KLineProvider provider = Provider.of<KLineProvider>(context);

    return Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
          StreamBuilder<SelectedKEntity>(
              stream: streamController?.stream,
              builder: (context, snapshot) {
                KLineEntity selectedK;
                if (snapshot.data != null && snapshot.data.kLineEntity != null)
                  selectedK = snapshot.data.kLineEntity;

                if (selectedK == null) selectedK = provider.currKLine;
                return Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Column(children: [
                      TopInfoWidget(selectedK),
                      Container(height: 4, color: Colors.grey[100]),
                      SettingWidget(provider)
                    ]));
              }),
          Expanded(
              child: ContentViewWidget(
                  controller: kController,
                  isFullScreen: true,
                  streamController: streamController,
                  isChangingPage: false)),
          HTabViewControlWidget(kController)
        ]));
  }
}

//垂直窗口
class VerticalScreenPage extends StatefulWidget {
  final KLineProvider provider;
  VerticalScreenPage({this.provider});

  @override
  _VerticalScreenPageState createState() => _VerticalScreenPageState();
}

class _VerticalScreenPageState extends State<VerticalScreenPage>
    with TickerProviderStateMixin {
  PageController pageController;
  int beforeMovePage;
  TabController _zxTabController;
  TabController pageTabControl;
  String showTitle;

  @override
  void initState() {
    _zxTabController = TabController(vsync: this, length: 5);

    pageTabControl = TabController(
        vsync: this, length: 6, initialIndex: widget.provider.currPage);

    pageTabControl.addListener(() {
      if (pageTabControl.indexIsChanging == true) {
        widget.provider.changeCurrPage(pageTabControl.index);
      }
    });

    beforeMovePage = widget.provider.showPageIndex;
    pageController = PageController(
        viewportFraction: 1,
        initialPage: widget.provider.showPageIndex,
        keepPage: false);

    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    showTitle = '${widget.provider.name}(${widget.provider.c})';

    pageController.addListener(() async {
      if (pageController.page == widget.provider.showPageIndex &&
          pageController.page != beforeMovePage) {
        print('onReady:$widget.provider.showPageIndex');
        widget.provider.movingInit();

        SqlUtil sql = SqlUtil.setTable('stock_list');
        List list = [];
        if (beforeMovePage < widget.provider.showPageIndex)
          list = await sql.next(widget.provider.m + widget.provider.c);
        else
          list = await sql.pre(widget.provider.m + widget.provider.c);

        beforeMovePage = widget.provider.showPageIndex;
        list ??= [];

        if (list.length > 0)
          return loadData(widget.provider, list[0]);
        else
          return null;
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _zxTabController.dispose();
    pageTabControl.dispose();
    pageController.dispose();
    super.dispose();
  }

  void loadData(KLineProvider provider, item) async {
    showTitle = '${item['name']}(${item['code'].substring(2)})';
    provider.loadDataRoot(
        market: item['code'].substring(0, 2),
        code: item['code'].substring(2),
        stockName: item['name']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: AppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).accentColor,
              automaticallyImplyLeading: false,
              title: Text(
                showTitle,
                style: TLFont.white_16,
              ),
              centerTitle: true),
        ),
        backgroundColor: Colors.white,
        body: PageView.custom(
          controller: pageController,
          onPageChanged: (int i) {
            widget.provider.showPageIndex = i;
          },
          childrenDelegate: new SliverChildBuilderDelegate(
            (context, index) {
              if (index != widget.provider.showPageIndex)
                return VScreenPageWidget(
                    true, _zxTabController, pageTabControl);
              return VScreenPageWidget(false, _zxTabController, pageTabControl);
            },
          ),
        ));
  }
}

class VScreenPageWidget extends StatelessWidget {
  final TabController _zxTabController;
  final TabController pageController;
  final bool isChangingPage;
  VScreenPageWidget(
      this.isChangingPage, this._zxTabController, this.pageController);

  @override
  Widget build(BuildContext context) {
    KLineProvider provider = Provider.of<KLineProvider>(context);
    return NestedScrollView(
        headerSliverBuilder: (context, bool) {
          return [
            SliverToBoxAdapter(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  TopInfoWidget(isChangingPage == true
                      ? KLineEntity()
                      : provider.currKLine), //68
                  Container(height: 10, color: Colors.grey[100]), //4
                  SettingWidget(provider), //254
                  Container(height: 4, color: Colors.grey[100]), //4
                  VScreenChartWidget(pageController, isChangingPage),
                  Container(height: 5, color: Colors.grey[100]),
                ])),
            SliverPersistentHeader(
              delegate: ZxDelegate(ZxTabBar(_zxTabController)),
              pinned: true,
              floating: true,
            ),
          ];
        },
        body: ZxTabView(_zxTabController));
  }
}

class VScreenChartWidget extends StatelessWidget {
  final TabController pageController;
  final bool isChangingPage;
  VScreenChartWidget(this.pageController, this.isChangingPage);

  @override
  Widget build(BuildContext context) {
    KLineProvider provider = Provider.of<KLineProvider>(context);
    return Container(
        height: 400,
        child: Scaffold(
            appBar: TabBar(
                isScrollable: false,
                controller: pageController,
                labelColor: Colors.red,
                indicatorPadding:
                    EdgeInsets.only(left: 20, right: 20, bottom: 5),
                tabs: ChartType.titles.map((item) {
                  return Tab(
                      child: Container(
                          height: 15,
                          child: Text(
                            item,
                            style: TLFont.black54_11,
                          )));
                }).toList()),
            body: ContentViewWidget(
                controller: pageController,
                onDoubleFun: () {
                  provider.changeScreenLayout();
                },
                isChangingPage: isChangingPage)));
  }
}
