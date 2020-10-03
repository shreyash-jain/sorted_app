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
  final Firestore cloudDb;
  final FirebaseAuth auth;
  final SqlDatabaseService nativeDb;
  Batch batch;

  SettingsCloudDataSourceImpl(
      {@required this.cloudDb, @required this.auth, @required this.nativeDb});

  @override
  Future<void> addSettings(SettingsDetails setting) async {
    FirebaseUser user = await auth.currentUser();
 
    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection("user_data")
        .document("settings");

    ref
        .setData(setting.toMap())
        .then((value) => print(ref.documentID))
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
    return;
  }

  @override
  Future<void> updateSettings(SettingsDetails setting) async {
    FirebaseUser user = await auth.currentUser();

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection("user_data")
        .document("settings");

    ref
        .updateData(setting.toMap())
        .then((value) => print(ref.documentID))
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
    return;
  }
}
