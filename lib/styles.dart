import 'package:flutter/material.dart';

class Styles {

  static const _textSizeLarge = 30.0;
  static const _textSizeDefault = 20.0;
  static const _textSizeSmall = 15.0;
  static const Color _textColorDefault = Colors.black;
  static const Color _textColorFaint = Colors.blueGrey;
  static const Color _textColorBright = Colors.white;
  static const String _fontNameDefault = 'Roboto';

  static const navBarTitle = TextStyle(
    fontFamily: _fontNameDefault,
    fontWeight: FontWeight.w400,
    fontSize: _textSizeDefault,
    color: _textColorBright
  );

  static const headerLarge = TextStyle(
    fontFamily: _fontNameDefault,
    fontWeight: FontWeight.w700,
    fontSize: _textSizeLarge,
    color: _textColorFaint,
  );

  static const normalText = TextStyle(
    fontFamily: _fontNameDefault,
    fontWeight: FontWeight.normal,
    fontSize: _textSizeDefault,
  );

  static const clickText = TextStyle(
    fontFamily: _fontNameDefault,
    fontWeight: FontWeight.bold,
    fontSize: _textSizeLarge,
    color: _textColorDefault,
    shadows:[
      Shadow(
        color: Colors.white,
        blurRadius: 3,
        offset: Offset(2.5, 2)
      )
    ]
  );

  static const titleText = TextStyle(
    fontFamily: _fontNameDefault,
    fontWeight: FontWeight.bold,
    fontSize: _textSizeLarge,
  );

  static const subtitleText = TextStyle(
    fontFamily: _fontNameDefault,
    fontWeight: FontWeight.bold,
    fontSize: _textSizeSmall,
    color: _textColorFaint
  );

  static ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(
      primary: Colors.blue,
      background: Colors.green
    ),
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(),
  );

  static const trailingText = TextStyle(
    fontFamily: _fontNameDefault,
    fontWeight: FontWeight.bold,
    fontSize: _textSizeDefault,
    color: _textColorFaint
  );


}