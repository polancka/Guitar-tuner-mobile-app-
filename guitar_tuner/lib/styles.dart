import 'package:flutter/material.dart';

//this class provides design parameters, used trough the app.
//This way the color scheme and fonts are all the same and can be easily
//changed in one place.

class Styles {
  static const _textSizeLarge = 25.0;
  static const _textSizeDefault = 16.0;

  static final Color _textColorStrong = Colors.black;
  static final Color _textColorDefault = Colors.grey;

  static const String _fontNameDefault = 'Muli';

  static final navbarTitle = TextStyle(
    fontFamily: _fontNameDefault,
  );

  static final headerLarge = TextStyle(
    fontFamily: _fontNameDefault,
    color: _textColorStrong,
    fontSize: _textSizeLarge,
  );

  static final textDefault = TextStyle(
    fontFamily: _fontNameDefault,
    color: _textColorDefault,
    fontSize: _textSizeDefault,
  );

  static final lightgreen = Color(0xff7FB685);
  static final deepgreen = Color(0xff426A5A);
  static final offwhite = Color(0xffE3DBDB);
}
