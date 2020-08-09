// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/router_utils.dart';
import 'package:sorted/features/ONSTART/presentation/pages/start_page.dart';

class Router {
  static const startPage = '/';
  static GlobalKey<NavigatorState> get navigatorKey =>
      getNavigatorKey<Router>();
  static NavigatorState get navigator => navigatorKey.currentState;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Router.startPage:
        if (hasInvalidArgs<MyStartPageArguments>(args)) {
          return misTypedArgsRoute<MyStartPageArguments>(args);
        }
        final typedArgs =
            args as MyStartPageArguments ?? MyStartPageArguments();
        return MaterialPageRoute(
          builder: (_) =>
              MyStartPage(key: typedArgs.key, title: typedArgs.title),
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
