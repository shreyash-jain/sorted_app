import 'package:auto_route/auto_route.dart';
import 'package:sorted/core/services/cashfree_gateway.dart';
import 'package:sorted/features/CONNECT/presentation/pages/class/classroom_main.dart';
import 'package:sorted/features/CONNECT/presentation/pages/request_pages/class_list.dart';
import 'package:sorted/features/CONNECT/presentation/pages/class_main.dart';
import 'package:sorted/features/CONNECT/presentation/pages/request_pages/client_consultation_request_form.dart';
import 'package:sorted/features/CONNECT/presentation/pages/request_pages/package_request.dart';
import 'package:sorted/features/CONNECT/presentation/pages/request_pages/packages_list.dart';

import 'package:sorted/features/HOME/presentation/pages/affirmation_pv.dart';
import 'package:sorted/features/HOME/presentation/pages/blog_full_page.dart';
import 'package:sorted/features/HOME/presentation/pages/challenge_pv.dart';
import 'package:sorted/features/HOME/presentation/pages/fit_info_pv.dart';

import 'package:sorted/features/HOME/presentation/pages/homePage.dart';
import 'package:sorted/features/HOME/presentation/pages/recipe_full_page.dart';
import 'package:sorted/features/HOME/presentation/pages/rootPage.dart';
import 'package:sorted/features/HOME/presentation/widgets/pep_talk_player.dart';

import 'package:sorted/features/ONBOARDING/presentation/pages/onboard_page.dart';
import 'package:sorted/features/ONSTART/presentation/pages/start_page.dart';
import 'package:sorted/features/PAYMENTS/presentation/pages/test_payment.dart';

import 'package:sorted/features/SETTINGS/presentation/pages/settings_page.dart';
import 'package:sorted/features/SPLASH/splash.dart';
import 'package:sorted/features/TRACKERS/presentation/pages/track_analysis_page.dart';

import 'package:sorted/features/USER_INTRODUCTION/presentation/pages/userIntroMain.dart';

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
    AutoRoute(page: RootHome),
    AutoRoute(page: ChallengePageView),
    AutoRoute(page: VideoPage),
    AutoRoute(page: FullBlogPage),
    AutoRoute(page: RecipePage),
    AutoRoute(page: ClassListPage),
    AutoRoute(page: TestPayment),
    AutoRoute(page: ClassMain),
    AutoRoute(page: CashFreeTest),
    AutoRoute(page: ExpertPackageRequestPage),
    AutoRoute(page: ExpertPackagesCatalogue),
    AutoRoute(page: ClientRequestForm),
    AutoRoute(page: ClassroomMain),
    AutoRoute(page: PepTalkPlayer),
    AutoRoute(page: FitInfoPV),
    AutoRoute(page: PerformanceAnalysisPage),
  ],
)
class $ARouter {}
