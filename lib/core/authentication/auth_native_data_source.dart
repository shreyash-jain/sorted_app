

import 'package:sorted/core/global/database/sqflite_init.dart';


import 'package:sorted/core/global/models/user_details.dart';

abstract class AuthNativeDataSource {
  
  Future<void> add(UserDetail user);
  Future<void> update(UserDetail user);
  Future<void> remove(UserDetail user);
  
}

class AuthNativeDataSourceImpl implements AuthNativeDataSource {
  final SqlDatabaseService nativeDb;
  

 
  AuthNativeDataSourceImpl( 
      {this.nativeDb});

  @override
  Future<void> add(UserDetail user) async {
    final db = await nativeDb.database;
    await db.insert(userTable, user.toMap());
    
    }
  
    @override
    Future<void> remove(UserDetail user) async {
       final db = await nativeDb.database;
       await db.delete(userTable, where: 'id = ?', whereArgs: [user.id]);

    }
  
    @override
    Future<void> update(UserDetail user) async {
     final db = await nativeDb.database;
     await db.update(todoTABLE, user.toMap(),
        where: "id = ?", whereArgs: [user.id]);

  }
  
}
