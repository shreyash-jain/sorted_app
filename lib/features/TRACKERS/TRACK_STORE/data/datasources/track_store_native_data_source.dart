import 'package:meta/meta.dart';
import 'package:sorted/core/global/database/sqflite_init.dart';
import 'package:sorted/features/PROFILE/data/models/user_activity.dart';

abstract class TrackStoreNative {}

class TrackStoreNativeDataSourceImpl implements TrackStoreNative {
  final SqlDatabaseService nativeDb;

  TrackStoreNativeDataSourceImpl({@required this.nativeDb});
}
