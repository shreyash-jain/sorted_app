
import 'package:sorted/core/database/sqflite_init.dart';


import 'package:sorted/core/global/models/user_details.dart';

abstract class AuthNativeDataSource {
  
  Future<void> addUserToNative(UserDetail user);
  Future<void> updateUserToNative(UserDetail user);
  Future<void> removeUserfromNative(UserDetail user);
  
}

class AuthNativeDataSourceImpl implements AuthNativeDataSource {
  final SqlDatabaseService nativeDb;
  

 
  AuthNativeDataSourceImpl( 
      {this.nativeDb});

  @override
  Future<void> addUserToNative(UserDetail user) async {
    final db = await nativeDb.database;
    await db.insert(userTable, user.toMap());
    
    }
  
    @override
    Future<void> removeUserfromNative(UserDetail user) async {
       final db = await nativeDb.database;
       await db.delete(userTable, where: 'id = ?', whereArgs: [user.id]);

    }
  
    @override
    Future<void> updateUserToNative(UserDetail user) async {
     final db = await nativeDb.database;
     await db.update(todoTABLE, user.toMap(),
        where: "id = ?", whereArgs: [user.id]);

  }
  
}
