// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:flutter/material.dart' as _i2;

import '../../features/FILES/data/models/note_model.dart' as _i33;
import '../../features/FILES/data/models/notebook_model.dart' as _i34;
import '../../features/FILES/presentation/pages/notes_hub.dart' as _i21;
import '../../features/FILES/presentation/pages/record_home.dart' as _i20;
import '../../features/FILES/presentation/pages/test_note.dart' as _i19;
import '../../features/HOME/data/models/blogs.dart' as _i35;
import '../../features/HOME/domain/entities/day_affirmations.dart' as _i27;
import '../../features/HOME/presentation/bloc_affirmation/affirmation_bloc.dart'
    as _i28;
import '../../features/HOME/presentation/pages/affirmation_pv.dart' as _i8;
import '../../features/HOME/presentation/pages/blog_full_page.dart' as _i26;
import '../../features/HOME/presentation/pages/challenge_pv.dart' as _i23;
import '../../features/HOME/presentation/pages/homePage.dart' as _i7;
import '../../features/HOME/presentation/pages/rootPage.dart' as _i22;
import '../../features/ONBOARDING/presentation/pages/onboard_page.dart' as _i5;
import '../../features/ONSTART/presentation/pages/start_page.dart' as _i4;
import '../../features/PLAN/data/models/goal.dart' as _i29;
import '../../features/PLAN/data/models/task.dart' as _i32;
import '../../features/PLAN/presentation/bloc/goal_page_bloc/goal_page_bloc.dart'
    as _i31;
import '../../features/PLAN/presentation/bloc/plan_bloc/plan_bloc.dart' as _i30;
import '../../features/PLAN/presentation/pages/choice_goal_guide.dart' as _i11;
import '../../features/PLAN/presentation/pages/goal_page.dart' as _i12;
import '../../features/PLAN/presentation/pages/kanban_view.dart' as _i15;
import '../../features/PLAN/presentation/pages/long_term_planner.dart' as _i18;
import '../../features/PLAN/presentation/pages/main_plan.dart' as _i10;
import '../../features/PLAN/presentation/pages/select_cover_image.dart' as _i13;
import '../../features/PLAN/presentation/pages/task_page.dart' as _i14;
import '../../features/PLAN/presentation/pages/timeline_view.dart' as _i16;
import '../../features/PLAN/presentation/pages/year_planner.dart' as _i17;
import '../../features/SETTINGS/presentation/pages/settings_page.dart' as _i9;
import '../../features/SPLASH/splash.dart' as _i3;
import '../../features/TRACKERS/TRACK_STORE/presentation/pages/track_store_main.dart'
    as _i24;
import '../../features/USER_INTRODUCTION/presentation/pages/userIntroMain.dart'
    as _i6;
