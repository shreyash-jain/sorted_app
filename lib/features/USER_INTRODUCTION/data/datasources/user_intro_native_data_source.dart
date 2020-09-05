import 'package:meta/meta.dart';
import 'package:sorted/core/global/database/sqflite_init.dart';
import 'package:sorted/features/PROFILE/data/models/user_activity.dart';

abstract class UserIntroNative {
  Future<void> deleteUserActivityTable();
  Future<UserAModel> add(UserAModel newActivity);
  Future<void> delete(UserAModel actToDelete);
}

class UserIntroNativeDataSourceImpl implements UserIntroNative {
  final SqlDatabaseService nativeDb;

  UserIntroNativeDataSourceImpl({@required this.nativeDb});

  @override
  Future<UserAModel> add(UserAModel newActivity) async {
    final db = await nativeDb.database;
    if (newActivity.savedTs == null)
      newActivity.copyWith(savedTs: DateTime.now());
    var result = await db.insert('User_Activity', newActivity.toMap());
     newActivity.copyWith(id:result);
    return newActivity;
  }

  @override
  Future<void> delete(UserAModel actToDelete) async {
    final db = await nativeDb.database;
    await db
        .delete('User_Activity', where: 'id = ?', whereArgs: [actToDelete.id]);
    print('User Activity deleted');
  }

  @override
  Future<void> deleteUserActivityTable() async {
    final db = await nativeDb.database;
    await db.delete('User_Activity', where: 'id >8');
  }
}
