/*
 * @Author: zhang
 * @Date: 2020-05-23 11:13:52
 * @LastEditTime: 2020-06-27 23:09:21
 * @FilePath: /stock_app/lib/ui/components/206_animated.dart
 */ 
import 'package:flutter/material.dart';

class ScaleAnimatedSwitcher extends StatelessWidget {
  final Widget child;

  ScaleAnimatedSwitcher({this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      transitionBuilder: (child, animation) => ScaleTransition(
        scale: animation,
        child: child,
      ), 
      child: child,
    );
  }
}


class SlideAnimatedSwitcher extends StatelessWidget {
  final Widget child;
  SlideAnimatedSwitcher({this.child});


  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      transitionBuilder: (child, animation) => SlideTransition(
        child: child, position: Tween<Offset>(begin: Offset(0,-1), end: Offset(0, 0)).animate(animation),
      ),
      child: child,
    );
  }
}


class FadeAnimatedSwitcher extends StatelessWidget {
  final Widget child;
  FadeAnimatedSwitcher({this.child});


  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      transitionBuilder: (child, animation) => FadeTransition(
        child: child, 
         opacity: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
      ),
      child: child,
    );
  }
}




class EmptyAnimatedSwitcher extends StatelessWidget {
  final bool display;
  final Widget child;

  EmptyAnimatedSwitcher({this.display: true, this.child});

  @override
  Widget build(BuildContext context) {
    return FadeAnimatedSwitcher(child: display ? child : SizedBox.shrink());
  }
}
