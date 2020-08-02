import 'package:flutter/material.dart';

Color primaryColor = Color.fromARGB(255, 58, 149, 255);
Color reallyLightGrey = Colors.grey.withAlpha(25);

ThemeData appThemeLight =
    ThemeData.light().copyWith(primaryColor: primaryColor, bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.transparent.withOpacity(0)),);
ThemeData appThemeDark = ThemeData.dark().copyWith(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.black,
    toggleableActiveColor: primaryColor,
    bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.transparent.withOpacity(0)),
    accentColor: primaryColor,
    buttonColor: Colors.black.withOpacity(.3),
    textSelectionColor: primaryColor,
    textSelectionHandleColor: primaryColor);
