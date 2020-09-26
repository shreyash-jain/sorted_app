import 'package:sorted/core/global/models/user_details.dart';

class CacheDataClass {
  static UserDetail _userDetail;
  static bool _oldState;
  CacheDataClass._();

  static final CacheDataClass cacheData = CacheDataClass._();

  setUserDetail(UserDetail detail) {
    _userDetail = detail;
    print("setUserDetail" + _userDetail.toString());
  }

  updateUserDetail({
    String name,
    String imageUrl,
    String email,
    int id,
    String userName,
    int currentDeviceId,
    String currentDevice,
    int age,
    int diaryStreak,
    int points,
    int level,
    Gender gender,
    Profession profession,
  }) {
    _userDetail = _userDetail.copyWith(
      name: name,
      imageUrl: imageUrl,
      email: email,
      id: id,
      userName: userName,
      currentDeviceId: currentDeviceId,
      currentDevice: currentDevice,
      age: age,
      diaryStreak: diaryStreak,
      points: points,
      level: level,
      gender: gender,
      profession: profession,
    );
    print("updateUserDetail" + _userDetail.toString());
  }

  getUserDetail() {
    print("getUserDetail" + _userDetail.toString());
    return _userDetail;
  }

  setOldState(bool oldState) {
    _oldState = oldState;
  }

  getOldState() {
    return _oldState;
  }
}
