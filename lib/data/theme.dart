import 'package:flutter/material.dart';

Color primaryColor = Color.fromARGB(255, 58, 149, 255);
Color reallyLightGrey = Colors.grey.withAlpha(25);
ThemeData appThemeLight =
    ThemeData.light().copyWith(primaryColor: primaryColor);
ThemeData appThemeDark = ThemeData.dark().copyWith(
    primaryColor: primaryColor,
    toggleableActiveColor: primaryColor,
    accentColor: primaryColor,
    buttonColor: Colors.black.withOpacity(.3),
    textSelectionColor: primaryColor,
    textSelectionHandleColor: primaryColor);
