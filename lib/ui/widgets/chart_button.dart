import 'package:app_stock/config/router.dart';
import 'package:app_stock/ui/components/204_providerWidget.dart';
import 'package:app_stock/ui/pages/chart/chart_state.dart';
import 'package:app_stock/view_model/chart_button_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
 

class ChartButtonWidget extends StatelessWidget {
  final MainState mainState; 
  const ChartButtonWidget(this.mainState);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<ChartButtonProvider>(
      builder: (context, model, child) {
        if(mainState == MainState.FS) return SizedBox.shrink();
        return model.isShowBigButton == false
            ? ChartButtonSmallWidget()
            : ChartButtonBigWiget();
      },
      model: ChartButtonProvider(),
    );
  }
}

class ChartButtonSmallWidget extends StatelessWidget {
  const ChartButtonSmallWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChartButtonProvider provider =
        Provider.of<ChartButtonProvider>(context, listen: false);
    return Container(
        color: Colors.transparent,
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
                onTap: () {
                  provider.changeBSState();
                },
                child: ChartButton(0xe61b)),
            InkWell(
                onTap: () {
                  SystemChrome.setEnabledSystemUIOverlays(
                      [SystemUiOverlay.top, SystemUiOverlay.bottom]);
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.portraitDown
                  ]);

                  provider.changeFullState();
                  return Navigator.of(context).pushNamed(RouteName.stock_full_index);
                },
                child: provider.isShowFullButton ? ChartButton(0xe726): ChartButton(0xe725)) 
          ],
        ));
  }
}

class ChartButtonBigWiget extends StatelessWidget {
  const ChartButtonBigWiget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChartButtonProvider provider =
        Provider.of<ChartButtonProvider>(context, listen: false);
    return Container(
        color: Colors.transparent,
        width: 300,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
                onTap: () {
                  provider.changeBSState();
                },
                child: ChartButton(0xe61c)), //缩放
            InkWell(
                onTap: () {
                  // double x = (mScaleX * 2);
                  // mScaleX = x.clamp(0.02, 1.6);
                },
                child: ChartButton(0xe63e) //放大
                ),
            InkWell(
                onTap: () {
                  // double x = (mScaleX / 2);
                  // mScaleX = x.clamp(0.02, 1.6);
                  // notifyChanged();
                },
                child: ChartButton(0xe645) //缩小
                ),
            InkWell(
                onTap: () {
                  //  mScrollX = (20 / mScaleX + mScrollX).clamp(0.0, ChartPainter.maxScrollX);
                  //  notifyChanged();
                },
                child: ChartButton(0xe6cc) //左移
                ),
            InkWell(
                onTap: () {
                  //  mScrollX = (-20 / mScaleX + mScrollX).clamp(0.0, ChartPainter.maxScrollX);
                  //  notifyChanged();
                },
                child: ChartButton(0xe6ce) //右移
                ),
            InkWell(
                onTap: () {
                  SystemChrome.setEnabledSystemUIOverlays([]);
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.landscapeLeft,
                    DeviceOrientation.landscapeRight
                  ]);
                  provider.changeFullState();
                  //  Navigator.of(context).push( CupertinoPageRoute( builder: (context) => FullChartWidget()));
                },
                child: provider.isShowFullButton ? ChartButton(0xe726): ChartButton(0xe725)) //全屏
          ],
        ));
  }
}

class ChartButton extends StatelessWidget {
  final int iconInt;
  const ChartButton(this.iconInt);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 23,
      height: 23,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue[200],
      ),
      child: Icon(
        IconData(
          iconInt,
          fontFamily: 'stockChartIcon',
        ),
        size: 18,
        color: Colors.white,
      ),
    );
  }
}
