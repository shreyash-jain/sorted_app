
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sorted/core/error/exceptions.dart';
abstract class OnStartSharedPref {

  Future<bool> getBiometricState();
  setBiometricState(bool state);
  Future<bool> getOnBoardState();
  Future<int> getSignInId();


}
const BIOMETRIC_NUMBER_TRIVIA = 'biometric';
const ONBOARD_NUMBER_TRIVIA = 'onboard';
const SIGNINID_NUMBER_TRIVIA = 'signInId';
class OnStartSharedPrefDataSourceImpl implements OnStartSharedPref {
  final SharedPreferences sharedPreferences;

  OnStartSharedPrefDataSourceImpl({@required this.sharedPreferences});

 


  @override
  Future<bool> getBiometricState() {
    final bool biometricState = sharedPreferences.getBool(BIOMETRIC_NUMBER_TRIVIA);
    try{if (biometricState != null) {
      return Future.value(biometricState);
    } else {
      setBiometricState(false);
      return Future.value(false);
    }}
    on Exception{
      throw CacheException();
    }
  }

  @override
  Future<bool> getOnBoardState() {
   final bool onboardState = sharedPreferences.getBool(ONBOARD_NUMBER_TRIVIA);
    if (onboardState != null) {
      return Future.value(onboardState);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<int> getSignInId() {
   final int signinid = sharedPreferences.getInt(SIGNINID_NUMBER_TRIVIA);
    if (signinid != null) {
      return Future.value(signinid);
    } else {
      throw CacheException();
    }
  }

  @override
  setBiometricState(bool state) {
    return sharedPreferences.setBool(BIOMETRIC_NUMBER_TRIVIA, state);
  }


  
}