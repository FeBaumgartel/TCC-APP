import 'package:flutter/material.dart';
import 'package:sticky_infinite_list/state.dart';

class Settings {
  int? minCount;
  int? maxCount;
  bool multiDirection;
  HeaderAlignment alignment;
  double anchor;
  Axis scrollDirection;

  bool get scrollVertical => scrollDirection == Axis.vertical;

  double get contentHeight {
    return double.infinity;
  }

  EdgeInsets get contentMargin {
    if ([HeaderAlignment.topRight, HeaderAlignment.topLeft]
        .contains(this.alignment)) {
      return EdgeInsets.only(
        left: 0,
        top: 0,
        bottom: 0,
        right: 0,
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
    this.alignment = HeaderAlignment.topLeft,
    this.multiDirection = false,
    this.anchor = 0,
    this.scrollDirection = Axis.horizontal,
  });
}