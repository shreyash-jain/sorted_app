import 'package:auto_route/auto_route_annotations.dart';
import 'package:auto_route/transitions_builders.dart';
import 'package:sorted/features/ONSTART/presentation/pages/start_page.dart';
import 'package:sorted/features/SPLASH/splash.dart';

@autoRouter
class $Router {
  @initial
  SplashPage splashPage;
  MyStartPage startPage;
}
