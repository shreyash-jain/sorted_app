// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:flutter/material.dart' as _i2;

import '../../features/CONNECT/data/models/expert/expert_calendar.dart' as _i31;
import '../../features/CONNECT/presentation/pages/class/classroom_main.dart'
    as _i22;
import '../../features/CONNECT/presentation/pages/class_main.dart' as _i17;
import '../../features/CONNECT/presentation/pages/request_pages/class_list.dart'
    as _i15;
import '../../features/CONNECT/presentation/pages/request_pages/client_consultation_request_form.dart'
    as _i21;
import '../../features/CONNECT/presentation/pages/request_pages/package_request.dart'
    as _i19;
import '../../features/CONNECT/presentation/pages/request_pages/packages_list.dart'
    as _i20;
import '../../features/HOME/data/models/blogs.dart' as _i28;
import '../../features/HOME/data/models/class_model.dart' as _i32;
import '../../features/HOME/data/models/motivation/pep_talks.dart' as _i33;
import '../../features/HOME/data/models/recipes/recipe.dart' as _i29;
import '../../features/HOME/data/models/recipes/tagged_recipe.dart' as _i30;
import '../../features/HOME/domain/entities/day_affirmations.dart' as _i26;
import '../../features/HOME/presentation/bloc_affirmation/affirmation_bloc.dart'
    as _i27;
import '../../features/HOME/presentation/pages/affirmation_pv.dart' as _i8;
import '../../features/HOME/presentation/pages/blog_full_page.dart' as _i13;
import '../../features/HOME/presentation/pages/challenge_pv.dart' as _i11;
import '../../features/HOME/presentation/pages/fit_info_pv.dart' as _i24;
import '../../features/HOME/presentation/pages/homePage.dart' as _i7;
import '../../features/HOME/presentation/pages/recipe_full_page.dart' as _i14;
import '../../features/HOME/presentation/pages/rootPage.dart' as _i10;
import '../../features/HOME/presentation/widgets/pep_talk_player.dart' as _i23;
import '../../features/ONBOARDING/presentation/pages/onboard_page.dart' as _i5;
import '../../features/ONSTART/presentation/pages/start_page.dart' as _i4;
import '../../features/PAYMENTS/presentation/pages/test_payment.dart' as _i16;
import '../../features/SETTINGS/presentation/pages/settings_page.dart' as _i9;
import '../../features/SPLASH/splash.dart' as _i3;
import '../../features/TRACKERS/COMMON/models/track_model.dart' as _i34;
import '../../features/TRACKERS/COMMON/models/track_summary.dart' as _i35;
import '../../features/TRACKERS/presentation/pages/track_analysis_page.dart'
    as _i25;
import '../../features/USER_INTRODUCTION/presentation/pages/userIntroMain.dart'
    as _i6;
import '../../features/VIDEO_APP/presentation/pages/video_page.dart' as _i12;
import '../services/cashfree_gateway.dart' as _i18;

