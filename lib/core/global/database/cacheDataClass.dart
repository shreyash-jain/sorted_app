import 'package:sorted/core/global/entities/day_at_sortit.dart';
import 'package:sorted/core/global/models/user_details.dart';

class CacheDataClass {
  static UserDetail _userDetail;
  static bool _oldState;
  static DayAtSortit dayAtSortit;
  CacheDataClass._();

  static final CacheDataClass cacheData = CacheDataClass._();

  setUserDetail(UserDetail detail) {


    _userDetail = detail;
    print("setUserDetail" + _userDetail.toString());
  }

  setDayAtSortit(DayAtSortit detail) {
    dayAtSortit = detail;
  }

  DayAtSortit getDayAtSortit() {
    return dayAtSortit;
  }

  
  UserDetail getUserDetail() {
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
