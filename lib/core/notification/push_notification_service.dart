import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm;

  PushNotificationService(this._fcm);

  Future initialise() async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    // If you want to test the push notification locally,
    // you need to get the token and input to the Firebase console
    // https://console.firebase.google.com/project/YOUR_PROJECT_ID/notification/compose
    String token = await _fcm.getToken();
    print("FirebaseMessaging token: $token");

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  var androidNotificationDetails = AndroidNotificationDetails(
    '0',
    '0',
    '0',
    importance: Importance.high,
    priority: Priority.high,
  );
  var iosNotificationDetails = IOSNotificationDetails();
  var notificationDetails = NotificationDetails(
      android: androidNotificationDetails, iOS: iosNotificationDetails);
  var localNotification = FlutterLocalNotificationsPlugin();
  await localNotification.show(
      0, 'title local', 'description local', notificationDetails);
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}