class ARouter extends _i1.RootStackRouter {
  ARouter([_i2.GlobalKey<_i2.NavigatorState> navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    SplashRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i3.SplashPage();
        }),
    MyStartRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<MyStartRouteArgs>(
              orElse: () => const MyStartRouteArgs());
          return _i4.MyStartPage(key: args.key, title: args.title);
        }),
    OnboardRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<OnboardRouteArgs>(
              orElse: () => const OnboardRouteArgs());
          return _i5.OnboardPage(key: args.key, title: args.title);
        }),
    UserIntroRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<UserIntroRouteArgs>(
              orElse: () => const UserIntroRouteArgs());
          return _i6.UserIntroPage(key: args.key, title: args.title);
        }),
    SortedHome.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args =
              data.argsAs<SortedHomeArgs>(orElse: () => const SortedHomeArgs());
          return _i7.SortedHome(key: args.key, title: args.title);
        }),
    AffirmationPV.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<AffirmationPVArgs>(
              orElse: () => const AffirmationPVArgs());
          return _i8.AffirmationPV(
              key: args.key,
              affirmations: args.affirmations,
              startIndex: args.startIndex,
              outerBloc: args.outerBloc);
        }),
    SettingsRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<SettingsRouteArgs>(
              orElse: () => const SettingsRouteArgs());
          return _i9.SettingsPage(key: args.key);
        }),
    RootHome.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i10.RootHome();
        }),
    ChallengeRouteView.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i11.ChallengePageView();
        }),
    VideoRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i12.VideoPage();
        }),
    FullBlogRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<FullBlogRouteArgs>(
              orElse: () => const FullBlogRouteArgs());
          return _i13.FullBlogPage(key: args.key, blog: args.blog);
        }),
    RecipeRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<RecipeRouteArgs>(
              orElse: () => const RecipeRouteArgs());
          return _i14.RecipePage(
              key: args.key,
              type: args.type,
              recipe: args.recipe,
              taggedRecipe: args.taggedRecipe);
        }),
    ClassListRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<ClassListRouteArgs>(
              orElse: () => const ClassListRouteArgs());
          return _i15.ClassListPage(key: args.key, classId: args.classId);
        }),
    TestPayment.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<TestPaymentArgs>(
              orElse: () => const TestPaymentArgs());
          return _i16.TestPayment(key: args.key);
        }),
    ClassMain.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args =
              data.argsAs<ClassMainArgs>(orElse: () => const ClassMainArgs());
          return _i17.ClassMain(key: args.key);
        }),
    CashFreeTest.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i18.CashFreeTest();
        }),
    ExpertPackageRequestRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<ExpertPackageRequestRouteArgs>(
              orElse: () => const ExpertPackageRequestRouteArgs());
          return _i19.ExpertPackageRequestPage(
              key: args.key, packageId: args.packageId);
        }),
    ExpertPackagesCatalogue.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<ExpertPackagesCatalogueArgs>(
              orElse: () => const ExpertPackagesCatalogueArgs());
          return _i20.ExpertPackagesCatalogue(
              key: args.key, expertId: args.expertId);
        }),
    ClientRequestForm.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<ClientRequestFormArgs>(
              orElse: () => const ClientRequestFormArgs());
          return _i21.ClientRequestForm(
              key: args.key,
              calendarModel: args.calendarModel,
              packageType: args.packageType,
              onPressEnroll: args.onPressEnroll);
        }),
    ClassroomMain.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<ClassroomMainArgs>(
              orElse: () => const ClassroomMainArgs());
          return _i22.ClassroomMain(key: args.key, classroom: args.classroom);
        }),
    PepTalkPlayer.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<PepTalkPlayerArgs>(
              orElse: () => const PepTalkPlayerArgs());
          return _i23.PepTalkPlayer(key: args.key, talk: args.talk);
        }),
    FitInfoPV.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args =
              data.argsAs<FitInfoPVArgs>(orElse: () => const FitInfoPVArgs());
          return _i24.FitInfoPV(
              key: args.key,
              trackModel: args.trackModel,
              summary: args.summary);
        }),
    PerformanceAnalysisRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<PerformanceAnalysisRouteArgs>(
              orElse: () => const PerformanceAnalysisRouteArgs());
          return _i25.PerformanceAnalysisPage(
              key: args.key, summary: args.summary, track: args.track);
        })
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(SplashRoute.name, path: '/'),
        _i1.RouteConfig(MyStartRoute.name, path: '/my-start-page'),
        _i1.RouteConfig(OnboardRoute.name, path: '/onboard-page'),
        _i1.RouteConfig(UserIntroRoute.name, path: '/user-intro-page'),
        _i1.RouteConfig(SortedHome.name, path: '/sorted-home'),
        _i1.RouteConfig(AffirmationPV.name, path: '/affirmation-pV'),
        _i1.RouteConfig(SettingsRoute.name, path: '/settings-page'),
        _i1.RouteConfig(RootHome.name, path: '/root-home'),
        _i1.RouteConfig(ChallengeRouteView.name, path: '/challenge-page-view'),
        _i1.RouteConfig(VideoRoute.name, path: '/video-page'),
        _i1.RouteConfig(FullBlogRoute.name, path: '/full-blog-page'),
        _i1.RouteConfig(RecipeRoute.name, path: '/recipe-page'),
        _i1.RouteConfig(ClassListRoute.name, path: '/class-list-page'),
        _i1.RouteConfig(TestPayment.name, path: '/test-payment'),
        _i1.RouteConfig(ClassMain.name, path: '/class-main'),
        _i1.RouteConfig(CashFreeTest.name, path: '/cash-free-test'),
        _i1.RouteConfig(ExpertPackageRequestRoute.name,
            path: '/expert-package-request-page'),
        _i1.RouteConfig(ExpertPackagesCatalogue.name,
            path: '/expert-packages-catalogue'),
        _i1.RouteConfig(ClientRequestForm.name, path: '/client-request-form'),
        _i1.RouteConfig(ClassroomMain.name, path: '/classroom-main'),
        _i1.RouteConfig(PepTalkPlayer.name, path: '/pep-talk-player'),
        _i1.RouteConfig(FitInfoPV.name, path: '/fit-info-pV'),
        _i1.RouteConfig(PerformanceAnalysisRoute.name,
            path: '/performance-analysis-page')
      ];
}

