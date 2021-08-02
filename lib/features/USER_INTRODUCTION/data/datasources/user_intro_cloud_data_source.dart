import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:meta/meta.dart';

import 'package:sorted/core/global/database/sqflite_init.dart';

import 'package:sorted/core/global/models/health_condition.dart';
import 'package:sorted/core/global/models/health_profile.dart';

import 'package:sorted/features/PROFILE/data/models/activity.dart';
import 'package:sorted/features/PROFILE/data/models/user_activity.dart';
import 'package:sorted/features/USER_INTRODUCTION/data/models/user_tag.dart';
import 'package:sqflite/sqflite.dart';

abstract class UserIntroCloud {
  Stream<double> getUserCloudData();
  Stream<double> copyToUserCloudData();
  Future<List<ActivityModel>> get allActivities;
  Future<List<UserAModel>> get userActivities;
  Future<void> add(UserAModel newActivity);
  Future<void> delete(UserAModel newActivity);
  Future<void> deleteUserActivityTable();
  Future<bool> isUserNameAvailable(String username);
  Future<List<UserTag>> getFitnessTags();
  Future<List<UserTag>> getMentalHealthTags();
  Future<List<UserTag>> getFoodTags();
  Future<List<UserTag>> getFinanceTags();
  Future<List<UserTag>> getProductivityTags();
  Future<List<UserTag>> getCareerTags();
  Future<List<UserTag>> getFamilyTags();
  Future<List<UserTag>> getChildrenOfTag(UserTag tag, String category);
  Future<bool> saveHealthProfile(
    HealthProfile lifestyleProfile,
  );
  Future<bool> saveUserInterests(
    List<UserTag> fitnessTags,
    List<UserTag> mindfulTags,
    List<UserTag> foodTags,
    List<UserTag> productivityTags,
    List<UserTag> relationshipTags,
    List<UserTag> careerTags,
    List<UserTag> financeTags,
  );
}

class UserIntroCloudDataSourceImpl implements UserIntroCloud {
  final FirebaseFirestore cloudDb;
  final FirebaseAuth auth;
  final SqlDatabaseService nativeDb;
  Batch batch;

  UserIntroCloudDataSourceImpl(
      {@required this.cloudDb, @required this.auth, @required this.nativeDb});

