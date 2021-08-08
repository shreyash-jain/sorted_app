import 'package:meta/meta.dart';
import 'package:sorted/core/global/database/sqflite_init.dart';


abstract class UserIntroNative {
  Future<void> deleteUserActivityTable();

}

class UserIntroNativeDataSourceImpl implements UserIntroNative {
  final SqlDatabaseService nativeDb;

  UserIntroNativeDataSourceImpl({@required this.nativeDb});

 
  @override
  Future<void> deleteUserActivityTable() async {
    final db = await nativeDb.database;
    await db.delete('User_Activity');
  }
}
