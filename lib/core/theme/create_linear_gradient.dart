import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

/// The method that create a LinearGradient object
LinearGradient create(
  double angle,
  List<Color> colors,
  List<double> stops,
  TileMode tileMode,
) =>
    LinearGradient(
      colors: colors,
      stops: stops,
      tileMode: tileMode,
      transform: GradientRotation(radians(angle)),
    );

Color _intToColor(int hexNumber) => Color.fromARGB(
    255,
    (hexNumber >> 16) & 0xFF,
    ((hexNumber >> 8) & 0xFF),
    (hexNumber >> 0) & 0xFF);

/// String To Material color
Color stringToColor(String hex) =>
    _intToColor(int.parse(_textSubString(hex), radix: 16));

//Substring
String _textSubString(String text) {
  if (text == null) return null;

  if (text.length < 6) return null;

  if (text.length == 6) return text;

  return text.substring(1, text.length);
}

class FlutterLinearGradients {
  TileMode tileMode = TileMode.clamp;
  static LinearGradient linear(
    String name,
    double angle,
    List<Color> colors,
    List<double> stops,
    TileMode tileMode,
  ) =>
      create(
        angle,
        colors,
        stops,
        tileMode,
      );

  /// 1. Warm Flame
  static Gradient warmFlame({TileMode tileMode}) => linear(
        "Warm Flame",
        90,
        [
          stringToColor("#ff9a9e"),
          stringToColor("#fad0c4"),
          stringToColor("#fad0c4")
        ],
        [0.0, 0.75, 1.0],
        tileMode,
      );

  /// 2. Night Fade
  static Gradient nightFade({TileMode tileMode}) => linear(
        "Night Fade",
        -90.0,
        [stringToColor("#a18cd1"), stringToColor("#fbc2eb")],
        [0.0, 1.0],
        tileMode,
      );

  static Gradient mindCrawl({TileMode tileMode}) => linear(
        "Mind Crawl",
        -90.0,
        [
          stringToColor("#473B7B"),
          stringToColor("#3584A7"),
          stringToColor("#30D2BE")
        ],
        [0.0, 0.51, 1.0],
        tileMode,
      );
       /// 48. Strong Bliss
  static Gradient strongBliss({TileMode tileMode}) => linear(
        "Strong Bliss",
        0.0,
        [
          stringToColor("#f78ca0"),
          stringToColor("#f9748f"),
          stringToColor("#fd868c"),
          stringToColor("#fe9a8b")
        ],
        [0.0, 0.19, 0.6, 1.0],
        tileMode,
      );
}
