import 'package:flutter/material.dart';

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
  static const TextStyle descriptionTS = TextStyle(
      fontFamily: 'ZillaSlab',
      fontSize: 24.0,
      fontWeight: FontWeight.w400,
      color: Colors.black45);

  static const TextStyle titleTS = TextStyle(
      fontFamily: 'ZillaSlab',
      fontSize: 24.0,
      fontWeight: FontWeight.w700,
      color: Colors.white54);
}

class OnboardFixtures {
  static const int MAX_PAGES = 3;
}
