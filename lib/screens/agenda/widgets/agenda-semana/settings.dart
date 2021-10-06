import 'package:flutter/material.dart';

class Settings {
  int minCount;
  int maxCount;
  bool multiDirection;
  double anchor;
  Axis scrollDirection;

  bool get scrollVertical => scrollDirection == Axis.vertical;

  double get contentHeight {
    return double.infinity;
  }

  EdgeInsets get contentMargin {
    return EdgeInsets.only(
      left: 5,
      bottom: 90,
      top: 10,
      right: 5,
    );
  }

  Settings({
    this.minCount,
    this.maxCount,
    this.multiDirection = false,
    this.anchor = 0,
    this.scrollDirection = Axis.horizontal,
  });
}