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
      if ([HeaderAlignment.topRight, HeaderAlignment.bottomRight]
          .contains(this.alignment)) {
        return EdgeInsets.only(
          left: 10,
          top: 5,
          bottom: 5,
          right: 90,
        );
      }

      return EdgeInsets.only(
        left: 90,
        bottom: 5,
        top: 5,
        right: 10,
      );
    }

    if ([HeaderAlignment.topRight, HeaderAlignment.topLeft]
        .contains(this.alignment)) {
      return EdgeInsets.only(
        left: 5,
        top: 90,
        bottom: 10,
        right: 5,
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
    this.multiDirection = true,
    this.anchor = 0,
    this.scrollDirection = Axis.vertical,
  });
}