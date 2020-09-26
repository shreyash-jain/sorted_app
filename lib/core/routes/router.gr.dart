// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sorted/features/SPLASH/splash.dart';
import 'package:sorted/features/ONSTART/presentation/pages/start_page.dart';
import 'package:sorted/features/ONBOARDING/presentation/pages/onboard_page.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/pages/userIntroMain.dart';
import 'package:sorted/features/HOME/presentation/pages/homePage.dart';
import 'package:sorted/features/HOME/presentation/pages/affirmation_pv.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:sorted/features/HOME/presentation/bloc_affirmation/affirmation_bloc.dart';
import 'package:sorted/features/SETTINGS/presentation/pages/settings_page.dart';

class Router {
  static const splashPage = '/';
  static const startPage = '/start-page';
  static const onboardPage = '/onboard-page';
  static const userIntroPage = '/user-intro-page';
  static const homePage = '/home-page';
  static const affirmationPageview = '/affirmation-pageview';
  static const settingsPage = '/settings-page';
  static final navigator = ExtendedNavigator();
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Router.splashPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => SplashPage(),
          settings: settings,
        );
      case Router.startPage:
        if (hasInvalidArgs<MyStartPageArguments>(args)) {
          return misTypedArgsRoute<MyStartPageArguments>(args);
        }
        final typedArgs =
            args as MyStartPageArguments ?? MyStartPageArguments();
        return MaterialPageRoute<dynamic>(
          builder: (_) =>
              MyStartPage(key: typedArgs.key, title: typedArgs.title),
          settings: settings,
        );
      case Router.onboardPage:
        if (hasInvalidArgs<OnboardPageArguments>(args)) {
          return misTypedArgsRoute<OnboardPageArguments>(args);
        }
        final typedArgs =
            args as OnboardPageArguments ?? OnboardPageArguments();
        return MaterialPageRoute<dynamic>(
          builder: (_) =>
              OnboardPage(key: typedArgs.key, title: typedArgs.title),
          settings: settings,
        );
      case Router.userIntroPage:
        if (hasInvalidArgs<UserIntroPageArguments>(args)) {
          return misTypedArgsRoute<UserIntroPageArguments>(args);
        }
        final typedArgs =
            args as UserIntroPageArguments ?? UserIntroPageArguments();
        return MaterialPageRoute<dynamic>(
          builder: (_) =>
              UserIntroPage(key: typedArgs.key, title: typedArgs.title),
          settings: settings,
        );
      case Router.homePage:
        if (hasInvalidArgs<SortedHomeArguments>(args)) {
          return misTypedArgsRoute<SortedHomeArguments>(args);
        }
        final typedArgs = args as SortedHomeArguments ?? SortedHomeArguments();
        return MaterialPageRoute<dynamic>(
          builder: (_) =>
              SortedHome(key: typedArgs.key, title: typedArgs.title),
          settings: settings,
        );
      case Router.affirmationPageview:
        if (hasInvalidArgs<AffirmationPVArguments>(args)) {
          return misTypedArgsRoute<AffirmationPVArguments>(args);
        }
        final typedArgs =
            args as AffirmationPVArguments ?? AffirmationPVArguments();
        return MaterialPageRoute<dynamic>(
          builder: (_) => AffirmationPV(
              key: typedArgs.key,
              affirmations: typedArgs.affirmations,
              startIndex: typedArgs.startIndex,
              outerBloc: typedArgs.outerBloc),
          settings: settings,
        );
      case Router.settingsPage:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute<dynamic>(
          builder: (_) => SettingsPage(key: typedArgs),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}

//**************************************************************************
// Arguments holder classes
//***************************************************************************

//MyStartPage arguments holder class
class MyStartPageArguments {
  final Key key;
  final String title;
  MyStartPageArguments({this.key, this.title});
}

//OnboardPage arguments holder class
class OnboardPageArguments {
  final Key key;
  final String title;
  OnboardPageArguments({this.key, this.title});
}

//UserIntroPage arguments holder class
class UserIntroPageArguments {
  final Key key;
  final String title;
  UserIntroPageArguments({this.key, this.title});
}

//SortedHome arguments holder class
class SortedHomeArguments {
  final Key key;
  final String title;
  SortedHomeArguments({this.key, this.title});
}

//AffirmationPV arguments holder class
class AffirmationPVArguments {
  final Key key;
  final List<DayAffirmation> affirmations;
  final int startIndex;
  final AffirmationBloc outerBloc;
  AffirmationPVArguments(
      {this.key, this.affirmations, this.startIndex, this.outerBloc});
}
