import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sorted/core/error/exceptions.dart';

abstract class TrackStoreSharedPref {}



class TrackStoreSharedPrefDataSourceImpl implements TrackStoreSharedPref {
  final SharedPreferences sharedPreferences;

  TrackStoreSharedPrefDataSourceImpl({@required this.sharedPreferences});

 
}
