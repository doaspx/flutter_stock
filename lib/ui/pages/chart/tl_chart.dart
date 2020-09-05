import 'dart:async';

import 'package:app_stock/model/k/k_line_entity.dart';
import 'package:app_stock/model/k/selected_entity.dart';
import 'package:app_stock/ui/helper/chart_style.dart';
import 'package:app_stock/ui/pages/chart/base/base_rect.dart';
import 'package:app_stock/utils/date_util.dart';
import 'package:app_stock/utils/number_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'chart_state.dart';
import 'base/chart_painter.dart'; 

class TLChartWidget extends StatefulWidget {
  final List<KLineEntity> datas;
  final List<KLineEntity> compareDatas;
  final MainState mainState;
  final List<SecondaryState> secondaryStates ;
  final CyqState cyqState;
  final Function callBack;
  final Function onTouch;
  final Function onUp;
  final Function onDoubleTap;
  final Function onChangeState;
  final isFullScreen;
  final AxisType axis;
  final int chartType;
  StreamController<SelectedKEntity> streamController;

  TLChartWidget(this.datas,
      {this.mainState = MainState.FS,
      this.secondaryStates ,
      this.cyqState = CyqState.CYQ,
      this.callBack,
      this.onTouch,
      this.onUp,
      this.onDoubleTap,
      this.onChangeState,
      this.streamController,
      this.compareDatas,
      this.chartType,
      @required this.axis,
      @required this.isFullScreen
      }) {
  }

  @override
  _TLChartWidgetState createState() => _TLChartWidgetState();
}

