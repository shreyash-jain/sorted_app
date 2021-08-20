import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/database/cacheDataClass.dart';
import 'package:sorted/core/global/database/sqflite_init.dart';
import 'package:sorted/core/global/entities/day_at_sortit.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/authentication/auth_cloud_data_source.dart';
import 'package:sorted/core/error/exceptions.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sorted/core/global/models/auth_user.dart';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:sorted/core/network/network_info.dart';

class AuthenticationRepository {
  // Dependencies

  AuthenticationRepository(
      {this.networkInfo,
      FirebaseAuth firebaseAuth,
      AuthCloudDataSource authDataSource})
      : _firebaseAuth = firebaseAuth ?? sl.get<FirebaseAuth>(),
        _authDataSource = authDataSource;

  final FirebaseAuth _firebaseAuth;
  final AuthCloudDataSource _authDataSource;
  final NetworkInfo networkInfo;
  // Shared State for Widgets
  //Observable<FirebaseUser> user;

  Stream<String> url;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
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
  Future<Either<Failure, int>> logInWithGoogle() async {
    Failure failure;
    if (_firebaseAuth != null && _firebaseAuth.currentUser != null) {
      await logOut();
    }
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
      return (Right(1));
    } on Exception catch (e) {
      failure = LogInWithGoogleFailure();

      return (Left(failure));
    }
  }

  Future<int> saveDeviceToken(String token) async {
    print(saveDeviceToken);

    var userId = await _firebaseAuth.currentUser.getIdToken();

    try {
      _authDataSource.saveDeviceToken(token);
      return Future.value(1);
    } on Exception {
      throw ServerException();
    }
  }

  Future<DayAtSortit> getDayAtSortit() async {
    if (await networkInfo.isConnected) {
      try {
        return (await _authDataSource.getDayAtSortIt());
      } on Exception {
        return DayAtSortit(day: -1, loginTime: DateTime.now());
      }
    } else
      return DayAtSortit(day: -1, loginTime: DateTime.now());
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
  Future<void> logOut() async {
    await SqlDatabaseService.db.cleanDatabase();
    sl<CacheDataClass>().clearDetails();

    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } on Exception {
      throw LogOutFailure();
    }
  }
}
