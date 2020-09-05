import 'package:auto_route/auto_route_annotations.dart';

import 'package:sorted/features/ONBOARDING/presentation/pages/onboard_page.dart';
import 'package:sorted/features/ONSTART/presentation/pages/start_page.dart';
import 'package:sorted/features/SPLASH/splash.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/pages/userIntroMain.dart';

@MaterialAutoRouter()
class $Router {
  @initial
  SplashPage splashPage;
  MyStartPage startPage;
  OnboardPage onboardPage;
  UserIntroPage userIntroPage;
}
