import 'package:flutter/material.dart';

abstract class AppTheme {

  static const primaryColor = Color(0xfff0fc2e);

  static const backgroundColor = Color(0xfffbfbfb);

  static const colorFontOne = Color(0xff403D3C);

  static const colorFontTwo = Color(0xff676160);

  static const colorFontThree = Color(0xff99938e);

  static const colorFontFour = Color(0xffc6bfba);

  static const colorFontGM = Color(0xff35393D);

  static const colorWhite = Color(0xffffffff);

  static const colorHint = Color(0xffA5AC5D);

  static const colorBtnGradientStart = Color(0xffbefb3c);

  static const colorBtnGradientEnd = Color(0xffeef13a);

  static const colorGreyOne = Color(0xffededed);

  static const colorGreyTwo = Color(0xffd2d2d2);

  static const colorGreyThree = Color(0xfffbfbfb);

  static ThemeData get themeData => ThemeData(
        primaryColor: primaryColor,
        backgroundColor: backgroundColor,
        scaffoldBackgroundColor: backgroundColor,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        cursorColor: colorFontGM,
        hintColor: colorFontGM,
        appBarTheme: const AppBarTheme(
          color: backgroundColor,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.w500,
          ),
          iconTheme: IconThemeData(color: AppTheme.colorFontOne)
        ),
      );
}
