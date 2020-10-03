

import 'package:sorted/core/global/database/sqflite_init.dart';


import 'package:sorted/core/global/models/user_details.dart';

abstract class AuthNativeDataSource {
  
  Future<void> add(UserDetail user);
  Future<void> update(UserDetail user);
  Future<void> remove(UserDetail user);
  Future<UserDetail> getUserDetail();
  
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
     await db.update(userTable, user.toMap(),
        where: "id = ?", whereArgs: [user.id]);

  }

  @override
  Future<UserDetail> getUserDetail() async {
    final db = await nativeDb.database;
    
    List<Map<String, dynamic>> result;

    result = await db.query(userTable);

    List<UserDetail> details = result.isNotEmpty
        ? result.map((item) => UserDetail.fromMap(item)).toList()
        : [new UserDetail(id:-1)];
    return details[0];

    
  }
  
}
