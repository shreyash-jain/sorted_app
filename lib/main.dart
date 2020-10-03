import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/authentication/bloc/authentication_bloc.dart';
import 'package:sorted/core/authentication/remote_auth_repository.dart';
import 'package:sorted/core/global/bloc_observer.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/database/shared_pref_helper.dart';
import 'package:sorted/core/global/injection_container.dart' as di;
import 'package:sorted/core/routes/router.gr.dart';
import 'package:sorted/core/theme/app_theme_wrapper.dart';

import 'package:sorted/core/theme/theme.dart';
import 'package:sorted/features/USER_INTRODUCTION/data/repositories/user_intro_repository_impl.dart';
import 'package:sorted/features/USER_INTRODUCTION/domain/repositories/user_intro_repository.dart';
import 'core/global/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  EquatableConfig.stringify = kDebugMode;
  await di.init();
  Bloc.observer = SimpleBlocObserver();
  runApp(App(
      authenticationRepository: sl<AuthenticationRepository>(),
      userIntroRepository: sl<UserIntroductionRepository>()));
}

class App extends StatelessWidget {
  const App({
    Key key,
    @required this.authenticationRepository,
    @required this.userIntroRepository,
  })  : assert(authenticationRepository != null),
        super(key: key);

  final AuthenticationRepository authenticationRepository;
  final UserIntroductionRepository userIntroRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
            authenticationRepository: authenticationRepository,
            userIntroRepository: userIntroRepository),
        child: MyApp(),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeData _theme = appThemeLight;

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      navigatorKey: Router.navigator.key,
      onGenerateRoute: Router.onGenerateRoute,
      builder: (context, child) {
        print("My App");
        Gparam.height = MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top;
        print(Gparam.height);
        Gparam.width = MediaQuery.of(context).size.width;
        Gparam.topPadding = Gparam.height / 20;
        Gparam.heightPadding = Gparam.topPadding / 2.3;
        Gparam.ratio = Gparam.height / Gparam.width;
        Gparam.widthPadding = Gparam.width / 16;
        if (Gparam.height < 650) Gparam.isHeightBig = false;
        if (Gparam.width < 400) Gparam.isWidthBig = false;
        print(Gparam.width);
        return new AppTheme(
            child: MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: BlocListener<AuthenticationBloc, AuthenticationState>(
                  listener: (context, state) {
                    print(state);
                    switch (state.status) {
                      case AuthenticationStatus.authenticated:
                        print("authenticated");
                        Router.navigator.pop();
                        Router.navigator.pushNamed(Router.startPage,
                            arguments:
                                MyStartPageArguments(title: "start Page"));
                        break;
                      case AuthenticationStatus.unauthenticated:
                        // todo: send to onboarding page
                        print("un-authenticated");

                        Router.navigator.pop();
                        Router.navigator.pushNamed(Router.onboardPage,
                            arguments:
                                OnboardPageArguments(title: "Onboard Page"));

                        // _navigator.pushAndRemoveUntil<void>(
                        //   LoginPage.route(),
                        //   (route) => false,
                        // );
                        print("send to onboarding");
                        break;
                      default:
                        break;
                    }
                  },
                  child: child,
                )));
      },
    );
  }
}
