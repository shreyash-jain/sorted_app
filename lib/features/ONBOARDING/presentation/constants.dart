import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';

class OnboardStrings {
  static const String imagePath1 = "assets/images/onboarding/artboard1.jpg";
  static const String imagePath2 = "assets/images/onboarding/artboard2.jpg";
  static const String imagePath3 = "assets/images/onboarding/artboard3.jpg";

  static const String onboardDiscription1 =
      "Connect to top Trainers and Nutritionists over Video, Voice or Chat anytime";

  static const String onboardDiscription2 =
      "Place where you can discuss health & fitness, learn, get motivated, transform, share health & fitness profile";

  static const String onboardDiscription3 =
      "All in one fitness tracking with more than 50 tracks to analyse progress and achieve your fitness goals";

  static const String onboardTitle1 =
      "Consult Fitness Specialist Anytime, Anywhere";

  static const String onboardTitle2 =
      "Connect to people with common Fitness Goals";
  static const String onboardTitle3 = "Fitness Tracking in a Go";
}

class OnboardTextStyle {
  static TextStyle descriptionTS = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: Gparam.textSmaller,
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
