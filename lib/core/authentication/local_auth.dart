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

  Future<bool> authenticate(bool state) async {
    if (state) {
      try {
        print("hello");
        isAuthenticated=await _auth.authenticateWithBiometrics(
          localizedReason: 'authenticate to access',
          useErrorDialogs: true,
          stickyAuth: true,
        );
        print("auth value in local auth " + isAuthenticated.toString());
        return (isAuthenticated);
      } on PlatformException catch (e) {
        
          print("Not available");
          // Handle this exception here.
        
      }
    } else {
      isAuthenticated=true;
      return true;
    }

    return isAuthenticated;
  }
}
