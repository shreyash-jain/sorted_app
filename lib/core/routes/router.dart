import 'package:auto_route/auto_route.dart';
import 'package:auto_route/auto_route_annotations.dart';
import 'package:sorted/features/FILES/presentation/pages/notes_hub.dart';
import 'package:sorted/features/FILES/presentation/pages/record_home.dart';
import 'package:sorted/features/FILES/presentation/pages/record_page_loaded.dart';
import 'package:sorted/features/FILES/presentation/pages/test_note.dart';
import 'package:sorted/features/HOME/presentation/pages/affirmation_pv.dart';
import 'package:sorted/features/HOME/presentation/pages/challenge_pv.dart';
import 'package:sorted/features/HOME/presentation/pages/homePage.dart';
import 'package:sorted/features/HOME/presentation/pages/rootPage.dart';

import 'package:sorted/features/ONBOARDING/presentation/pages/onboard_page.dart';
import 'package:sorted/features/ONSTART/presentation/pages/start_page.dart';
import 'package:sorted/features/PLAN/presentation/pages/choice_goal_guide.dart';
import 'package:sorted/features/PLAN/presentation/pages/goal_page.dart';
import 'package:sorted/features/PLAN/presentation/pages/kanban_view.dart';
import 'package:sorted/features/PLAN/presentation/pages/long_term_planner.dart';
import 'package:sorted/features/PLAN/presentation/pages/main_plan.dart';
import 'package:sorted/features/PLAN/presentation/pages/select_cover_image.dart';
import 'package:sorted/features/PLAN/presentation/pages/task_page.dart';
import 'package:sorted/features/PLAN/presentation/pages/timeline_view.dart';
import 'package:sorted/features/PLAN/presentation/pages/year_planner.dart';
import 'package:sorted/features/SETTINGS/presentation/pages/settings_page.dart';
import 'package:sorted/features/SPLASH/splash.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/pages/userIntroMain.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/presentation/pages/track_store_main.dart';

@MaterialAutoRouter()
class $Router {
  @initial
  SplashPage splashPage;
  MyStartPage startPage;
  OnboardPage onboardPage;
  UserIntroPage userIntroPage;
  SortedHome homePage;
  AffirmationPV affirmationPageview;
  SettingsPage settingsPage;
  PlanHome planHome;
  ChoiceGoalGuide choiceGoalGuide;
  @CustomRoute(
    transitionsBuilder: TransitionsBuilders.fadeIn,
    durationInMilliseconds: 200,
  )
  GoalPage goalPage;
  SelectCover selectCover;
  @CustomRoute(
    transitionsBuilder: TransitionsBuilders.fadeIn,
    durationInMilliseconds: 200,
  )
  TaskPage taskPage;

  @CustomRoute(
    transitionsBuilder: TransitionsBuilders.fadeIn,
    durationInMilliseconds: 200,
  )
  Kanban kanbanPage;
  @CustomRoute(
    transitionsBuilder: TransitionsBuilders.fadeIn,
    durationInMilliseconds: 200,
  )
  TimelineView timelineView;
  @CustomRoute(
    transitionsBuilder: TransitionsBuilders.fadeIn,
    durationInMilliseconds: 200,
  )
  YearPlanner yearPlanner;
  @CustomRoute(
    transitionsBuilder: TransitionsBuilders.fadeIn,
    durationInMilliseconds: 200,
  )
  LongPlanner longPlanner;
  @CustomRoute(
    transitionsBuilder: TransitionsBuilders.fadeIn,
    durationInMilliseconds: 200,
  )
  NoteMain noteHub;
  @CustomRoute(
    transitionsBuilder: TransitionsBuilders.fadeIn,
    durationInMilliseconds: 200,
  )
  RecordTab recordTab;
  @CustomRoute(
    transitionsBuilder: TransitionsBuilders.fadeIn,
    durationInMilliseconds: 200,
  )
  NotesHubPage notesHubPage;
  @CustomRoute(
    transitionsBuilder: TransitionsBuilders.fadeIn,
    durationInMilliseconds: 200,
  )
  RootHome rootHome;
  @CustomRoute(
    transitionsBuilder: TransitionsBuilders.fadeIn,
    durationInMilliseconds: 200,
  )
  ChallengePageView challengePageView;

  @CustomRoute(
    transitionsBuilder: TransitionsBuilders.fadeIn,
    durationInMilliseconds: 200,
  )
  TrackStoreMain trackStoreMain;
}