class SplashRoute extends _i1.PageRouteInfo {
  const SplashRoute() : super(name, path: '/');

  static const String name = 'SplashRoute';
}

class MyStartRoute extends _i1.PageRouteInfo<MyStartRouteArgs> {
  MyStartRoute({_i2.Key key, String title})
      : super(name,
            path: '/my-start-page',
            args: MyStartRouteArgs(key: key, title: title));

  static const String name = 'MyStartRoute';
}

class MyStartRouteArgs {
  const MyStartRouteArgs({this.key, this.title});

  final _i2.Key key;

  final String title;
}

class OnboardRoute extends _i1.PageRouteInfo<OnboardRouteArgs> {
  OnboardRoute({_i2.Key key, String title})
      : super(name,
            path: '/onboard-page',
            args: OnboardRouteArgs(key: key, title: title));

  static const String name = 'OnboardRoute';
}

class OnboardRouteArgs {
  const OnboardRouteArgs({this.key, this.title});

  final _i2.Key key;

  final String title;
}

class UserIntroRoute extends _i1.PageRouteInfo<UserIntroRouteArgs> {
  UserIntroRoute({_i2.Key key, String title})
      : super(name,
            path: '/user-intro-page',
            args: UserIntroRouteArgs(key: key, title: title));

  static const String name = 'UserIntroRoute';
}

class UserIntroRouteArgs {
  const UserIntroRouteArgs({this.key, this.title});

  final _i2.Key key;

  final String title;
}

class SortedHome extends _i1.PageRouteInfo<SortedHomeArgs> {
  SortedHome({_i2.Key key, String title})
      : super(name,
            path: '/sorted-home', args: SortedHomeArgs(key: key, title: title));

  static const String name = 'SortedHome';
}

class SortedHomeArgs {
  const SortedHomeArgs({this.key, this.title});

  final _i2.Key key;

  final String title;
}

class AffirmationPV extends _i1.PageRouteInfo<AffirmationPVArgs> {
  AffirmationPV(
      {_i2.Key key,
      List<_i26.DayAffirmation> affirmations,
      int startIndex,
      _i27.AffirmationBloc outerBloc})
      : super(name,
            path: '/affirmation-pV',
            args: AffirmationPVArgs(
                key: key,
                affirmations: affirmations,
                startIndex: startIndex,
                outerBloc: outerBloc));

  static const String name = 'AffirmationPV';
}

class AffirmationPVArgs {
  const AffirmationPVArgs(
      {this.key, this.affirmations, this.startIndex, this.outerBloc});

  final _i2.Key key;

  final List<_i26.DayAffirmation> affirmations;

  final int startIndex;

  final _i27.AffirmationBloc outerBloc;
}

