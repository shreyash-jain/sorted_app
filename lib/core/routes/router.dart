import 'package:auto_route/auto_route.dart';
import 'package:sorted/core/services/cashfree_gateway.dart';
import 'package:sorted/features/CONNECT/presentation/pages/class_list.dart';
import 'package:sorted/features/CONNECT/presentation/pages/class_main.dart';

import 'package:sorted/features/FILES/presentation/pages/notes_hub.dart';
import 'package:sorted/features/FILES/presentation/pages/record_home.dart';
import 'package:sorted/features/FILES/presentation/pages/record_page_loaded.dart';
import 'package:sorted/features/FILES/presentation/pages/test_note.dart';
import 'package:sorted/features/HOME/presentation/pages/activity_planner.dart';
import 'package:sorted/features/HOME/presentation/pages/affirmation_pv.dart';
import 'package:sorted/features/HOME/presentation/pages/blog_full_page.dart';
import 'package:sorted/features/HOME/presentation/pages/challenge_pv.dart';
import 'package:sorted/features/HOME/presentation/pages/diet_palnner.dart';
import 'package:sorted/features/HOME/presentation/pages/homePage.dart';
import 'package:sorted/features/HOME/presentation/pages/recipe_full_page.dart';
import 'package:sorted/features/HOME/presentation/pages/rootPage.dart';

import 'package:sorted/features/ONBOARDING/presentation/pages/onboard_page.dart';
import 'package:sorted/features/ONSTART/presentation/pages/start_page.dart';
import 'package:sorted/features/PAYMENTS/presentation/pages/test_payment.dart';
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
import 'package:sorted/features/TRACKERS/TRACK_STORE/presentation/pages/about_track_page.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/pages/userIntroMain.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/presentation/pages/track_store_main.dart';
import 'package:sorted/features/VIDEO_APP/presentation/pages/video_page.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: SplashPage, initial: true),
    AutoRoute(page: MyStartPage),
    AutoRoute(page: OnboardPage),
    AutoRoute(page: UserIntroPage),
    AutoRoute(page: SortedHome),
    AutoRoute(page: AffirmationPV),
    AutoRoute(page: SettingsPage),
    AutoRoute(page: PlanHome),
    AutoRoute(page: ChoiceGoalGuide),
    AutoRoute(page: GoalPage),
    AutoRoute(page: ChoiceGoalGuide),
    AutoRoute(page: SelectCover),
    AutoRoute(page: TaskPage),
    AutoRoute(page: Kanban),
    AutoRoute(page: TimelineView),
    AutoRoute(page: YearPlanner),
    AutoRoute(page: LongPlanner),
    AutoRoute(page: NoteMain),
    AutoRoute(page: RecordTab),
    AutoRoute(page: NotesHubPage),
    AutoRoute(page: RootHome),
    AutoRoute(page: ChallengePageView),
    AutoRoute(page: TrackStoreMain),
    AutoRoute(page: VideoPage),
    AutoRoute(page: FullBlogPage),
    AutoRoute(page: ActivityPlanner),
    AutoRoute(page: DietPlanner),
    AutoRoute(page: RecipePage),
    AutoRoute(page: AboutTrackPage),
    AutoRoute(page: ClassListPage),
    AutoRoute(page: TestPayment),
    AutoRoute(page: ClassMain),
    AutoRoute(page: CashFreeTest),
  ],
)
class $ARouter {}
