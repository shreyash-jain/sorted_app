import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Dependencies
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  SharedPreferences  prefs ;
  // Shared State for Widgets
  Observable<FirebaseUser> user;
  Observable<String> url;



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

    // Step 3
    updateUserData(user);

    // Done
    loading.add(false);
    print("signed in " + user.displayName);
    prefs.setString("google_image", user.photoUrl);
    prefs.setString("google_name", user.displayName);
    prefs.setString("google_email", user.email);

    return user;
  }

  void updateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid).collection("user_data").document("data");

    try {
      ref.setData({
        'uid': user.uid,
        'email': user.email,
        'photoURL': user.photoUrl,
        'displayName': user.displayName,
        'lastSeen': DateTime.now()
      }, merge: true);
    }

    catch (error) {
    print("hello is there");// executed for errors of all types other than Exception
  }
  }


  void signOut() {

    _auth.signOut();
  }
}

final AuthService authService = AuthService();