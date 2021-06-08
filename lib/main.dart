import 'package:auto_route/auto_route.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/authentication/bloc/authentication_bloc.dart';
import 'package:sorted/core/authentication/remote_auth_repository.dart';
import 'package:sorted/core/global/bloc_observer.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/database/shared_pref_helper.dart';
import 'package:sorted/core/global/injection_container.dart' as di;
import 'package:sorted/core/routes/router.gr.dart' as rt;
import 'package:sorted/core/routes/router.gr.dart';
import 'package:sorted/core/theme/app_theme_wrapper.dart';
import 'package:sorted/core/notification/push_notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sorted/core/theme/theme.dart';
import 'package:sorted/features/USER_INTRODUCTION/data/repositories/user_intro_repository_impl.dart';
import 'package:sorted/features/USER_INTRODUCTION/domain/repositories/user_intro_repository.dart';
import 'core/global/injection_container.dart';
import 'package:flutter/foundation.dart';

/// Define a top-level named handler which background/terminated messages will
/// call.
///
/// To verify things are working, check out the native platform logs.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void notificationInit() async {
  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  final pushNotificationService =
      PushNotificationService(FirebaseMessaging.instance);
  pushNotificationService.initialise();
  notificationInit();

  EquatableConfig.stringify = kDebugMode;

  var initializationSettingsAndroid = AndroidInitializationSettings('logo');
  var initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: selectNotification);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

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

final _appRouter = ARouter();

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
    return MaterialApp.router(
      theme: ThemeData.dark(),
      routerDelegate: AutoRouterDelegate(
        _appRouter,
        navigatorObservers: () => [AutoRouteObserver()],
      ),
      routeInformationParser: _appRouter.defaultRouteParser(),
      debugShowCheckedModeBanner: false,
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
        if (Gparam.height < 670) Gparam.isHeightBig = false;
        if (Gparam.width < 400) Gparam.isWidthBig = false;
        print(Gparam.width);
        return new AppTheme(
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child
          ),
        );
      },
    );
  }
}
class MyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: RaisedButton(
          child: Text("Foo"),
          onPressed: () => Navigator.pushNamed(context, "/"),
        ),
      );
  }
}
Future onDidReceiveLocalNotification(
    int id, String title, String body, String payload) {}

Future selectNotification(String payload) {}