import '../../features/VIDEO_APP/presentation/pages/video_page.dart' as _i25;

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
    PlanHome.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i10.PlanHome();
        }),
    ChoiceGoalGuide.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i11.ChoiceGoalGuide();
        }),
    GoalRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args =
              data.argsAs<GoalRouteArgs>(orElse: () => const GoalRouteArgs());
          return _i12.GoalPage(
              key: args.key, thisGoal: args.thisGoal, planBloc: args.planBloc);
        }),
    SelectCover.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<SelectCoverArgs>(
              orElse: () => const SelectCoverArgs());
          return _i13.SelectCover(key: args.key, goalBloc: args.goalBloc);
        }),
    TaskRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args =
              data.argsAs<TaskRouteArgs>(orElse: () => const TaskRouteArgs());
          return _i14.TaskPage(
              key: args.key, thisGoal: args.thisGoal, planBloc: args.planBloc);
        }),
    Kanban.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i15.Kanban();
        }),
    TimelineView.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i16.TimelineView();
        }),
    YearPlanner.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i17.YearPlanner();
        }),
    LongPlanner.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i18.LongPlanner();
        }),
    NoteMain.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args =
              data.argsAs<NoteMainArgs>(orElse: () => const NoteMainArgs());
          return _i19.NoteMain(key: args.key, note: args.note);
        }),
    RecordTab.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i20.RecordTab();
        }),
    NotesHubRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<NotesHubRouteArgs>(
              orElse: () => const NotesHubRouteArgs());
          return _i21.NotesHubPage(
              key: args.key, thisNotebook: args.thisNotebook);
        }),
    RootHome.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i22.RootHome();
        }),
    ChallengeRouteView.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i23.ChallengePageView();
        }),
    TrackStoreMain.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i24.TrackStoreMain();
        }),
    VideoRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i25.VideoPage();
        }),
    FullBlogRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<FullBlogRouteArgs>(
              orElse: () => const FullBlogRouteArgs());
          return _i26.FullBlogPage(key: args.key, blog: args.blog);
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
        _i1.RouteConfig(PlanHome.name, path: '/plan-home'),
        _i1.RouteConfig(ChoiceGoalGuide.name, path: '/choice-goal-guide'),
        _i1.RouteConfig(GoalRoute.name, path: '/goal-page'),
        _i1.RouteConfig(ChoiceGoalGuide.name, path: '/choice-goal-guide'),
        _i1.RouteConfig(SelectCover.name, path: '/select-cover'),
        _i1.RouteConfig(TaskRoute.name, path: '/task-page'),
        _i1.RouteConfig(Kanban.name, path: '/Kanban'),
        _i1.RouteConfig(TimelineView.name, path: '/timeline-view'),
        _i1.RouteConfig(YearPlanner.name, path: '/year-planner'),
        _i1.RouteConfig(LongPlanner.name, path: '/long-planner'),
        _i1.RouteConfig(NoteMain.name, path: '/note-main'),
        _i1.RouteConfig(RecordTab.name, path: '/record-tab'),
        _i1.RouteConfig(NotesHubRoute.name, path: '/notes-hub-page'),
        _i1.RouteConfig(RootHome.name, path: '/root-home'),
        _i1.RouteConfig(ChallengeRouteView.name, path: '/challenge-page-view'),
        _i1.RouteConfig(TrackStoreMain.name, path: '/track-store-main'),
        _i1.RouteConfig(VideoRoute.name, path: '/video-page'),
        _i1.RouteConfig(FullBlogRoute.name, path: '/full-blog-page')
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
      List<_i27.DayAffirmation> affirmations,
      int startIndex,
      _i28.AffirmationBloc outerBloc})
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

  final List<_i27.DayAffirmation> affirmations;

  final int startIndex;

  final _i28.AffirmationBloc outerBloc;
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

class PlanHome extends _i1.PageRouteInfo {
  const PlanHome() : super(name, path: '/plan-home');

  static const String name = 'PlanHome';
}

class ChoiceGoalGuide extends _i1.PageRouteInfo {
  const ChoiceGoalGuide() : super(name, path: '/choice-goal-guide');

  static const String name = 'ChoiceGoalGuide';
}

class GoalRoute extends _i1.PageRouteInfo<GoalRouteArgs> {
  GoalRoute({_i2.Key key, _i29.GoalModel thisGoal, _i30.PlanBloc planBloc})
      : super(name,
            path: '/goal-page',
            args: GoalRouteArgs(
                key: key, thisGoal: thisGoal, planBloc: planBloc));

  static const String name = 'GoalRoute';
}

class GoalRouteArgs {
  const GoalRouteArgs({this.key, this.thisGoal, this.planBloc});

  final _i2.Key key;

  final _i29.GoalModel thisGoal;

  final _i30.PlanBloc planBloc;
}

class SelectCover extends _i1.PageRouteInfo<SelectCoverArgs> {
  SelectCover({_i2.Key key, _i31.GoalPageBloc goalBloc})
      : super(name,
            path: '/select-cover',
            args: SelectCoverArgs(key: key, goalBloc: goalBloc));

