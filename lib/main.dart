import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'package:sorted/core/authentication/bloc/authentication_bloc.dart';
import 'package:sorted/core/authentication/remote_auth_repository.dart';
import 'package:sorted/core/global/bloc_observer.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/database/shared_pref_helper.dart';
import 'package:sorted/core/global/injection_container.dart' as di;
import 'package:sorted/core/routes/router.gr.dart' as rt;
import 'package:sorted/core/routes/router.gr.dart';
import 'package:sorted/core/services/dynamic_link_service.dart';
import 'package:sorted/core/theme/app_theme_wrapper.dart';
import 'package:sorted/core/notification/push_notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sorted/core/theme/theme.dart';
import 'package:sorted/features/USER_INTRODUCTION/data/repositories/user_intro_repository_impl.dart';
import 'package:sorted/features/USER_INTRODUCTION/domain/repositories/user_intro_repository.dart';
import 'package:uni_links/uni_links.dart';
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
      'sortit_importance_channel', // id
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
  sl<DynamicLinkService>().handleDynamicLinks();
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
        child: GetMaterialApp(home: MyApp()),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

enum UniLinksType { string, uri }

class _MyAppState extends State<MyApp> {
  ThemeData _theme = appThemeLight;
  String _latestLink = 'Unknown';
  Uri _latestUri;

  StreamSubscription _sub;
  UniLinksType _type = UniLinksType.string;

  @override
  void initState() {
    super.initState();
    initUniLinks();
    setupInteractedMessage();
  }

  @override
  dispose() {
    if (_sub != null) _sub.cancel();

    super.dispose();
  }

  Future<void> initUniLinks() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    _sub = uriLinkStream.listen((Uri uri) {
      // Use the uri and warn the user, if it is not correct
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
    });
    Uri initialUri;
    String initialLink;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      initialUri = await getInitialUri();
      print('initial uri: ${initialUri?.path}'
          ' ${initialUri?.queryParametersAll}');
      initialLink = initialUri?.toString();
    } on PlatformException {
      initialUri = null;
      initialLink = 'Failed to get initial uri.';
    } on FormatException {
      initialUri = null;
      initialLink = 'Bad parse the initial link as Uri.';
    }
  }

  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp.router(
      theme: ThemeData.dark(),
      routerDelegate: AutoRouterDelegate(
        sl<ARouter>(),
        navigatorObservers: () => [AutoRouteObserver()],
      ),
      routeInformationParser: sl<ARouter>().defaultRouteParser(),
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
              child: child),
        );
      },
    );
  }

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      // Navigator.pushNamed(context, '/message',
      //     arguments: MessageArguments(message, true));
    });

    // Also handle any interaction when the app is in the background via a
    // Stream listener
  }

  void _handleMessage(RemoteMessage message) {
    print("Message aaya  " + message.data.toString());
    if (message.data['type'] == 'chat') {
      // Navigator.pushNamed(
      //   context,
      //   '/chat',
      //   arguments: ChatArguments(message),
      // );
    }
  }
}

Future onDidReceiveLocalNotification(
    int id, String title, String body, String payload) {}

Future selectNotification(String payload) {}
