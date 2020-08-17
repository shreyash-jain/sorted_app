

import 'package:meta/meta.dart';
import 'package:sorted/core/database/sqflite_init.dart';

import 'package:sorted/features/PROFILE/data/models/user_activity.dart';


abstract class UserIntroNative {
  Future<void> deleteUserActivityTable();
  Future<UserAModel> addUserActivity(UserAModel newActivity);
  Future<void> deleteUserActivityInDB(UserAModel actToDelete);
}

class UserIntroNativeDataSourceImpl implements UserIntroNative {
  final SqlDatabaseService nativeDb;

  UserIntroNativeDataSourceImpl({@required this.nativeDb});

  @override
  Future<UserAModel> addUserActivity(UserAModel newActivity) async {
    final db = await nativeDb.database;
    if (newActivity.savedTs == null)
      newActivity.copyWith(savedTs: DateTime.now());
    await db.transaction((transaction) async {
      int id = await transaction.rawInsert(
          'INSERT into User_Activity(name, image, a_id,saved_ts) VALUES ("${newActivity.name}","${newActivity.image}" , ${newActivity.aId},"${newActivity.savedTs.toIso8601String()}");');
      newActivity.copyWith(id: id);
      print('Activity added: ${id}');
    });
    return newActivity;
  }

  @override
  Future<void> deleteUserActivityInDB(UserAModel actToDelete) async {
    final db = await nativeDb.database;
    await db.delete('Events', where: 'id = ?', whereArgs: [actToDelete.id]);
    print('User Activity deleted');
  }

  @override
  Future<void> deleteUserActivityTable() async {
    final db = await nativeDb.database;
    await db.delete('User_Activity', where: 'id >8');
  }
}