  static const String name = 'SelectCover';
}

class SelectCoverArgs {
  const SelectCoverArgs({this.key, this.goalBloc});

  final _i2.Key key;

  final _i31.GoalPageBloc goalBloc;
}

class TaskRoute extends _i1.PageRouteInfo<TaskRouteArgs> {
  TaskRoute({_i2.Key key, _i32.TaskModel thisGoal, _i30.PlanBloc planBloc})
      : super(name,
            path: '/task-page',
            args: TaskRouteArgs(
                key: key, thisGoal: thisGoal, planBloc: planBloc));

  static const String name = 'TaskRoute';
}

class TaskRouteArgs {
  const TaskRouteArgs({this.key, this.thisGoal, this.planBloc});

  final _i2.Key key;

  final _i32.TaskModel thisGoal;

  final _i30.PlanBloc planBloc;
}

class Kanban extends _i1.PageRouteInfo {
  const Kanban() : super(name, path: '/Kanban');

  static const String name = 'Kanban';
}

class TimelineView extends _i1.PageRouteInfo {
  const TimelineView() : super(name, path: '/timeline-view');

  static const String name = 'TimelineView';
}

class YearPlanner extends _i1.PageRouteInfo {
  const YearPlanner() : super(name, path: '/year-planner');

  static const String name = 'YearPlanner';
}

class LongPlanner extends _i1.PageRouteInfo {
  const LongPlanner() : super(name, path: '/long-planner');

  static const String name = 'LongPlanner';
}

class NoteMain extends _i1.PageRouteInfo<NoteMainArgs> {
  NoteMain({_i2.Key key, _i33.NoteModel note})
      : super(name,
            path: '/note-main', args: NoteMainArgs(key: key, note: note));

  static const String name = 'NoteMain';
}

class NoteMainArgs {
  const NoteMainArgs({this.key, this.note});

  final _i2.Key key;

  final _i33.NoteModel note;
}

class RecordTab extends _i1.PageRouteInfo {
  const RecordTab() : super(name, path: '/record-tab');

  static const String name = 'RecordTab';
}

class NotesHubRoute extends _i1.PageRouteInfo<NotesHubRouteArgs> {
  NotesHubRoute({_i2.Key key, _i34.NotebookModel thisNotebook})
      : super(name,
            path: '/notes-hub-page',
            args: NotesHubRouteArgs(key: key, thisNotebook: thisNotebook));

  static const String name = 'NotesHubRoute';
}

class NotesHubRouteArgs {
  const NotesHubRouteArgs({this.key, this.thisNotebook});

  final _i2.Key key;

  final _i34.NotebookModel thisNotebook;
}

class RootHome extends _i1.PageRouteInfo {
  const RootHome() : super(name, path: '/root-home');

  static const String name = 'RootHome';
}

class ChallengeRouteView extends _i1.PageRouteInfo {
  const ChallengeRouteView() : super(name, path: '/challenge-page-view');

  static const String name = 'ChallengeRouteView';
}

class TrackStoreMain extends _i1.PageRouteInfo {
  const TrackStoreMain() : super(name, path: '/track-store-main');

  static const String name = 'TrackStoreMain';
}

class VideoRoute extends _i1.PageRouteInfo {
  const VideoRoute() : super(name, path: '/video-page');

  static const String name = 'VideoRoute';
}

class FullBlogRoute extends _i1.PageRouteInfo<FullBlogRouteArgs> {
  FullBlogRoute({_i2.Key key, _i35.BlogModel blog})
      : super(name,
            path: '/full-blog-page',
            args: FullBlogRouteArgs(key: key, blog: blog));

  static const String name = 'FullBlogRoute';
}

class FullBlogRouteArgs {
  const FullBlogRouteArgs({this.key, this.blog});

  final _i2.Key key;

  final _i35.BlogModel blog;
}