class SettingsRoute extends _i1.PageRouteInfo<SettingsRouteArgs> {
  SettingsRoute({_i2.Key key})
      : super(name, path: '/settings-page', args: SettingsRouteArgs(key: key));

  static const String name = 'SettingsRoute';
}

class SettingsRouteArgs {
  const SettingsRouteArgs({this.key});

  final _i2.Key key;
}

class RootHome extends _i1.PageRouteInfo {
  const RootHome() : super(name, path: '/root-home');

  static const String name = 'RootHome';
}

class ChallengeRouteView extends _i1.PageRouteInfo {
  const ChallengeRouteView() : super(name, path: '/challenge-page-view');

  static const String name = 'ChallengeRouteView';
}

class VideoRoute extends _i1.PageRouteInfo {
  const VideoRoute() : super(name, path: '/video-page');

  static const String name = 'VideoRoute';
}

class FullBlogRoute extends _i1.PageRouteInfo<FullBlogRouteArgs> {
  FullBlogRoute({_i2.Key key, _i28.BlogModel blog})
      : super(name,
            path: '/full-blog-page',
            args: FullBlogRouteArgs(key: key, blog: blog));

  static const String name = 'FullBlogRoute';
}

class FullBlogRouteArgs {
  const FullBlogRouteArgs({this.key, this.blog});

  final _i2.Key key;

  final _i28.BlogModel blog;
}

class RecipeRoute extends _i1.PageRouteInfo<RecipeRouteArgs> {
  RecipeRoute(
      {_i2.Key key,
      int type,
      _i29.RecipeModel recipe,
      _i30.TaggedRecipe taggedRecipe})
      : super(name,
            path: '/recipe-page',
            args: RecipeRouteArgs(
                key: key,
                type: type,
                recipe: recipe,
                taggedRecipe: taggedRecipe));

  static const String name = 'RecipeRoute';
}

class RecipeRouteArgs {
  const RecipeRouteArgs({this.key, this.type, this.recipe, this.taggedRecipe});

  final _i2.Key key;

  final int type;

  final _i29.RecipeModel recipe;

  final _i30.TaggedRecipe taggedRecipe;
}

class ClassListRoute extends _i1.PageRouteInfo<ClassListRouteArgs> {
  ClassListRoute({_i2.Key key, String classId})
      : super(name,
            path: '/class-list-page',
            args: ClassListRouteArgs(key: key, classId: classId));

  static const String name = 'ClassListRoute';
}

class ClassListRouteArgs {
  const ClassListRouteArgs({this.key, this.classId});

  final _i2.Key key;

  final String classId;
}

class TestPayment extends _i1.PageRouteInfo<TestPaymentArgs> {
  TestPayment({_i2.Key key})
      : super(name, path: '/test-payment', args: TestPaymentArgs(key: key));

  static const String name = 'TestPayment';
}

class TestPaymentArgs {
  const TestPaymentArgs({this.key});

  final _i2.Key key;
}

class ClassMain extends _i1.PageRouteInfo<ClassMainArgs> {
  ClassMain({_i2.Key key})
      : super(name, path: '/class-main', args: ClassMainArgs(key: key));

  static const String name = 'ClassMain';
}

class ClassMainArgs {
  const ClassMainArgs({this.key});

  final _i2.Key key;
}

class CashFreeTest extends _i1.PageRouteInfo {
  const CashFreeTest() : super(name, path: '/cash-free-test');

  static const String name = 'CashFreeTest';
}

class ExpertPackageRequestRoute
    extends _i1.PageRouteInfo<ExpertPackageRequestRouteArgs> {
  ExpertPackageRequestRoute({_i2.Key key, String packageId})
      : super(name,
            path: '/expert-package-request-page',
            args:
                ExpertPackageRequestRouteArgs(key: key, packageId: packageId));

  static const String name = 'ExpertPackageRequestRoute';
}

class ExpertPackageRequestRouteArgs {
  const ExpertPackageRequestRouteArgs({this.key, this.packageId});

