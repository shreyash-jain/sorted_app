import 'dart:async';

import 'package:sorted/core/global/models/deep_link_data/deep_link_data.dart';
import 'package:sorted/core/global/models/user_details.dart';

class CacheDeepLinkDataClass {
  static DeepLinkType type;
  static ClassEnrollData classEnrollData;
  static Stream<DeepLinkType> deeplinkState;
  final _deepLinkcontroller = StreamController<DeepLinkType>();
  CacheDeepLinkDataClass._();

  static final CacheDeepLinkDataClass cacheData = CacheDeepLinkDataClass._();

  setDeepLinkType(DeepLinkType detail) {
    type = detail;
    print("setUserDetail" + type.toString());
  }

  DeepLinkType getDeepLinkType() {
    print("getUserDetail" + type.toString());
    return type;
  }

  

  setClassEnrollData(ClassEnrollData oldState) {
    classEnrollData = oldState;
  }

  ClassEnrollData getClassEnrollData() {
    return classEnrollData;
  }
}
