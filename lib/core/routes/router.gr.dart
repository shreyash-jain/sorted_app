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
import 'package:sorted/features/PLAN/presentation/pages/main_plan.dart';
import 'package:sorted/features/PLAN/presentation/pages/choice_goal_guide.dart';
import 'package:sorted/features/PLAN/presentation/pages/goal_page.dart';
import 'package:sorted/features/PLAN/data/models/goal.dart';
import 'package:sorted/features/PLAN/presentation/bloc/plan_bloc/plan_bloc.dart';
import 'package:sorted/features/PLAN/presentation/pages/select_cover_image.dart';
import 'package:sorted/features/PLAN/presentation/bloc/goal_page_bloc/goal_page_bloc.dart';
import 'package:sorted/features/PLAN/presentation/pages/task_page.dart';
import 'package:sorted/features/PLAN/data/models/task.dart';
import 'package:sorted/features/PLAN/presentation/pages/kanban_view.dart';
import 'package:sorted/features/PLAN/presentation/pages/timeline_view.dart';
import 'package:sorted/features/PLAN/presentation/pages/year_planner.dart';
import 'package:sorted/features/PLAN/presentation/pages/long_term_planner.dart';
import 'package:sorted/features/FILES/presentation/pages/test_note.dart';
import 'package:sorted/features/FILES/data/models/note_model.dart';
import 'package:sorted/features/FILES/presentation/pages/record_home.dart';
import 'package:sorted/features/FILES/presentation/pages/notes_hub.dart';
import 'package:sorted/features/FILES/data/models/notebook_model.dart';
import 'package:sorted/features/HOME/presentation/pages/rootPage.dart';
import 'package:sorted/features/HOME/presentation/pages/challenge_pv.dart';

