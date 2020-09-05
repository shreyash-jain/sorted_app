import 'package:flutter/material.dart';

Color primaryColor = Color.fromARGB(255, 58, 149, 255);
Color secondryColor = Color.fromARGB(255, 113, 142, 221);
Color tertiaryColor = Color.fromARGB(255, 72, 195, 235);
Color quaternaryColor = Color.fromARGB(255, 27, 39, 86);
Color reallyLightGrey = Colors.grey.withAlpha(25);
Color blueMid = Color(0xFF4563DB);

ThemeData appThemeLight = ThemeData.light().copyWith(
  primaryColor: primaryColor,
  primaryColorDark: quaternaryColor,
  primaryColorLight: tertiaryColor,
  accentColor: secondryColor,
  backgroundColor: blueMid,
  bottomSheetTheme:
      BottomSheetThemeData(backgroundColor: Colors.transparent.withOpacity(0)),
);
ThemeData appThemeDark = ThemeData.dark().copyWith(
    primaryColor: primaryColor,
    primaryColorDark: quaternaryColor,
    primaryColorLight: tertiaryColor,
    scaffoldBackgroundColor: Colors.black,
    backgroundColor: blueMid,
    accentColor: secondryColor,
    toggleableActiveColor: primaryColor,
    bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.transparent.withOpacity(0)),
    buttonColor: Colors.black.withOpacity(.3),
    textSelectionColor: primaryColor,
    textSelectionHandleColor: primaryColor);
