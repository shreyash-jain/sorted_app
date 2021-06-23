import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

MyGlobals myGlobals = MyGlobals();

enum Gcolors {
  B,
  W,
  B1,
  W1,
  B2,
  W2,
  BLUE,
  GREEN,
}

enum GFontSize { S, M, L, XL, XXL, XS, XXS, XXXS, XXXXS }

enum GFontWeight { B, N, L }

class MyGlobals {
  GlobalKey _scaffoldKey;
  MyGlobals() {
    _scaffoldKey = GlobalKey();
  }
  GlobalKey get scaffoldKey => _scaffoldKey;
}

class Gparam {
  static double height = 100;
  static double width = 100;
  static double ratio = 3.33;
  static double topPadding = 20;
  static double heightPadding = 10;
  static double widthPadding = 20;
  static bool isHeightBig = true;
  static bool isWidthBig = true;
  static double textVeryExtraSmall = 10;
  static double textExtraSmall = 12;
  static double textVerySmall = 14;
  static double textSmaller = 16;
  static double textSmall = 18;
  static double textMedium = 22;
  static double textLarge = 26;
  static double textVeryLarge = 30;
  static double textVeryVeryLarge = 34;
}

class UnsplashApi {
  static const kAccessKey = 'aAkpTxclXeZfAMrDGm10CwAjrJLFjnae1U2nxFMQcoo';
  static const kSecretKey = 't-DKb9YYd9GpJvX-dGgYtSSOv2Is2-KSISxaI4qBz0Y';
}

class Gtheme {
  static BoxDecoration roundedWhite = new BoxDecoration(
    borderRadius: new BorderRadius.all(Radius.circular(30.0)),
    boxShadow: [
      BoxShadow(
          offset: Offset(0, 1),
          color: Colors.black.withAlpha(80),
          blurRadius: 4)
    ],
    gradient: new LinearGradient(
        colors: [
          Colors.white,
          Colors.white.withOpacity(.9),
        ],
        begin: FractionalOffset.topCenter,
        end: FractionalOffset.bottomCenter,
        stops: [1.0, 0.0],
        tileMode: TileMode.clamp),
  );
  static BoxDecoration roundedBlack = new BoxDecoration(
    borderRadius: new BorderRadius.all(Radius.circular(30.0)),
    gradient: new LinearGradient(
        colors: [
          Colors.black26,
          Colors.black45,
        ],
        begin: FractionalOffset.topCenter,
        end: FractionalOffset.bottomCenter,
        stops: [1.0, 0.0],
        tileMode: TileMode.clamp),
  );

  static TextStyle blackShadowBold28 = TextStyle(
      color: Colors.black,
      fontFamily: 'Montserrat',
      fontSize: Gparam.textSmaller,
      shadows: [
        Shadow(
          blurRadius: 60.0,
          color: Colors.white,
          offset: Offset(1.0, 1.0),
        ),
      ],
      fontWeight: FontWeight.bold);
  static TextStyle black20 = TextStyle(
      color: Colors.black54,
      fontFamily: 'Montserrat',
      fontSize: Gparam.textSmaller,
      fontWeight: FontWeight.normal);

  // text bold
  static TextStyle textBold = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.bold,
  );

  // text normal
  static TextStyle textNormal = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w600,
  );

  static double getSizeFromEnum(GFontSize size) {
    switch (size) {
      case GFontSize.L:
        return Gparam.textLarge;
      case GFontSize.S:
        return Gparam.textSmall;
      case GFontSize.M:
        return Gparam.textMedium;
      case GFontSize.XL:
        return Gparam.textVeryLarge;
      case GFontSize.XXL:
        return Gparam.textVeryVeryLarge;
      case GFontSize.XS:
        return Gparam.textSmaller;
      case GFontSize.XXS:
        return Gparam.textVerySmall;
      case GFontSize.XXXS:
        return Gparam.textExtraSmall;
      case GFontSize.XXXXS:
        return Gparam.textVeryExtraSmall;

      default:
    }
  }

  static Color getColorFromEnum(Gcolors color) {
    switch (color) {
      case Gcolors.W:
        return Colors.white;
      case Gcolors.W1:
        return Colors.white70;
      case Gcolors.W2:
        return Colors.white38;
      case Gcolors.B:
        return Colors.black;
      case Gcolors.B1:
        return Colors.black.withOpacity(.8);
      case Gcolors.B2:
        return Colors.black45;
      case Gcolors.BLUE:
        return Color(0xFF307df0);
      case Gcolors.GREEN:
        return Color(0xFF0ec76a);

      default:
    }
  }

  static FontWeight getWeightFromEnum(GFontWeight weight) {
    switch (weight) {
      case GFontWeight.B:
        return FontWeight.w800;

      case GFontWeight.N:
        return FontWeight.w500;
      case GFontWeight.L:
        return FontWeight.w200;
      default:
        return FontWeight.w500;
    }
  }

  static Widget stext(String text,
      {Gcolors color, GFontSize size, GFontWeight weight}) {
    double dsize = getSizeFromEnum(size ?? GFontSize.S);
    Color dcolor = getColorFromEnum(color ?? Gcolors.B);
    FontWeight dweight = getWeightFromEnum(weight ?? GFontWeight.N);
    return Text(
      text,
      style: TextStyle(
        color: dcolor,
        fontSize: dsize,
        fontWeight: dweight,
        fontFamily: 'Montserrat',
      ),
    );
  }
}
