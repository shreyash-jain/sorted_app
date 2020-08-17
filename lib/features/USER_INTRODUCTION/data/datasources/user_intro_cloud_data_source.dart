import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:meta/meta.dart';
import 'package:sorted/core/database/sqflite_init.dart';

import 'package:sorted/core/error/exceptions.dart';
import 'package:sorted/features/PROFILE/data/models/activity.dart';
import 'package:sorted/features/PROFILE/data/models/user_activity.dart';
import 'package:sqflite/sqflite.dart';

abstract class UserIntroCloud {
  Stream<double> getUserCloudData();
  Stream<double> copyToUserCloudData();
  Future<List<ActivityModel>> getAllActivitiesFromCloud();
  Future<List<UserAModel>> getUserActivitiesFromCloud();
  Future<void> addUserActivitiesToCloud(UserAModel newActivity);
}

class UserIntroCloudDataSourceImpl implements UserIntroCloud {
  final Firestore cloudDb;
  final FirebaseAuth auth;
  final SqlDatabaseService nativeDb;
  Batch batch;

  UserIntroCloudDataSourceImpl(
      {@required this.cloudDb, @required this.auth, @required this.nativeDb});

  @override
  Stream<double> getUserCloudData() async* {
    yield (0);
    FirebaseUser user = await auth.currentUser();
    final db = await nativeDb.database;
    batch = db.batch();
    double progress = 0;
    for (int i = 0; i < tables.length; i++) {
      QuerySnapshot snapShot = await cloudDb
          .collection('users')
          .document(user.uid)
          .collection(tables[i])
          .getDocuments();
      if (snapShot != null && snapShot.documents.length != 0) {
        final List<DocumentSnapshot> documents = snapShot.documents;

        for (int j = 0; j < documents.length; j++) {
          batch.insert((tables[i]), documents[j].data);
        }

        progress += (1 / tables.length);
        yield (progress);
      }
    }
    yield (1);
    await batch.commit(noResult: true);
  }

  @override
  Stream<double> copyToUserCloudData() async* {
    yield (0);
    FirebaseUser user = await auth.currentUser();
    final db = await nativeDb.database;
    batch = db.batch();
    double progress = 0;

    for (int i = 0; i < tables.length; i++) {
      QuerySnapshot snapShot = await cloudDb
          .collection('StartData')
          .document('data')
          .collection(tables[i])
          .getDocuments();
      if (snapShot != null && snapShot.documents.length != 0) {
        final List<DocumentSnapshot> documents = snapShot.documents;

        for (int j = 0; j < documents.length; j++) {
          DocumentReference ref = cloudDb
              .collection('users')
              .document(user.uid)
              .collection(tables[i])
              .document(documents[j].documentID);
          ref
              .setData(documents[j].data)
              .then((value) => print(ref.documentID))
              .catchError((onError) => {print("nhi chala\n"), print("hello")});

          batch.insert((tables[i]), documents[j].data);
        }
        progress += (1 / tables.length);
        yield (progress);
      }
    }
    yield (1);
    await batch.commit(noResult: true);
  }

  @override
  Future<List<ActivityModel>> getAllActivitiesFromCloud() async {
    QuerySnapshot snapShot = await cloudDb
        .collection('StartData')
        .document('data')
        .collection('Activity')
        .getDocuments();
    if (snapShot != null && snapShot.documents.length != 0) {
      final List<DocumentSnapshot> documents = snapShot.documents;
      return documents.map((e) => ActivityModel.fromSnapshot(e)).toList();
    }
    return Future.value([]);
  }

  @override
  Future<List<UserAModel>> getUserActivitiesFromCloud() async {
    QuerySnapshot snapShot = await cloudDb
        .collection('StartData')
        .document('data')
        .collection('User_Activity')
        .getDocuments();
    if (snapShot != null && snapShot.documents.length != 0) {
      final List<DocumentSnapshot> documents = snapShot.documents;
      return documents.map((e) => UserAModel.fromSnapshot(e)).toList();
    }
    return Future.value([]);
  }

  @override
  Future<void> addUserActivitiesToCloud(UserAModel newActivity) async {
    FirebaseUser user = await auth.currentUser();

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection("User_Activity")
        .document(newActivity.id.toString());

    ref
        .setData(newActivity.toMap())
        .then((value) => print(ref.documentID))
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }
}
