import 'package:flutter/material.dart';

class Settings {
  int minCount;
  int maxCount;
  bool multiDirection;
  double anchor;
  Axis scrollDirection;

  bool get scrollVertical => scrollDirection == Axis.vertical;

  double get contentHeight {
    if (scrollVertical) {
      return 300;
    }

    return double.infinity;
  }

  double get contentWidth {
    if (scrollVertical) {
      return double.infinity;
    }

    return 300;
  }

  EdgeInsets get contentMargin {
    if (scrollVertical) {
      return EdgeInsets.only(
        left: 90,
        bottom: 5,
        top: 5,
        right: 10,
      );
    }

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
    this.multiDirection = true,
    this.anchor = 0,
    this.scrollDirection = Axis.vertical,
  });
}