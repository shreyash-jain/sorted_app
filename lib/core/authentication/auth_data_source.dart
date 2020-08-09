import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_utils/date_utils.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:googleapis/calendar/v3.dart';
import 'package:meta/meta.dart';
import 'package:sorted/core/authentication/GoogleHttpClient.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sorted/core/error/exceptions.dart';

abstract class AuthCloudDataSource {
  void getEvent(dynamic headers);

  void makeSingleSignOut(FirebaseUser user);
  Future<void> signOutLocally(FirebaseUser user);
  Future<void> signOutLocalDuplicate(FirebaseUser user);
  Future<bool> checkIfUserAlreadyPresent(FirebaseUser user);
  Future<bool> getSignInState(FirebaseUser user);
  void updateUserData(FirebaseUser user);
  Future<void> makeSingleSignIn(FirebaseUser user);
}

class AuthCloudDataSourceImpl implements AuthCloudDataSource {
  final Firestore cloudDb;
  final FirebaseAuth auth;
  final SharedPreferences prefs;
  
  final _random = new Random();
  AuthCloudDataSourceImpl(
      {@required this.cloudDb, @required this.auth, @required this.prefs});
  int next(int min, int max) => min + _random.nextInt(max - min);

  getEvent(headers) async {
    print("check kaona");
    final httpClient = GoogleHttpClient(headers);
    var calendar = CalendarApi(httpClient);
    DateTime lastMonth =
        Utils.lastDayOfMonth(DateTime.now().subtract(Duration(days: 1)));
    DateTime firstMonth =
        Utils.firstDayOfMonth(DateTime.now().add(Duration(days: 1)));
    var calEvents = calendar.events.list("primary",
        timeMax: lastMonth.toUtc(), timeMin: firstMonth.toUtc());
    calEvents.then((events) => {
          print(events.items.length),
          events.items.forEach((event) => print("EVENT $event"))
        });
  }

  Future<bool> checkIfUserAlreadyPresent(FirebaseUser user) async {
    // var document = await _db.collection('users').document(user.uid).collection("user_data").document("data");

    bool ans;
    print(user.uid);
    final snapShot = await cloudDb
        .collection('users')
        .document(user.uid)
        .collection("user_data")
        .document('data')
        .get();

    if (snapShot == null || !snapShot.exists) {
      ans = false;
    } else {
      ans = true;
    }
    return ans;
  }

  Future<bool> getSignInState(FirebaseUser user) async {
    // true for loggedIn
    // var document = await _db.collection('users').document(user.uid).collection("user_data").document("data");
    DocumentReference document = cloudDb
        .collection('users')
        .document(user.uid)
        .collection("user_data")
        .document("data");
    
    bool ans;

    await document.get().then((value) {
      print(value.data.containsKey("signInId").toString());
      print(value.data['signInId']);
      if (value.data['signInId'] != 0)
        ans = true;
      else
        ans = false;
      return (ans);
    });
    if (ans) {
      await prefs.setInt("signInId", 0);

      await prefs.setBool("LoggedIn", true);
    } else {
      await prefs.setBool("LoggedIn", false);
      await makeSingleSignIn(user);
    }
    return ans;
  }

  setOnboard() async {
    await prefs.setBool('onboard', false);
  }

  void updateUserData(FirebaseUser user) async {
    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection("user_data")
        .document("data");

    ref.setData({'uid': user.uid}, merge: true);
    ref.setData({'email': user.email}, merge: true);
    ref.setData({'photoURL': user.photoUrl}, merge: true);
    ref.setData({'displayName': user.displayName}, merge: true);

    prefs.setBool("old_user", await checkIfUserAlreadyPresent(user));
    print("signed in " + user.displayName);
    prefs.setString("google_image", user.photoUrl);
    prefs.setString("google_name", user.displayName);
    prefs.setString("google_email", user.email);

    prefs.setString('user_image', "assets/images/male1.png");
  }

  Future<void> makeSingleSignIn(FirebaseUser user) async {
    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection("user_data")
        .document("data");
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceName = "";
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print('Running on ${androidInfo.model}');

      deviceName = androidInfo.model;
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print('Running on ${iosInfo.utsname.machine}'); //
      deviceName = iosInfo.utsname.machine;
    }
    int deviceId = next(1, 4294967290);
    try {
      await ref.setData({
        'signInId': deviceId,
        'deviceName': deviceName,
      }, merge: false);

      await prefs.setInt('signInId', deviceId);
    } catch (error) {
      print(
          "hello is there"); // executed for errors of all types other than Exception
    }
  }

  void makeSingleSignOut(FirebaseUser user) async {
    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection("user_data")
        .document("data");

    try {
      ref.setData({
        'signInId': 0,
      }, merge: true);

      await prefs.remove('onboard');
      await prefs.remove('signInId');
      await prefs.remove('LoggedIn');
    } catch (error) {
      print(
          "hello is there"); // executed for errors of all types other than Exception
    }
  }

  Future<void> signOutLocally(FirebaseUser user) async {
    makeSingleSignOut(user);

    await prefs.remove('onboard');
    await prefs.remove('signInId');
    await prefs.remove('LoggedIn');
  }

  Future<void> signOutLocalDuplicate(FirebaseUser user) async {
    await prefs.remove('onboard');
    await prefs.remove('signInId');
    await prefs.remove('LoggedIn');
  }
}