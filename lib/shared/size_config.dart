import 'package:flutter/widgets.dart';

class SizeConfig {
  MediaQueryData _mediaQueryData;
  static double screenWidth = 0;
  static double screenHeight = 0;
  static double blockSizeHorizontal = 0;
  static double blockSizeVertical = 0;

  static double _safeAreaHorizontal = 0;
  static double _safeAreaVertical = 0;
  static double safeBlockHorizontal = 0;
  static double safeBlockVertical = 0;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 415;
    blockSizeVertical = screenHeight / 736;

    _safeAreaHorizontal =
        _mediaQueryData.padding.right + _mediaQueryData.padding.left;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 411;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 793;
  }
}
