import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:meta/meta.dart';

import 'package:sorted/core/global/database/sqflite_init.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/data/models/inspiration.dart';
import 'package:sorted/features/HOME/data/models/placeholder_info.dart';
import 'package:sorted/features/SETTINGS/data/models/settings_details.dart';
import 'package:sqflite/sqflite.dart';

abstract class SettingsCloud {
  Future<void> addSettings(SettingsDetails inspirations);
  Future<void> updateSettings(SettingsDetails inspirations);
}

class SettingsCloudDataSourceImpl implements SettingsCloud {
  final FirebaseFirestore cloudDb;
  final FirebaseAuth auth;
  final SqlDatabaseService nativeDb;
  Batch batch;

  SettingsCloudDataSourceImpl(
      {@required this.cloudDb, @required this.auth, @required this.nativeDb});

  @override
  Future<void> addSettings(SettingsDetails setting) async {
   User user = auth.currentUser;
 
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection("user_data")
        .doc("settings");

    ref
        .set(setting.toMap())
        .then((value) => print(ref.id))
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
    return;
  }

  @override
  Future<void> updateSettings(SettingsDetails setting) async {
   User user = auth.currentUser;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection("user_data")
        .doc("settings");

    ref
        .update(setting.toMap())
        .then((value) => print(ref.id))
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
    return;
  }
}
