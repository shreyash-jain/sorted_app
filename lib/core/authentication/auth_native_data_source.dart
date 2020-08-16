import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_utils/date_utils.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:googleapis/calendar/v3.dart';
import 'package:meta/meta.dart';
import 'package:sorted/core/authentication/GoogleHttpClient.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sorted/core/database/sqflite_init.dart';

import 'package:sorted/core/error/exceptions.dart';
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
