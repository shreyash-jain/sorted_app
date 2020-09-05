import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sorted/core/error/exceptions.dart';

abstract class UserIntroductionSharedPref {
  Future<bool> oldUserState();
  Future<String> userName();
}

const OLD_USER_TAG = 'old_user';
const USER_NAME_TAG = 'google_name';

class UserSharedPrefDataSourceImpl implements UserIntroductionSharedPref {
  final SharedPreferences sharedPreferences;

  UserSharedPrefDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<bool> oldUserState() {
    bool oldState = false;
    if (sharedPreferences.getBool(OLD_USER_TAG) != null) {
      oldState = sharedPreferences.getBool(OLD_USER_TAG);
    }

    try {
      return Future.value(oldState);
    } on Exception {
      throw CacheException();
    }
  }

  @override
  Future<String> userName() {
    String userName = "";
    if (sharedPreferences.getString(USER_NAME_TAG) != null) {
      userName = sharedPreferences.getString(USER_NAME_TAG);
    }

    try {
      return Future.value(userName);
    } on Exception {
      throw CacheException();
    }
  }
}
