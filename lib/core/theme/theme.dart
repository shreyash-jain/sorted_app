import 'package:flutter/material.dart';

Color primaryColorDarkAndLight = Color.fromARGB(255, 58, 149, 255);
Color secondryColor = Color.fromARGB(255, 113, 142, 221);
Color tertiaryColor = Color.fromARGB(255, 72, 195, 235);
Color quaternaryColor = Color.fromARGB(255, 27, 39, 86);
Color quaternaryColorLighter = Color.fromARGB(255, 17, 59, 100);
Color lightWhiteColor = Color.fromARGB(255, 230, 230, 230);
Color reallyLightGrey = Colors.grey.withAlpha(25);
Color blueMid = Color(0xFF4563DB);

//* white Theme | pref_name = "light"
String lightString = "light";
ThemeData appThemeLight = ThemeData.light().copyWith(
  primaryColor: primaryColorDarkAndLight,
  primaryColorDark: quaternaryColor,
  dialogBackgroundColor: lightWhiteColor,
  scaffoldBackgroundColor: Color.fromARGB(255, 253, 253, 255),
  primaryColorLight: tertiaryColor,
  bottomAppBarColor: Color.fromARGB(255, 200, 200, 200),
  accentColor: secondryColor,
  textSelectionHandleColor: Colors.white,
  backgroundColor: tertiaryColor,
  highlightColor: Colors.black,
  dividerColor: Colors.transparent,
  canvasColor: lightWhiteColor,
  bottomSheetTheme:
      BottomSheetThemeData(backgroundColor: Colors.transparent.withOpacity(0)),
);

//* Black Theme | pref_name = "dark"
String darkString = "dark";
ThemeData appThemeDark = ThemeData.dark().copyWith(
  primaryColor: primaryColorDarkAndLight,
  primaryColorDark: quaternaryColorLighter,
  primaryColorLight: tertiaryColor,
  scaffoldBackgroundColor: Color.fromARGB(255, 0, 5, 5),
  canvasColor: lightWhiteColor,
  backgroundColor: blueMid,
  bottomAppBarColor: Color.fromARGB(255, 70, 70, 70),
  accentColor: secondryColor,
  highlightColor: Colors.white,
  dividerColor: Colors.transparent,
  textSelectionHandleColor: Colors.black,
  toggleableActiveColor: primaryColorDarkAndLight,
  bottomSheetTheme:
      BottomSheetThemeData(backgroundColor: Colors.transparent.withOpacity(0)),
  buttonColor: Colors.black.withOpacity(.3),
  textSelectionColor: primaryColorDarkAndLight,
);

//* Darkblue Theme | pref_name = "dark_blue"
String darkBlueString = "dark_blue";
// Colors for dark blue theme
Color primaryDarkBlue = stringToColor("#30D2BE");
Color accentDrakBlue = stringToColor("#3584A7");
Color backgroundDarkBlue = stringToColor("#473B7B");

ThemeData appThemeDarkBlue = ThemeData.dark().copyWith(
  primaryColor: primaryDarkBlue,
  primaryColorDark: quaternaryColorLighter,
  primaryColorLight: tertiaryColor,
  dialogBackgroundColor: primaryColorDarkAndLight,
  scaffoldBackgroundColor: backgroundDarkBlue,
  canvasColor: lightWhiteColor,
  backgroundColor: accentDrakBlue,
  highlightColor: Colors.white70,
 dividerColor: Colors.transparent,
  textSelectionHandleColor: Colors.black,
  bottomAppBarColor: Color.fromARGB(255, 6, 161, 142),
  accentColor: accentDrakBlue,
  toggleableActiveColor: primaryColorDarkAndLight,
  bottomSheetTheme:
      BottomSheetThemeData(backgroundColor: Colors.transparent.withOpacity(0)),
  buttonColor: Colors.black.withOpacity(.3),
  textSelectionColor: primaryColorDarkAndLight,
);

//* LightPink Theme | pref_name = "light_pink"
String lightPinkString = "light_pink";

// Colors for dark blue theme
Color primaryLightPink = stringToColor("#fd868c");
Color accentLightPink = stringToColor("#fe9a8b");
Color backgroundLightPink = stringToColor("#fad0c4");
Color primaryLightPinkDarker = stringToColor("#f9748f");
Color primaryLightPinkLighter = stringToColor("#f78ca0");

ThemeData appThemeLightPink = ThemeData.light().copyWith(
  primaryColor: primaryLightPink,
  primaryColorDark: primaryLightPinkDarker,
  primaryColorLight: primaryLightPinkLighter,
  dialogBackgroundColor: accentLightPink,
  textSelectionHandleColor: Colors.white,
  scaffoldBackgroundColor: Color.fromARGB(255, 253, 253, 255),
  canvasColor: lightWhiteColor,
  highlightColor: Colors.black,
  dividerColor: Colors.transparent,
  backgroundColor: accentLightPink,
  bottomAppBarColor: Color.fromARGB(255, 255, 222, 225),
  accentColor: primaryLightPinkDarker,
  toggleableActiveColor: primaryColorDarkAndLight,
  bottomSheetTheme:
      BottomSheetThemeData(backgroundColor: Colors.transparent.withOpacity(0)),
  buttonColor: Colors.black.withOpacity(.3),
  textSelectionColor: primaryColorDarkAndLight,
);

Color _intToColor(int hexNumber) => Color.fromARGB(
    255,
    (hexNumber >> 16) & 0xFF,
    ((hexNumber >> 8) & 0xFF),
    (hexNumber >> 0) & 0xFF);

Color stringToColor(String hex) =>
    _intToColor(int.parse(_textSubString(hex), radix: 16));

String _textSubString(String text) {
  if (text == null) return null;

  if (text.length < 6) return null;

  if (text.length == 6) return text;

  return text.substring(1, text.length);
}
