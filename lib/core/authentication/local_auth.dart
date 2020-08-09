import 'package:dartz/dartz.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class LocalAuthenticationService {
  final _auth = LocalAuthentication();
  bool _isProtectionEnabled = false;

  // ignore: unnecessary_getters_setters
  bool get isProtectionEnabled => _isProtectionEnabled;

  // ignore: unnecessary_getters_setters
  set isProtectionEnabled(bool enabled) => _isProtectionEnabled = enabled;
  bool isAuthenticated = false;

  void cancelAuthentication() {
    _auth.stopAuthentication();
  }

  Future<Either<Failure, bool>> authenticate(bool state) async {
    if (state) {
      try {
        print("hello");
        return Right(await _auth.authenticateWithBiometrics(
          localizedReason: 'authenticate to access',
          useErrorDialogs: true,
          stickyAuth: true,
        ));
      } on PlatformException catch (e) {
        print(e);
        if (e.code == auth_error.notAvailable) {
          print("Not available");
          // Handle this exception here.
        }
        return Left(PlatformFailure());
      }
    } else {
      return Right(true);
    }
  }
}
