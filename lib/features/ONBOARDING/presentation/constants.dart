import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';

class OnboardStrings {
  static const String imagePath1 = "assets/images/onboarding1.png";
  static const String imagePath2 = "assets/images/onboarding0.png";
  static const String imagePath3 = "assets/images/onboarding2.png";
  static const String onboardDiscription1 =
      "AI generated predictions and past patterns of our activities helps us guide, motivate and if required modify them in future";

  static const String onboardDiscription2 =
      "Organize everything Your Plans, Events, Todos and we will intelligently make your dairy entry for each day";

  static const String onboardDiscription3 =
      "From AI processing to database everything is Offline, so you can share your personal things";

  static const String onboardTitle1 =
      "Track everything that revolves around you";

  static const String onboardTitle2 = "Smart journaling";
  static const String onboardTitle3 = "Highly Secure";
}

class OnboardTextStyle {
  static TextStyle descriptionTS = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: Gparam.textMedium,
      fontWeight: FontWeight.w500,
      color: Colors.black45);

  static TextStyle titleTS = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: Gparam.textSmall,
      fontWeight: FontWeight.w800,
      color: Colors.black87);
}

class OnboardFixtures {
  static const int MAX_PAGES = 3;
}