  @override
  Stream<double> getUserCloudData() async* {
    yield (0);
    User user = auth.currentUser;
    final db = await nativeDb.database;
    nativeDb.cleanDatabase();

    batch = db.batch();
    double progress = 0;
    for (int i = 0; i < tables.length; i++) {
      QuerySnapshot snapShot = await cloudDb
          .collection('users')
          .doc(user.uid)
          .collection(tables[i])
          .get();
      if (snapShot != null && snapShot.docs.length != 0) {
        final List<DocumentSnapshot> docs = snapShot.docs;

        for (int j = 0; j < docs.length; j++) {
          batch.insert((tables[i]), docs[j].data());
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
    User user = auth.currentUser;
    nativeDb.cleanDatabase();
    final db = await nativeDb.database;
    batch = db.batch();
    double progress = 0;

    for (int i = 0; i < tables.length; i++) {
      QuerySnapshot snapShot = await cloudDb
          .collection('StartData')
          .doc('data')
          .collection(tables[i])
          .get();
      if (snapShot != null && snapShot.docs.length != 0) {
        final List<DocumentSnapshot> docs = snapShot.docs;

        for (int j = 0; j < docs.length; j++) {
          DocumentReference ref = cloudDb
              .collection('users')
              .doc(user.uid)
              .collection(tables[i])
              .doc(docs[j].id);
          ref
              .set(docs[j].data())
              .then((value) => print(ref.id))
              .catchError((onError) => {print("nhi chala\n"), print("hello")});

          batch.insert((tables[i]), docs[j].data());
        }
        progress += (1 / tables.length);
        yield (progress);
      }
    }
    yield (1);
    await batch.commit(noResult: true);
  }

  @override
  Future<List<ActivityModel>> get allActivities async {
    QuerySnapshot snapShot = await cloudDb
        .collection('StartData')
        .doc('data')
        .collection('Activity')
        .get();
    if (snapShot != null && snapShot.docs.length != 0) {
      final List<DocumentSnapshot> docs = snapShot.docs;
      return docs.map((e) => ActivityModel.fromSnapshot(e)).toList();
    }
    return Future.value([]);
  }

  @override
  Future<List<UserAModel>> get userActivities async {
    User user = auth.currentUser;
    QuerySnapshot snapShot = await cloudDb
        .collection('users')
        .doc(user.uid)
        .collection("User_Activity")
        .get();
    if (snapShot == null) return Future.value([]);
    if (snapShot != null && snapShot.docs.length != 0) {
      final List<DocumentSnapshot> docs = snapShot.docs;
      return docs.map((e) => UserAModel.fromSnapshot(e)).toList();
    }
    return Future.value([]);
  }

  @override
  Future<void> add(UserAModel newActivity) async {
    print("add useract in cloud " + newActivity.name);
    User user = auth.currentUser;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection("User_Activity")
        .doc(newActivity.id.toString());

    await ref
        .set(newActivity.toMap())
        .then((value) => print(ref.id))
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> delete(UserAModel newActivity) async {
    User user = auth.currentUser;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection("User_Activity")
        .doc(newActivity.id.toString());

    ref
        .delete()
        .then((value) => print(ref.id))
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> deleteUserActivityTable() async {
    User user = auth.currentUser;

    var ref =
        cloudDb.collection('users').doc(user.uid).collection("User_Activity");

    await ref.get().then((value) => {
          value.docs.forEach((element) {
            element.reference.delete();
          })
        });
  }

  @override
  Future<bool> isUserNameAvailable(String username) async {
    QuerySnapshot snapShot = await cloudDb
        .collection('usernames')
        .where(
          'username',
          isEqualTo: username,
        )
        .get();
    print("shakiya");
    print(snapShot.docs.length);
    if (snapShot == null)
      return true;
    else if (snapShot != null && snapShot.docs.length == 0) {
      return true;
    } else if (snapShot != null && snapShot.docs.length >= 1) {
      return false;
    }
    return Future.value(false);
  }

  @override
  Future<List<UserTag>> getCareerTags() async {
    QuerySnapshot snapShot = await cloudDb
        .collection('onboard_user_tagging')
        .doc("Career")
        .collection("Children")
        .get();
    if (snapShot == null) return Future.value([]);
    if (snapShot != null && snapShot.docs.length != 0) {
      final List<DocumentSnapshot> docs = snapShot.docs;
      return docs.map((e) => UserTag.fromSnapshot(e)).toList();
    }
    return Future.value([]);
  }

  @override
  Future<List<UserTag>> getFamilyTags() async {
    QuerySnapshot snapShot = await cloudDb
        .collection('onboard_user_tagging')
        .doc("Family and Relationship")
        .collection("Children")
        .get();
    if (snapShot == null) return Future.value([]);
    if (snapShot != null && snapShot.docs.length != 0) {
      final List<DocumentSnapshot> docs = snapShot.docs;
      return docs.map((e) => UserTag.fromSnapshot(e)).toList();
    }
    return Future.value([]);
  }

  @override
  Future<List<UserTag>> getFinanceTags() async {
    QuerySnapshot snapShot = await cloudDb
        .collection('onboard_user_tagging')
        .doc("Finance and Money")
        .collection("Children")
        .get();
    if (snapShot == null) return Future.value([]);
    if (snapShot != null && snapShot.docs.length != 0) {
      final List<DocumentSnapshot> docs = snapShot.docs;
      return docs.map((e) => UserTag.fromSnapshot(e)).toList();
    }
    return Future.value([]);
  }

  @override
  Future<List<UserTag>> getFitnessTags() async {
    QuerySnapshot snapShot = await cloudDb
        .collection('onboard_user_tagging')
        .doc("Fitness")
        .collection("Children")
        .get();
    if (snapShot == null) return Future.value([]);
    if (snapShot != null && snapShot.docs.length != 0) {
      final List<DocumentSnapshot> docs = snapShot.docs;
      return docs.map((e) => UserTag.fromSnapshot(e)).toList();
    }
    return Future.value([]);
  }

  @override
  Future<List<UserTag>> getFoodTags() async {
    QuerySnapshot snapShot = await cloudDb
        .collection('onboard_user_tagging')
        .doc("Food and Nutrition")
        .collection("Children")
        .get();
    if (snapShot == null) return Future.value([]);
    if (snapShot != null && snapShot.docs.length != 0) {
      final List<DocumentSnapshot> docs = snapShot.docs;
      return docs.map((e) => UserTag.fromSnapshot(e)).toList();
    }
    return Future.value([]);
  }

  @override
  Future<List<UserTag>> getMentalHealthTags() async {
    QuerySnapshot snapShot = await cloudDb
        .collection('onboard_user_tagging')
        .doc("Mental Health")
        .collection("Children")
        .get();
    if (snapShot == null) return Future.value([]);
    if (snapShot != null && snapShot.docs.length != 0) {
      final List<DocumentSnapshot> docs = snapShot.docs;
      return docs.map((e) => UserTag.fromSnapshot(e)).toList();
    }
    return Future.value([]);
  }

  @override
  Future<List<UserTag>> getProductivityTags() async {
    QuerySnapshot snapShot = await cloudDb
        .collection('onboard_user_tagging')
        .doc("Productivity")
        .collection("Children")
        .get();
    if (snapShot == null) return Future.value([]);
    if (snapShot != null && snapShot.docs.length != 0) {
      final List<DocumentSnapshot> docs = snapShot.docs;
      return docs.map((e) => UserTag.fromSnapshot(e)).toList();
    }
    return Future.value([]);
  }

  @override
  Future<List<UserTag>> getChildrenOfTag(UserTag tag, String category) async {
    QuerySnapshot snapShot = await cloudDb
        .collection('onboard_user_tagging')
        .doc(category)
        .collection("Children")
        .doc(tag.tag)
        .collection("Children")
        .get();
    if (snapShot == null) return Future.value([]);
    if (snapShot != null && snapShot.docs.length != 0) {
      final List<DocumentSnapshot> docs = snapShot.docs;
      return docs.map((e) => UserTag.fromSnapshot(e)).toList();
    }
    return Future.value([]);
  }

  @override
  Future<bool> saveHealthProfile(
    HealthProfile fitnessProfile,
  ) async {
    User user = auth.currentUser;

    DocumentReference refFitness = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection("user_data")
        .doc("fitness_profile");
  

    refFitness
        .set(fitnessProfile.toMap(),SetOptions(merge: true))
        .then((value) => print(refFitness.id))
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
   
    return true;
  }

  @override
  Future<bool> saveUserInterests(
      List<UserTag> fitnessTags,
      List<UserTag> mindfulTags,
      List<UserTag> foodTags,
      List<UserTag> productivityTags,
      List<UserTag> relationshipTags,
      List<UserTag> careerTags,
      List<UserTag> financeTags) async {
    User user = auth.currentUser;

    CollectionReference refFitness = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection("user_data")
        .doc("tags")
        .collection("fitness_tags");
    CollectionReference refMind = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection("user_data")
        .doc("tags")
        .collection("mental_tags");
    CollectionReference refFood = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection("user_data")
        .doc("tags")
        .collection("food_tags");
    CollectionReference refProductivity = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection("user_data")
        .doc("tags")
        .collection("productivity_tags");
    CollectionReference refRelationship = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection("user_data")
        .doc("tags")
        .collection("relationship_tags");
    CollectionReference refCareer = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection("user_data")
        .doc("tags")
        .collection("career_tags");
    CollectionReference refFinance = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection("user_data")
        .doc("tags")
        .collection("finance_tags");

    fitnessTags.forEach((element) {
      refFitness
          .doc(element.id.toString())
          .set(element.toMap())
          .then((value) => print(""));
    });
    mindfulTags.forEach((element) {
      refMind
          .doc(element.id.toString())
          .set(element.toMap())
          .then((value) => print(""));
    });
    foodTags.forEach((element) {
      refFood
          .doc(element.id.toString())
          .set(element.toMap())
          .then((value) => print(""));
    });
    productivityTags.forEach((element) {
      refProductivity
          .doc(element.id.toString())
          .set(element.toMap())
          .then((value) => print(""));
    });
    relationshipTags.forEach((element) {
      refRelationship
          .doc(element.id.toString())
          .set(element.toMap())
          .then((value) => print(""));
    });
    careerTags.forEach((element) {
      refCareer
          .doc(element.id.toString())
          .set(element.toMap())
          .then((value) => print(""));
    });
    financeTags.forEach((element) {
      refFinance
          .doc(element.id.toString())
          .set(element.toMap())
          .then((value) => print(""));
    });
    return true;
  }
}
