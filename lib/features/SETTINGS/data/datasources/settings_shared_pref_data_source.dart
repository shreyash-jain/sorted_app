import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sorted/core/error/exceptions.dart';

abstract class SettingsSharedPref {
  Future<bool> getBiometricState();
  Future<void> setBiometricState(bool state);
  Future<bool> getGoogleFitState();
  Future<void> setGoogleFitState(bool state);
  Future<int> getDefaultsurveyTime();
  Future<void> setDefaultsurveyTime(int time);
}

const BIOMETRIC_NUMBER_TRIVIA = 'biometric';
const DEFAULT_TIME_TRIVIA = 'default_survey_time';
const GOOGLE_FIT_NUMBER_TRIVIA = 'google_fit';

class SettingsPrefDataSourceImpl implements SettingsSharedPref {
  final SharedPreferences sharedPreferences;

  SettingsPrefDataSourceImpl({@required this.sharedPreferences});
  @override
  setBiometricState(bool state) {
    return sharedPreferences.setBool(BIOMETRIC_NUMBER_TRIVIA, state);
  }

  @override
  Future<bool> getBiometricState() {
    final bool biometricState =
        sharedPreferences.getBool(BIOMETRIC_NUMBER_TRIVIA);
    try {
      if (biometricState != null) {
        return Future.value(biometricState);
      } else {
        setBiometricState(false);
        return Future.value(false);
      }
    } on Exception {
      throw CacheException();
    }
  }

  @override
  Future<bool> getGoogleFitState() {
    final bool biometricState =
        sharedPreferences.getBool(GOOGLE_FIT_NUMBER_TRIVIA);
    try {
      if (biometricState != null) {
        return Future.value(biometricState);
      } else {
        setBiometricState(false);
        return Future.value(false);
      }
    } on Exception {
      throw CacheException();
    }
  }

  @override
  Future<void> setGoogleFitState(bool state) {
    return sharedPreferences.setBool(GOOGLE_FIT_NUMBER_TRIVIA, state);
  }

  @override
  Future<int> getDefaultsurveyTime() {
   final int defaultTime =
        sharedPreferences.getInt(DEFAULT_TIME_TRIVIA);
    try {
      if (defaultTime != null) {
        return Future.value(defaultTime);
      } else {
        setDefaultsurveyTime(15);
        return Future.value(15);
      }
    } on Exception {
      throw CacheException();
    }
  }

  @override
  Future<void> setDefaultsurveyTime(int time) {
    return sharedPreferences.setInt(DEFAULT_TIME_TRIVIA, time);
  }
}