class _TLChartWidgetState extends State<TLChartWidget>
    with SingleTickerProviderStateMixin {
  double mScaleX = 1.0, mScrollX = 0.0, mSelectX = 0.0, mSelectY = 0.0;  

  StreamController<SelectedKEntity> tipInfo;
  double getMinScrollX() {
    return mScaleX;
  }

  double _lastScale = 1.0;
  bool isScale = false, isDrag = false, isLongPress = false;

  @override
  void initState() {    
    tipInfo = StreamController<SelectedKEntity>();
    super.initState();
  }

  @override
  void dispose() {
    tipInfo?.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(TLChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.datas != widget.datas) mScrollX = mSelectX = 0.0;
  }


  double dx = 0;

  double scaleStartX = 0;
  double scaleUpdateX = 0;
  double lastScale = 0;
  DateTime scaleStartTime;
  DateTime scaleEndTime;
  double lastRo = 0.0;

  ChartPainter painter;
  @override
  Widget build(BuildContext context) {
    if (widget.datas == null || widget.datas.isEmpty) {
      mScrollX = mSelectX = 0.0;
      mScaleX = 1.0;
    }

    TapUpDetails lastPoint;
    DateTime lastTime;
    painter = createPainter();
    return  GestureDetector(
        behavior: HitTestBehavior.opaque, 
        onTapUp: (details){

          BaseRect rect = painter.findLocation(details.localPosition.dy);
          if(rect == null){
              return false;
          }else if(rect is MainRect){
            lastPoint = details;
            if(lastTime !=null 
            && DateTime.now().difference(lastTime) < Duration(milliseconds: 300)
            && widget.onDoubleTap != null && rect is MainRect) {
              widget.onDoubleTap();
              return false;
            }
            
            lastTime = DateTime.now();
            return false;
          }else if(rect is SecondaryRect){
            lastPoint = null;
            var state = rect.getState();
            
            SecondaryState changedState = StateManager.changeSecondaryState(state);
            widget.secondaryStates[rect.index] = changedState;

            if(widget.onChangeState != null) {
              widget.onChangeState(rect.index, changedState);
            }

            return false;
          }else{
            return false;
          }
        },
    
        onHorizontalDragDown: !widget.isFullScreen ? null :(details) {
          isDrag = true;
        },        
        onHorizontalDragUpdate: !widget.isFullScreen ? null : (details) {
          if (isScale || isLongPress) return;
          mScrollX = (details.primaryDelta / mScaleX + mScrollX).clamp(0.0, ChartPainter.maxScrollX);
          refreshPage();
        },
        onHorizontalDragEnd: !widget.isFullScreen ? null :(DragEndDetails details) {
          isDrag = false;
        },
        onHorizontalDragCancel: !widget.isFullScreen ? null : () => isDrag = false,
        
        onScaleStart: (_) {
          scaleStartX = _.focalPoint.dx;
          scaleStartTime = DateTime.now();
          if(widget.onTouch != null) widget.onTouch();
          if (MainState.FS == widget.mainState || (isDrag || isLongPress)) {
            return;
          } else isScale = true;
        },
        onScaleUpdate: (details) {
          // if(!widget.isFullScreen && ChartPainter.showCount > 245)return;
          // if(widget.isFullScreen && ChartPainter.showCount > 400)return;
          
          scaleUpdateX = details.focalPoint.dx;
          lastScale = details.scale;
          lastRo = details.rotation;
          if (MainState.FS == widget.mainState || (isDrag || isLongPress))  return;
          double x = (_lastScale * details.scale);
          mScaleX = x.clamp(0.4, 1.0);

          refreshPage();
        },
        onScaleEnd: (_) {
          if(widget.onUp != null) widget.onUp();

          double diffX = scaleUpdateX - scaleStartX;
          scaleEndTime = DateTime.now();
          if (MainState.FS == widget.mainState) {
            if (lastScale == 1 &&
                diffX < -50 &&
                lastRo == 0.0 &&
                widget.callBack != null) {
              widget.callBack();
              return;
            }
          } else {
            if (lastScale == 1 &&
                diffX > 50 &&
                lastRo == 0.0 &&
                widget.callBack != null) {
              widget.callBack();
              return;
            }
          }
          isScale = false;
          _lastScale = mScaleX;
        },
        onLongPressStart: (details) {
          isLongPress = true;
          
          if(widget.onTouch != null) widget.onTouch();
          print('8  onLongPressStart');
          if (mSelectX != details.globalPosition.dx) {
            mSelectX = details.localPosition.dx;
            mSelectY = details.localPosition.dy;
            refreshPage();
          }
        },
        onLongPressMoveUpdate: (LongPressMoveUpdateDetails details) {
            // print('9  onLongPressMoveUpdate');
          if (mSelectX != details.globalPosition.dx) {
            mSelectX = details.globalPosition.dx;
            mSelectX = details.localPosition.dx;
            mSelectY = details.localPosition.dy;
            refreshPage();
          }
        },
        onLongPressEnd: (details) {          
          if(widget.onUp != null )widget.onUp();
          isLongPress = false;          
          tipInfo?.sink?.add(null);
          refreshPage();
        },
        child: Stack(
          children: [
            CustomPaint(
                  size: MediaQuery.of(context).size,//widget.size ?? Size(double.infinity, double.infinity),
                  painter:  painter
                ),

              showInfoContainer()      
          ]
        ),
      );
  }

  ChartPainter createPainter(){
    print('======>widget.datas:${widget.datas.length}, chartType: ${widget.chartType}，widget.mainState:${widget.mainState}');
    return ChartPainter(
                datas: widget.datas,
                compareDatas: widget.compareDatas,
                scaleX: mScaleX,
                scrollX: mScrollX, 
                selectX: mSelectX,
                selectY: mSelectY,
                isLongPress: isLongPress,
                mainState: widget.mainState,
                secondaryStates: widget.secondaryStates,
                cyqState: widget.cyqState,
                sink: !widget.isFullScreen? tipInfo.sink: widget.streamController?.sink,
                isFullScreen: widget.isFullScreen ,
                axis: widget.axis
              );
  }

  void refreshPage() => setState(() {});


  List infos;

  Widget showInfoContainer() {
    List<String> tags = ["时间", "价","额",  "量"];
    return StreamBuilder<SelectedKEntity>(
        stream: tipInfo?.stream,
        builder: (context, snapshot) {
          if (!isLongPress || !snapshot.hasData || snapshot.data.kLineEntity == null) return SizedBox.shrink();
          KLineEntity entity = snapshot.data.kLineEntity;

        List tagResutls = [
            MainState.FS == widget.mainState ? DateUtil.getDateByIndex(entity.id): DateUtil.getDateByIndex(entity.id),
            NumberUtil.format(entity.close),            
            NumberUtil.amountFormat(entity.amount),
            NumberUtil.volFormat(entity.vol)
          ];
          return Positioned(
            top: 0,
            left: snapshot.data.isLeft? 0: null,
            right: snapshot.data.isLeft? null: 0,
            child: Container(
                margin: EdgeInsets.only(left: 5, right: 5, top: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration( color: ChartColors.markerBgColor, borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(tags.length, (i){
                      return Container(  
                            width: 100,                      
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 27,
                                  child: Text("${tags[i]}", style: TextStyle(color: Colors.white, fontSize: 12 ))
                                ),
                                 Text(tagResutls[i], style: TextStyle(color:  Colors.white, fontSize: 12)),
                              ],
                            ),
                          );                    
                  }),
                ),
              ),
          );
        });
  }
}
