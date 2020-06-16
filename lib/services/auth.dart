import 'dart:io';
import 'dart:math';

import 'package:date_utils/date_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:notes/data/activity.dart';
import 'package:notes/data/eCat.dart';
import 'package:notes/data/notebook.dart';
import 'package:notes/data/question.dart';
import 'package:notes/data/user_activity.dart';
import 'package:notes/services/GoogleHttpClient.dart';
import 'package:notes/services/database.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info/device_info.dart';
class AuthService {
  // Dependencies
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/calendar.events.readonly',
  ],);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  SharedPreferences  prefs ;
  // Shared State for Widgets
  Observable<FirebaseUser> user;
  Observable<String> url;
  final _random = new Random();



  // firebase user
  Observable<Map<String, dynamic>> profile; // custom user data in Firestore
  PublishSubject loading = PublishSubject();


  // constructor
  AuthService() {
    user = Observable(_auth.onAuthStateChanged);



    profile = user.switchMap((FirebaseUser u) {
      if (u != null) {
        return _db
            .collection('users')
            .document(u.uid)
            .snapshots()
            .map((snap) => snap.data);
      } else {
        return Observable.just({});
      }
    });

  }

  Future<FirebaseUser> googleSignIn() async {

    loading.add(true);

    // Step 1

    prefs = await SharedPreferences.getInstance();
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();


    // Step 2
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );


    final AuthResult authResult  = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    final headers = await _googleSignIn.currentUser.authHeaders;
    getEvent(headers);

    // Step 3
    bool old_user=await checkIfUserAlreadyPresent(user);
    print ("old_user "+old_user.toString());
    if (!old_user){
      await makeSingleSignIn(user);

    }

    else {
      bool isLoggedIn=await getSignInState(user);
      print(isLoggedIn.toString()+" logged in ?");
      if (isLoggedIn) {
        print("already signed in");
        await prefs.setInt("signInId",0);

        await prefs.setBool("LoggedIn", true);



      }
      else {
        await prefs.setBool("LoggedIn", false);
        await makeSingleSignIn(user);
        print("yaha bhi koi aata");
      }


    }

    updateUserData(user);



    await AddBasics();
    // Done
    loading.add(false);
    prefs.setBool("old_user", old_user);
    print("signed in " + user.displayName);
    prefs.setString("google_image", user.photoUrl);
    prefs.setString("google_name", user.displayName);
    prefs.setString("google_email", user.email);

    prefs.setString('user_image', "assets/images/male1.png");


    return user;
  }
  getEvent(headers) async {
    print("check kaona");
    final httpClient = GoogleHttpClient(headers);
    var calendar = CalendarApi(httpClient);
    DateTime lastMonth = Utils.lastDayOfMonth(DateTime.now().subtract(Duration(days: 1)));
    DateTime firstMonth = Utils.firstDayOfMonth(DateTime.now().add(Duration(days: 1)));
    var calEvents = calendar.events.list("primary", timeMax: lastMonth.toUtc(), timeMin: firstMonth.toUtc());
    calEvents.then(
            (events) => {

              print(events.items.length),
              events.items.forEach((event) => print("EVENT ${event}"))});
  }
  Future<bool> checkIfUserAlreadyPresent(FirebaseUser user) async {
    // var document = await _db.collection('users').document(user.uid).collection("user_data").document("data");

    bool ans;
    print(user.uid);
    final snapShot= await _db.collection('users').document(user.uid).collection("user_data").document('data')
        .get();

    if (snapShot == null || !snapShot.exists) {
      ans=false;
    }
    else {

      ans =true;
    }
    return ans;

  }
  Future<bool> getSignInState(FirebaseUser user) async { // true for loggedIn
    // var document = await _db.collection('users').document(user.uid).collection("user_data").document("data");
    DocumentReference document =  _db.collection('users').document(user.uid).collection("user_data").document("data");
    int prefId=prefs.getInt('signInId');
    bool ans;


    await document.get().then((value) {
      print(value.data.containsKey("signInId").toString());
      print(value.data['signInId']);
      if (value.data['signInId']!=0)ans =true;
      else ans=false;
      return (ans);

    });
    return ans;

  }
setOnboard() async {
  await prefs.setBool('onboard', false);

}

  void updateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid).collection("user_data").document("data");

    ref.setData({'uid':user.uid},merge: true);
    ref.setData({'email':user.email},merge: true);
    ref.setData({'photoURL':user.photoUrl},merge: true);
    ref.setData({'displayName': user.displayName},merge: true);




  }
  int next(int min, int max) => min + _random.nextInt(max - min);
  Future<void> makeSingleSignIn(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid).collection("user_data").document("data");
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceName="";
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print('Running on ${androidInfo.model}');

      deviceName=androidInfo.model;
    }

    else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print('Running on ${iosInfo.utsname.machine}');  //
      deviceName=iosInfo.utsname.machine;    }
    int deviceId=next(1,4294967290);
    try {
      await ref.setData({
        'signInId': deviceId,
        'deviceName': deviceName,

      }, merge: false);

      await prefs.setInt('signInId', deviceId);
    }


    catch (error) {
      print("hello is there");// executed for errors of all types other than Exception
    }
  }
  void makeSingleSignOut(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid).collection("user_data").document("data");

    try {
      ref.setData({
        'signInId': 0,

      }, merge: true);
    }

    catch (error) {
      print("hello is there");// executed for errors of all types other than Exception
    }
  }


  Future<void> signOut(FirebaseUser user) async {

    _auth.signOut();
    makeSingleSignOut(user);
    prefs = await SharedPreferences.getInstance();
    await prefs.remove('onboard');
    await prefs.remove('signInId');
    await prefs.remove('LoggedIn');
  }
  Future<void> signOutDuplicate(FirebaseUser user) async {

    _auth.signOut();

    prefs = await SharedPreferences.getInstance();
    await prefs.remove('onboard');
    await prefs.remove('signInId');
    await prefs.remove('LoggedIn');
  }

  AddBasics() async {

    bool firstmain = prefs.getBool('first_main');
    var notebooks=await NotesDatabaseService.db.getNotebookFromDB();
    List<NoteBookModel> check=notebooks;

    if (!firstmain && check.length==0){


      prefs.setBool('first_main', true);


    }
  }

}

final AuthService authService = AuthService();