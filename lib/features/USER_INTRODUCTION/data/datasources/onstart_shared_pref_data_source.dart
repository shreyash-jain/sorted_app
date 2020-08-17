
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sorted/core/error/exceptions.dart';

abstract class UserIntroductionSharedPref {
  Future<bool> getOldUserState();
}

const OLD_USER_TAG = 'old_user';

class UserSharedPrefDataSourceImpl implements UserIntroductionSharedPref {
  final SharedPreferences sharedPreferences;

  UserSharedPrefDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<bool> getOldUserState() {
    final bool biometricState = sharedPreferences.getBool(OLD_USER_TAG);
    try {
      return Future.value(biometricState);
    } on Exception {
      throw CacheException();
    }
  }
}