class Router {
  static const splashPage = '/';
  static const startPage = '/start-page';
  static const onboardPage = '/onboard-page';
  static const userIntroPage = '/user-intro-page';
  static const homePage = '/home-page';
  static const affirmationPageview = '/affirmation-pageview';
  static const settingsPage = '/settings-page';
  static const planHome = '/plan-home';
  static const choiceGoalGuide = '/choice-goal-guide';
  static const goalPage = '/goal-page';
  static const selectCover = '/select-cover';
  static const taskPage = '/task-page';
  static const kanbanPage = '/kanban-page';
  static const timelineView = '/timeline-view';
  static const yearPlanner = '/year-planner';
  static const longPlanner = '/long-planner';
  static const noteHub = '/note-hub';
  static const recordTab = '/record-tab';
  static const notesHubPage = '/notes-hub-page';
  static const rootHome = '/root-home';
  static const challengePageView = '/challenge-page-view';
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
      case Router.planHome:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute<dynamic>(
          builder: (_) => PlanHome(key: typedArgs),
          settings: settings,
        );
      case Router.choiceGoalGuide:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute<dynamic>(
          builder: (_) => ChoiceGoalGuide(key: typedArgs),
          settings: settings,
        );
      case Router.goalPage:
        if (hasInvalidArgs<GoalPageArguments>(args)) {
          return misTypedArgsRoute<GoalPageArguments>(args);
        }
        final typedArgs = args as GoalPageArguments ?? GoalPageArguments();
        return PageRouteBuilder<dynamic>(
          pageBuilder: (ctx, animation, secondaryAnimation) => GoalPage(
              key: typedArgs.key,
              thisGoal: typedArgs.thisGoal,
              planBloc: typedArgs.planBloc),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.fadeIn,
          transitionDuration: Duration(milliseconds: 200),
        );
      case Router.selectCover:
        if (hasInvalidArgs<SelectCoverArguments>(args)) {
          return misTypedArgsRoute<SelectCoverArguments>(args);
        }
        final typedArgs =
            args as SelectCoverArguments ?? SelectCoverArguments();
        return MaterialPageRoute<dynamic>(
          builder: (_) =>
              SelectCover(key: typedArgs.key, goalBloc: typedArgs.goalBloc),
          settings: settings,
        );
      case Router.taskPage:
        if (hasInvalidArgs<TaskPageArguments>(args)) {
          return misTypedArgsRoute<TaskPageArguments>(args);
        }
        final typedArgs = args as TaskPageArguments ?? TaskPageArguments();
        return PageRouteBuilder<dynamic>(
          pageBuilder: (ctx, animation, secondaryAnimation) => TaskPage(
              key: typedArgs.key,
              thisGoal: typedArgs.thisGoal,
              planBloc: typedArgs.planBloc),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.fadeIn,
          transitionDuration: Duration(milliseconds: 200),
        );
      case Router.kanbanPage:
        return PageRouteBuilder<dynamic>(
          pageBuilder: (ctx, animation, secondaryAnimation) => Kanban(),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.fadeIn,
          transitionDuration: Duration(milliseconds: 200),
        );
      case Router.timelineView:
        return PageRouteBuilder<dynamic>(
          pageBuilder: (ctx, animation, secondaryAnimation) => TimelineView(),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.fadeIn,
          transitionDuration: Duration(milliseconds: 200),
        );
      case Router.yearPlanner:
        return PageRouteBuilder<dynamic>(
          pageBuilder: (ctx, animation, secondaryAnimation) => YearPlanner(),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.fadeIn,
          transitionDuration: Duration(milliseconds: 200),
        );
      case Router.longPlanner:
        return PageRouteBuilder<dynamic>(
          pageBuilder: (ctx, animation, secondaryAnimation) => LongPlanner(),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.fadeIn,
          transitionDuration: Duration(milliseconds: 200),
        );
      case Router.noteHub:
        if (hasInvalidArgs<NoteMainArguments>(args)) {
          return misTypedArgsRoute<NoteMainArguments>(args);
        }
        final typedArgs = args as NoteMainArguments ?? NoteMainArguments();
        return PageRouteBuilder<dynamic>(
          pageBuilder: (ctx, animation, secondaryAnimation) =>
              NoteMain(key: typedArgs.key, note: typedArgs.note),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.fadeIn,
          transitionDuration: Duration(milliseconds: 200),
        );
      case Router.recordTab:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return PageRouteBuilder<dynamic>(
          pageBuilder: (ctx, animation, secondaryAnimation) =>
              RecordTab(key: typedArgs),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.fadeIn,
          transitionDuration: Duration(milliseconds: 200),
        );
      case Router.notesHubPage:
        if (hasInvalidArgs<NotesHubPageArguments>(args)) {
          return misTypedArgsRoute<NotesHubPageArguments>(args);
        }
        final typedArgs =
            args as NotesHubPageArguments ?? NotesHubPageArguments();
        return PageRouteBuilder<dynamic>(
          pageBuilder: (ctx, animation, secondaryAnimation) => NotesHubPage(
              key: typedArgs.key, thisNotebook: typedArgs.thisNotebook),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.fadeIn,
          transitionDuration: Duration(milliseconds: 200),
        );
      case Router.rootHome:
        return PageRouteBuilder<dynamic>(
          pageBuilder: (ctx, animation, secondaryAnimation) => RootHome(),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.fadeIn,
          transitionDuration: Duration(milliseconds: 200),
        );
      case Router.challengePageView:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return PageRouteBuilder<dynamic>(
          pageBuilder: (ctx, animation, secondaryAnimation) =>
              ChallengePageView(key: typedArgs),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.fadeIn,
          transitionDuration: Duration(milliseconds: 200),
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

//GoalPage arguments holder class
class GoalPageArguments {
  final Key key;
  final GoalModel thisGoal;
  final PlanBloc planBloc;
  GoalPageArguments({this.key, this.thisGoal, this.planBloc});
}

//SelectCover arguments holder class
class SelectCoverArguments {
  final Key key;
  final GoalPageBloc goalBloc;
  SelectCoverArguments({this.key, this.goalBloc});
}

//TaskPage arguments holder class
class TaskPageArguments {
  final Key key;
  final TaskModel thisGoal;
  final PlanBloc planBloc;
  TaskPageArguments({this.key, this.thisGoal, this.planBloc});
}

//NoteMain arguments holder class
class NoteMainArguments {
  final Key key;
  final NoteModel note;
  NoteMainArguments({this.key, this.note});
}

//NotesHubPage arguments holder class
class NotesHubPageArguments {
  final Key key;
  final NotebookModel thisNotebook;
  NotesHubPageArguments({this.key, this.thisNotebook});
}
