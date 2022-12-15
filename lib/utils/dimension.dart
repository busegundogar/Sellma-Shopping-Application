import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class Dimen {
  static const double sideMargin = 25.0;
  static const double regularMargin = 8.0;
  static const double betweenMargin = 16.0;
  static const double largeMargin = 20.0;
  static const double titleMargin = 75.0;
  static const double borderRadius = 8.0;
  static const double borderRadiusRounded = 20.0;
  static const double textFieldHeight = 32.0;
  static const double veryLargeMargin = 64.0;

  static const double imageContainerHeight = 280.0;
  static const double circleAvatarRadius = 140.0;

  static get regularPadding => EdgeInsets.all(sideMargin);
  static get titlePadding => EdgeInsets.symmetric(vertical: titleMargin, horizontal: sideMargin);
  static get buttonPadding => EdgeInsets.symmetric(vertical: betweenMargin, horizontal: sideMargin);
}
