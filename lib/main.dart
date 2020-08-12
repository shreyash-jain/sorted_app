import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/authentication/bloc/authentication_bloc.dart';
import 'package:sorted/core/authentication/remote_auth_repository.dart';
import 'package:sorted/core/database/global/shared_pref_helper.dart';
import 'package:sorted/core/global/bloc_observer.dart';
import 'package:sorted/core/global/injection_container.dart' as di;
import 'package:sorted/core/routes/router.gr.dart';

import 'package:sorted/core/theme/theme.dart';
import 'package:sorted/features/ONSTART/presentation/pages/start_page.dart';

import 'core/global/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EquatableConfig.stringify = kDebugMode;
  await di.init();
  Bloc.observer = SimpleBlocObserver();
  runApp(App(authenticationRepository: sl<AuthenticationRepository>()));
}

class App extends StatelessWidget {
  const App({
    Key key,
    @required this.authenticationRepository,
  })  : assert(authenticationRepository != null),
        super(key: key);

  final AuthenticationRepository authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
        ),
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
  ThemeData theme = appThemeLight;
  final _navigatorKey = GlobalKey<NavigatorState>();

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme,
      navigatorKey: Router.navigatorKey,
      onGenerateRoute: Router.onGenerateRoute,
      builder: (context, child) {
        print("My App");
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                print("authenticated");
                Router.navigator.pushNamed(Router.startPage,
                    arguments: MyStartPageArguments(title: "Start Page"));
                break;
              case AuthenticationStatus.unauthenticated:
                // todo: send to onboarding page
                print("un-authenticated");
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
        );
      },
    );
  }

  setTheme(Brightness brightness) {
    if (brightness == Brightness.dark) {
      setState(() {
        theme = appThemeDark;
      });
    } else {
      setState(() {
        theme = appThemeLight;
      });
    }
  }

  void updateThemeFromSharedPref() async {
    String themeText =
        await di.sl.get<SharedPrefHelper>().getThemeFromSharedPref();
    if (themeText == 'light') {
      setTheme(Brightness.light);
    } else {
      setTheme(Brightness.dark);
    }
  }
}
