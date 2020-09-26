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
    print(newActivity);
    final db = await nativeDb.database;
    UserAModel toSave = new UserAModel(
        name: newActivity.name, aId: newActivity.aId, image: newActivity.image);
    if (toSave.savedTs == null)
      toSave = toSave.copyWith(savedTs: DateTime.now());
    var result = await db.insert('User_Activity', toSave.toMap());
    toSave = toSave.copyWith(id: result);
    return toSave;
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
    await db.delete('User_Activity');
  }
}
