/*
 * @Author: zhang
 * @Date: 2020-06-21 19:09:30
 * @LastEditTime: 2020-08-03 12:33:37
 * @FilePath: \stock_app\lib\ui\widgets\backdrop.dart
 */

import 'dart:math' as math;

import 'package:app_stock/ui/components/100_index.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';

const double _kFrontClosedHeight = 340.0; // front layer height when closed
const double _kBackAppBarHeight = 70.0; // back layer (options) appbar height



class _CrossFadeTransition extends AnimatedWidget {
  const _CrossFadeTransition({
    Key key,
    this.alignment = Alignment.center,
    Animation<double> progress,
    this.child0,
    this.child1,
  }) : super(key: key, listenable: progress);

  final AlignmentGeometry alignment;
  final Widget child0;
  final Widget child1;

  @override
  Widget build(BuildContext context) {
    final Animation<double> progress = listenable;

    final double opacity1 = CurvedAnimation(
      parent: ReverseAnimation(progress),
      curve: const Interval(0.0, 1.0),
    ).value;

    final double opacity2 = CurvedAnimation(
      parent: progress,
      curve: const Interval(0.0, 1.0),
    ).value;

    return Stack(
      alignment: alignment,
      children: <Widget>[
        Opacity(opacity: opacity1, child: child1),
        Opacity(opacity: opacity2, child: child0),
      ],
    );
  }
}

class _BackAppBar extends StatelessWidget {
  const _BackAppBar({
    Key key,
    this.controller,
    this.leading = const SizedBox(width: 56.0),
    @required this.title,
    this.trailing,
  })  : assert(leading != null),
        super(key: key);

  final AnimationController controller;
  final Widget leading;
  final Widget title;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    bool isTop = AnimationStatus.completed == controller.status;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10),
          width: 260,
          height: 30,
          child: TextField(
            cursorColor: Colors.grey,
            decoration: InputDecoration(
              prefixIcon: Container(
                  child: Icon(
                Icons.search,
                color: Colors.grey,
                size: 18,
              )),
              contentPadding: EdgeInsets.only(left: 5),
              fillColor: isTop ? Colors.grey[200] : Colors.white,
              filled: true,
              hintText: '证券/路演/咨询/找人/策略',
              hintStyle: TLFont.black54_14,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 1,
                  )),
              enabledBorder: OutlineInputBorder(
                //未选中时候的颜色
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.white,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                //选中时外边框颜色
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        this.trailing
      ],
    );
  }
}

class Backdrop extends StatefulWidget {
  const Backdrop({
    this.frontAction,
    this.frontTitle,
    this.frontHeading,
    this.frontLayer,
    this.backTitle,
    this.backLayer,
  });

  final Widget frontAction;
  final Widget frontTitle;
  final Widget frontLayer;
  final Widget frontHeading;
  final Widget backTitle;
  final Widget backLayer;

  @override
  _BackdropState createState() => _BackdropState();
}

class _BackdropState extends State<Backdrop>
    with SingleTickerProviderStateMixin {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');
  AnimationController _controller;
  //Animation<double> _frontOpacity;

  // static final Animatable<double> _frontOpacityTween =
  //     Tween<double>(begin: 0.2, end: 1.0).chain(
  //         CurveTween(curve: const Interval(0.0, 0.4, curve: Curves.easeInOut)));

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _backdropHeight {
    final RenderBox renderBox = _backdropKey.currentContext.findRenderObject();
    return math.max(0.0, renderBox.size.height - _kBackAppBarHeight - _kFrontClosedHeight);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
     final AnimationStatus status = _controller.status;
     if(status == AnimationStatus.completed) return;
    _controller.value =1 - details.globalPosition.dy / (_backdropHeight ?? details.primaryDelta);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.isAnimating ||  _controller.status == AnimationStatus.completed) return;

    final double flingVelocity =
        details.velocity.pixelsPerSecond.dy / _backdropHeight;
    if (flingVelocity < 0.0)
      _controller.fling(velocity: math.max(2.0, -flingVelocity));
    else if (flingVelocity > 0.0)
      _controller.fling(velocity: math.min(-2.0, -flingVelocity));
    else
      _controller.fling(velocity: _controller.value < 0.5 ? -2.0 : 2.0);
  }

  void _toggleFrontLayer() {
    final AnimationStatus status = _controller.status;
    final bool isOpen = status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
    _controller.fling(velocity: isOpen ? -2.0 : 2.0);
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    final Animation<RelativeRect> frontRelativeRect =
        _controller.drive(RelativeRectTween(
      end: const RelativeRect.fromLTRB(0.0, _kBackAppBarHeight, 0.0, 0.0),
      begin: RelativeRect.fromLTRB(
          0.0, constraints.minHeight + _kFrontClosedHeight, 0.0, 0.0), 
    ));

    print('_controller.value:${_controller.value}, ${_controller.status}');
    return Stack(
      key: _backdropKey,
      children: <Widget>[
        Stack(children: [
                    Opacity(
                        opacity:1 - _controller.value, child: widget.backLayer),
                    Opacity(
                        opacity: _controller.value,
                        child: Container(color: Colors.white))
                  ]),

        Positioned(
          top: 35,
          child: _BackAppBar(
            controller: _controller,
            title: null,
            trailing: _CrossFadeTransition(
              progress: _controller,
              alignment: AlignmentDirectional.centerStart,
              child1: Container(
                  width: constraints.biggest.width - 260,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(Icons.edit, size: 18, color: Colors.white),
                      Icon(Icons.games, size: 18, color: Colors.white),
                      Icon(Icons.message, size: 18, color: Colors.white),
                    ],
                  )),
              child0: Container(
                  padding: EdgeInsets.only(right: 50),
                  width: constraints.biggest.width - 260,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      InkWell(
                        onTap: _toggleFrontLayer,
                        child: Icon(Icons.close, size: 18, color: Colors.grey)
                      ),
                    ],
                  )),
            ),
          ),
        ),
        // Front layer
        PositionedTransition(
          rect: frontRelativeRect,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget child) => child,
            child: widget.frontLayer,
          ),
        ),
        if (widget.frontHeading != null)
          PositionedTransition(
            rect: frontRelativeRect,
            child: ExcludeSemantics(
              child: Container(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _toggleFrontLayer,
                  onVerticalDragUpdate: _handleDragUpdate,
                  onVerticalDragEnd: _handleDragEnd,
                  child: widget.frontHeading,
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: _buildStack);
  }
}
