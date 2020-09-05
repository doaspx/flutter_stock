import 'package:flutter/material.dart';

class ToTopModel with ChangeNotifier {
  ScrollController _scrollController;

  double _height;

  bool _showTopBtn = false;

  ScrollController get scrollController => _scrollController;

  bool get showTopBtn => _showTopBtn;

  ToTopModel(this._scrollController, {double height: 200}) {
    _height = height;
  }

  init() {
    _scrollController.addListener(() {
      if (_scrollController.offset > _height && !_showTopBtn) {
        
        _showTopBtn = true;
        notifyListeners();
      } else if (_scrollController.offset < _height && _showTopBtn) {
        _showTopBtn = false;
        notifyListeners();
      }
    });
  }

  scrollToTop() {
    _scrollController.animateTo(0,
        duration: Duration(milliseconds: 300), curve: Curves.easeOutCubic);
  }
}
