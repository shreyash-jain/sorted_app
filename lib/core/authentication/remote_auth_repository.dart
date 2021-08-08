import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/authentication/auth_cloud_data_source.dart';
import 'package:sorted/core/error/exceptions.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sorted/core/global/models/auth_user.dart';
import 'dart:async';
import 'package:meta/meta.dart';

class AuthenticationRepository {
  // Dependencies

  AuthenticationRepository(
      {FirebaseAuth firebaseAuth, AuthCloudDataSource authDataSource})
      : _firebaseAuth = firebaseAuth ?? sl.get<FirebaseAuth>(),
        _authDataSource = authDataSource;

  final FirebaseAuth _firebaseAuth;
  final AuthCloudDataSource _authDataSource;
  // Shared State for Widgets
  //Observable<FirebaseUser> user;

  Stream<String> url;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/calendar.events.readonly',
    ],
  );

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.empty] if the user is not authenticated.
  Stream<NativeUser> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      if (firebaseUser == null)
        return NativeUser.empty;
      else {
        return NativeUser(
            id: firebaseUser.uid,
            email: firebaseUser.email,
            name: firebaseUser.displayName,
            photo: firebaseUser.photoURL);
      }
    });
  }

  // firebase user
  // custom user data in Firestore

  // constructor

  Future<void> signUp({
    @required String email,
    @required String password,
  }) async {
    assert(email != null && password != null);
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on Exception {
      throw SignUpFailure();
    }
  }

  /// Starts the Sign In with Google Flow.
  ///
  /// Throws a [LogInWithEmailAndPasswordFailure] if an exception occurs.
  Future<void> logInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final authResult = await _firebaseAuth.signInWithCredential(credential);

      final User user = authResult.user;

      //final headers = await _googleSignIn.currentUser.authHeaders;
      //_authDataSource.getEvent(headers);
      bool oldUser = await _authDataSource.checkIfUserAlreadyPresent(user);
      print("old_user " + oldUser.toString());
      if (!oldUser) {
        await _authDataSource.makeSingleSignIn(user);
      } else {
        bool isLoggedIn = await _authDataSource.getSignInState(user);
        print(isLoggedIn.toString() + " logged in ?");
        if (isLoggedIn) {
          print("already signed in");
        } else {
          print("yaha bhi koi aata");
        }
        // TODO : Check if this fails

      }
      await _authDataSource.updateUserData(user, oldUser);
    } on Exception {
      throw LogInWithGoogleFailure();
    }
  }

  Future<int> saveDeviceToken() {
    print(saveDeviceToken);
    try {
      _authDataSource.saveDeviceToken();
      return Future.value(1);
    } on Exception {
      throw ServerException();
    }
  }

  /// Signs in with the provided [email] and [password].
  ///
  /// Throws a [LogInWithEmailAndPasswordFailure] if an exception occurs.
  Future<void> logInWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    assert(email != null && password != null);
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on Exception {
      throw LogInWithEmailAndPasswordFailure();
    }
  }

  Future<Either<Failure, User>> currentUser() async {
    User user = _firebaseAuth.currentUser;
    if (user != null) {
      return Right(user);
    } else {
      return Left(NoUserFailure());
    }
  }

  /// Signs out the current user which will emit
  /// [User.empty] from the [user] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  Future<void> logOut(User user) async {
    try {
      _authDataSource.makeSingleSignOut(user);
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } on Exception {
      throw LogOutFailure();
    }
  }
}