  final _i2.Key key;

  final String packageId;
}

class ExpertPackagesCatalogue
    extends _i1.PageRouteInfo<ExpertPackagesCatalogueArgs> {
  ExpertPackagesCatalogue({_i2.Key key, String expertId})
      : super(name,
            path: '/expert-packages-catalogue',
            args: ExpertPackagesCatalogueArgs(key: key, expertId: expertId));

  static const String name = 'ExpertPackagesCatalogue';
}

class ExpertPackagesCatalogueArgs {
  const ExpertPackagesCatalogueArgs({this.key, this.expertId});

  final _i2.Key key;

  final String expertId;
}

class ClientRequestForm extends _i1.PageRouteInfo<ClientRequestFormArgs> {
  ClientRequestForm(
      {_i2.Key key,
      _i31.ExpertCalendarModel calendarModel,
      int packageType,
      dynamic Function(List<int>, List<int>, List<int>, DateTime, String, int)
          onPressEnroll})
      : super(name,
            path: '/client-request-form',
            args: ClientRequestFormArgs(
                key: key,
                calendarModel: calendarModel,
                packageType: packageType,
                onPressEnroll: onPressEnroll));

  static const String name = 'ClientRequestForm';
}

class ClientRequestFormArgs {
  const ClientRequestFormArgs(
      {this.key, this.calendarModel, this.packageType, this.onPressEnroll});

  final _i2.Key key;

  final _i31.ExpertCalendarModel calendarModel;

  final int packageType;

  final dynamic Function(List<int>, List<int>, List<int>, DateTime, String, int)
      onPressEnroll;
}

class ClassroomMain extends _i1.PageRouteInfo<ClassroomMainArgs> {
  ClassroomMain({_i2.Key key, _i32.ClassModel classroom})
      : super(name,
            path: '/classroom-main',
            args: ClassroomMainArgs(key: key, classroom: classroom));

  static const String name = 'ClassroomMain';
}

class ClassroomMainArgs {
  const ClassroomMainArgs({this.key, this.classroom});

  final _i2.Key key;

  final _i32.ClassModel classroom;
}

class PepTalkPlayer extends _i1.PageRouteInfo<PepTalkPlayerArgs> {
  PepTalkPlayer({_i2.Key key, _i33.PepTalkModel talk})
      : super(name,
            path: '/pep-talk-player',
            args: PepTalkPlayerArgs(key: key, talk: talk));

  static const String name = 'PepTalkPlayer';
}

class PepTalkPlayerArgs {
  const PepTalkPlayerArgs({this.key, this.talk});

  final _i2.Key key;

  final _i33.PepTalkModel talk;
}

class FitInfoPV extends _i1.PageRouteInfo<FitInfoPVArgs> {
  FitInfoPV(
      {_i2.Key key, _i34.TrackModel trackModel, _i35.TrackSummary summary})
      : super(name,
            path: '/fit-info-pV',
            args: FitInfoPVArgs(
                key: key, trackModel: trackModel, summary: summary));

  static const String name = 'FitInfoPV';
}

class FitInfoPVArgs {
  const FitInfoPVArgs({this.key, this.trackModel, this.summary});

  final _i2.Key key;

  final _i34.TrackModel trackModel;

  final _i35.TrackSummary summary;
}

class PerformanceAnalysisRoute
    extends _i1.PageRouteInfo<PerformanceAnalysisRouteArgs> {
  PerformanceAnalysisRoute(
      {_i2.Key key, _i35.TrackSummary summary, _i34.TrackModel track})
      : super(name,
            path: '/performance-analysis-page',
            args: PerformanceAnalysisRouteArgs(
                key: key, summary: summary, track: track));

  static const String name = 'PerformanceAnalysisRoute';
}

class PerformanceAnalysisRouteArgs {
  const PerformanceAnalysisRouteArgs({this.key, this.summary, this.track});

  final _i2.Key key;

  final _i35.TrackSummary summary;

  final _i34.TrackModel track;
}
