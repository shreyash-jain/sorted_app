import 'package:sorted/core/global/models/user_details.dart';

class CacheDataClass {
  static UserDetail _userDetail;
  static bool _oldState;
  CacheDataClass._();

  static final CacheDataClass cacheData = CacheDataClass._();

  setUserDetail(UserDetail detail) {
    _userDetail = detail;
    print("setUserDetail"+_userDetail.toString());
  }

  getUserDetail() {
    print("getUserDetail"+_userDetail.toString());
    return _userDetail;
     
  }

  setOldState(bool oldState) {
    _oldState = oldState;
  }

  getOldState() {
    return _oldState;
  }
}
