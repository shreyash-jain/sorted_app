import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:googleapis/calendar/v3.dart';
import 'package:meta/meta.dart';
import 'package:sorted/core/authentication/GoogleHttpClient.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sorted/core/global/database/cacheDataClass.dart';
import 'package:sorted/core/global/injection_container.dart';

import 'package:sorted/core/global/models/user_details.dart';

abstract class AuthCloudDataSource {
  void getEvent(dynamic headers);

  void makeSingleSignOut(User user);
  Future<void> signOutLocally(User user);
  Future<void> signOutLocalDuplicate(User user);
  Future<bool> checkIfUserAlreadyPresent(User user);
  Future<bool> getSignInState(User user);
  Future<void> updateUserData(User user, bool oldState);
  Future<void> makeSingleSignIn(User user);
  Future<void> updateLastScene(User user);
  void addUserInCloud(User user);
  void updateUserInCloud(UserDetail detail);
  Future<UserDetail> getUserFromCloud();
  Future<void> addUserDetailInCloud(UserDetail detail);
  Future<void> saveDeviceToken();
}

class AuthCloudDataSourceImpl implements AuthCloudDataSource {
  int deviceId = 0;
  String deviceName = "";
  final FirebaseFirestore cloudDb;
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
    // DateTime lastMonth =
    //     Utils.lastDayOfMonth(DateTime.now().subtract(Duration(days: 1)));
    // DateTime firstMonth =
    //     Utils.firstDayOfMonth(DateTime.now().add(Duration(days: 1)));
    // var calEvents = calendar.events.list("primary",
    //     timeMax: lastMonth.toUtc(), timeMin: firstMonth.toUtc());
    // calEvents.then((events) => {
    //       print(events.items.length),
    //       events.items.forEach((event) => print("EVENT $event"))
    //     });
  }

  Future<bool> checkIfUserAlreadyPresent(User user) async {
    // var document = await _db.collection('users').document(user.uid).collection("user_data").document("data");

    bool ans;
    print(user.uid);
    final snapShot = await cloudDb
        .collection('users')
        .doc(user.uid)
        .collection("user_data")
        .doc('data')
        .get();

    if (snapShot == null || !snapShot.exists) {
      ans = false;
    } else {
      ans = true;
    }
    return ans;
  }

  Future<bool> getSignInState(User user) async {
    // true for loggedIn
    // var document = await _db.collection('users').document(user.uid).collection("user_data").document("data");
    DocumentReference document = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection("user_data")
        .doc("data");

    bool ans;

    await document.get().then((value) {
      print((value.data() as Map).containsKey("signInId").toString());
      print((value.data() as Map)['signInId']);
      if ((value.data() as Map)['signInId'] != 0)
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

  Future<void> saveDeviceToken() async {
    print("token " + saveDeviceToken.toString());
    User user = auth.currentUser;
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;

    // Get the token for this device
    String fcmToken = await _fcm.getToken();
    print("token " + fcmToken.toString());

    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = cloudDb
          .collection('users')
          .doc(user.uid)
          .collection("user_data")
          .doc("data")
          .collection('private')
          .doc('token');

      tokens.set({
        'token': FieldValue.arrayUnion([fcmToken]),
        'createdAt': FieldValue.serverTimestamp(), // optional
      }, SetOptions(merge: true));
    }
  }

  Future<void> updateUserData(User user, bool oldState) async {
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection("user_data")
        .doc("data");

    ref.set({'uid': user.uid}, SetOptions(merge: true));
    ref.set({'email': user.email}, SetOptions(merge: true));
    ref.set({'photoURL': user.photoURL}, SetOptions(merge: true));
    ref.set({'displayName': user.displayName}, SetOptions(merge: true));

    prefs.setBool("old_user", oldState);
    print("signed in " + user.displayName);
    prefs.setString("google_image", user.photoURL);
    prefs.setString("google_name", user.displayName);
    prefs.setString("google_email", user.email);

    prefs.setString('user_image', "assets/images/male1.png");
    print(updateUserData.toString() + "    >>>>   " + deviceId.toString());

    UserDetail userDetail = new UserDetail(
        name: user.displayName,
        email: user.email,
        imageUrl: user.photoURL,
        currentDevice: deviceName,
        currentDeviceId: deviceId);
    print(2);

    sl<CacheDataClass>().setUserDetail(userDetail);
    sl<CacheDataClass>().setOldState(oldState);
  }

  Future<void> makeSingleSignIn(User user) async {
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection("user_data")
        .doc("data");
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print('Running on ${androidInfo.model}');

      deviceName = androidInfo.model;
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print('Running on ${iosInfo.utsname.machine}'); //
      deviceName = iosInfo.utsname.machine;
    }
    deviceId = next(1, 4294967290);
    try {
      await ref.set({
        'signInId': deviceId,
        'deviceName': deviceName,
      }, SetOptions(merge: true));

      await prefs.setInt('signInId', deviceId);
    } catch (error) {
      print(
          "hello is there"); // executed for errors of all types other than Exception
    }
  }

  void makeSingleSignOut(User user) async {
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection("user_data")
        .doc("data");

    try {
      ref.set({
        'signInId': 0,
      }, SetOptions(merge: true));

      await prefs.remove('onboard');
      await prefs.remove('signInId');
      await prefs.remove('LoggedIn');
    } catch (error) {
      print(
          "hello is there"); // executed for errors of all types other than Exception
    }
  }

  Future<void> signOutLocally(User user) async {
    makeSingleSignOut(user);

    await prefs.remove('onboard');
    await prefs.remove('signInId');
    await prefs.remove('LoggedIn');
  }

  Future<void> signOutLocalDuplicate(User user) async {
    await prefs.remove('onboard');
    await prefs.remove('signInId');
    await prefs.remove('LoggedIn');
  }

  @override
  Future<void> updateLastScene(User user) async {
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection("user_data")
        .doc("data");
    ref.update({'lastSeen': DateTime.now()});
  }

  @override
  void addUserInCloud(User user) {
    UserDetail newUser = new UserDetail();
    newUser = newUser.copyWith(
        email: user.email, name: user.displayName, imageUrl: user.photoURL);

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection("user_data")
        .doc("data");
    ref.set(newUser.toMap());
    return;
  }

  @override
  Future<void> addUserDetailInCloud(UserDetail detail) async {
    User user = auth.currentUser;
    print(addUserDetailInCloud);
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection("user_data")
        .doc("details");
    ref.set(detail.toMap());
    return;
  }

  @override
  Future<void> updateUserInCloud(UserDetail detail) async {
    User user = auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection("user_data")
        .doc("details");
    ref.update(detail.toMap());
    return;
  }

  @override
  Future<UserDetail> getUserFromCloud() async {
    User user = auth.currentUser;
    UserDetail thisUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection("user_data")
        .doc("details");
    DocumentSnapshot this_snapshot = await ref.get();
    if (this_snapshot.data != null)
      thisUser = UserDetail.fromSnapshot(await ref.get());
    else
      thisUser = sl<CacheDataClass>().getUserDetail();
    return thisUser;
  }
}
