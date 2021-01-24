import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:meta/meta.dart';

import 'package:sorted/core/global/database/sqflite_init.dart';
import 'package:sorted/core/global/models/addiction_condition.dart';
import 'package:sorted/core/global/models/health_condition.dart';
import 'package:sorted/core/global/models/lifestyle_profile.dart';
import 'package:sorted/core/global/models/mental_health_profile.dart';
import 'package:sorted/core/global/models/physical_health_profile.dart';

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
      PhysicalHealthProfile fitnessProfile,
      MentalHealthProfile mentalProfile,
      LifestyleProfile lifestyleProfile,
      HealthConditions healthConditions,
      AddictionConditions addictionConditions);
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
    nativeDb.cleanDatabase();

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
    nativeDb.cleanDatabase();
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
  Future<List<ActivityModel>> get allActivities async {
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
  Future<List<UserAModel>> get userActivities async {
    FirebaseUser user = await auth.currentUser();
    QuerySnapshot snapShot = await cloudDb
        .collection('users')
        .document(user.uid)
        .collection("User_Activity")
        .getDocuments();
    if (snapShot == null) return Future.value([]);
    if (snapShot != null && snapShot.documents.length != 0) {
      final List<DocumentSnapshot> documents = snapShot.documents;
      return documents.map((e) => UserAModel.fromSnapshot(e)).toList();
    }
    return Future.value([]);
  }

  @override
  Future<void> add(UserAModel newActivity) async {
    print("add useract in cloud " + newActivity.name);
    FirebaseUser user = await auth.currentUser();

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection("User_Activity")
        .document(newActivity.id.toString());

    await ref
        .setData(newActivity.toMap())
        .then((value) => print(ref.documentID))
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> delete(UserAModel newActivity) async {
    FirebaseUser user = await auth.currentUser();

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection("User_Activity")
        .document(newActivity.id.toString());

    ref
        .delete()
        .then((value) => print(ref.documentID))
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> deleteUserActivityTable() async {
    FirebaseUser user = await auth.currentUser();

    var ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection("User_Activity");

    await ref.getDocuments().then((value) => {
          value.documents.forEach((element) {
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
        .getDocuments();
    print("shakiya");
    print(snapShot.documents.length);
    if (snapShot == null)
      return true;
    else if (snapShot != null && snapShot.documents.length == 0) {
      return true;
    } else if (snapShot != null && snapShot.documents.length >= 1) {
      return false;
    }
    return Future.value(false);
  }

  @override
  Future<List<UserTag>> getCareerTags() async {
    QuerySnapshot snapShot = await cloudDb
        .collection('onboard_user_tagging')
        .document("Career")
        .collection("Children")
        .getDocuments();
    if (snapShot == null) return Future.value([]);
    if (snapShot != null && snapShot.documents.length != 0) {
      final List<DocumentSnapshot> documents = snapShot.documents;
      return documents.map((e) => UserTag.fromSnapshot(e)).toList();
    }
    return Future.value([]);
  }

  @override
  Future<List<UserTag>> getFamilyTags() async {
    QuerySnapshot snapShot = await cloudDb
        .collection('onboard_user_tagging')
        .document("Family and Relationship")
        .collection("Children")
        .getDocuments();
    if (snapShot == null) return Future.value([]);
    if (snapShot != null && snapShot.documents.length != 0) {
      final List<DocumentSnapshot> documents = snapShot.documents;
      return documents.map((e) => UserTag.fromSnapshot(e)).toList();
    }
    return Future.value([]);
  }

  @override
  Future<List<UserTag>> getFinanceTags() async {
    QuerySnapshot snapShot = await cloudDb
        .collection('onboard_user_tagging')
        .document("Finance and Money")
        .collection("Children")
        .getDocuments();
    if (snapShot == null) return Future.value([]);
    if (snapShot != null && snapShot.documents.length != 0) {
      final List<DocumentSnapshot> documents = snapShot.documents;
      return documents.map((e) => UserTag.fromSnapshot(e)).toList();
    }
    return Future.value([]);
  }

  @override
  Future<List<UserTag>> getFitnessTags() async {
    QuerySnapshot snapShot = await cloudDb
        .collection('onboard_user_tagging')
        .document("Fitness")
        .collection("Children")
        .getDocuments();
    if (snapShot == null) return Future.value([]);
    if (snapShot != null && snapShot.documents.length != 0) {
      final List<DocumentSnapshot> documents = snapShot.documents;
      return documents.map((e) => UserTag.fromSnapshot(e)).toList();
    }
    return Future.value([]);
  }

  @override
  Future<List<UserTag>> getFoodTags() async {
    QuerySnapshot snapShot = await cloudDb
        .collection('onboard_user_tagging')
        .document("Food and Nutrition")
        .collection("Children")
        .getDocuments();
    if (snapShot == null) return Future.value([]);
    if (snapShot != null && snapShot.documents.length != 0) {
      final List<DocumentSnapshot> documents = snapShot.documents;
      return documents.map((e) => UserTag.fromSnapshot(e)).toList();
    }
    return Future.value([]);
  }

  @override
  Future<List<UserTag>> getMentalHealthTags() async {
    QuerySnapshot snapShot = await cloudDb
        .collection('onboard_user_tagging')
        .document("Mental Health")
        .collection("Children")
        .getDocuments();
    if (snapShot == null) return Future.value([]);
    if (snapShot != null && snapShot.documents.length != 0) {
      final List<DocumentSnapshot> documents = snapShot.documents;
      return documents.map((e) => UserTag.fromSnapshot(e)).toList();
    }
    return Future.value([]);
  }

  @override
  Future<List<UserTag>> getProductivityTags() async {
    QuerySnapshot snapShot = await cloudDb
        .collection('onboard_user_tagging')
        .document("Productivity")
        .collection("Children")
        .getDocuments();
    if (snapShot == null) return Future.value([]);
    if (snapShot != null && snapShot.documents.length != 0) {
      final List<DocumentSnapshot> documents = snapShot.documents;
      return documents.map((e) => UserTag.fromSnapshot(e)).toList();
    }
    return Future.value([]);
  }

  @override
  Future<List<UserTag>> getChildrenOfTag(UserTag tag, String category) async {
    QuerySnapshot snapShot = await cloudDb
        .collection('onboard_user_tagging')
        .document(category)
        .collection("Children")
        .document(tag.tag)
        .collection("Children")
        .getDocuments();
    if (snapShot == null) return Future.value([]);
    if (snapShot != null && snapShot.documents.length != 0) {
      final List<DocumentSnapshot> documents = snapShot.documents;
      return documents.map((e) => UserTag.fromSnapshot(e)).toList();
    }
    return Future.value([]);
  }

  @override
  Future<bool> saveHealthProfile(
      PhysicalHealthProfile fitnessProfile,
      MentalHealthProfile mentalProfile,
      LifestyleProfile lifestyleProfile,
      HealthConditions healthConditions,
      AddictionConditions addictionConditions) async {
    FirebaseUser user = await auth.currentUser();

    DocumentReference refFitness = cloudDb
        .collection('users')
        .document(user.uid)
        .collection("user_data")
        .document("fitness_profile");
    DocumentReference refMind = cloudDb
        .collection('users')
        .document(user.uid)
        .collection("user_data")
        .document("mental_profile");
    DocumentReference refLifestyle = cloudDb
        .collection('users')
        .document(user.uid)
        .collection("user_data")
        .document("lifestyle_profile");
    DocumentReference refHealthCond = cloudDb
        .collection('users')
        .document(user.uid)
        .collection("user_data")
        .document("health_condition");
    DocumentReference refAddiction = cloudDb
        .collection('users')
        .document(user.uid)
        .collection("user_data")
        .document("user_addiction");

    refFitness
        .setData(fitnessProfile.toMap())
        .then((value) => print(refFitness.documentID))
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
    refMind
        .setData(mentalProfile.toMap())
        .then((value) => print(refMind.documentID))
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
    refLifestyle
        .setData(lifestyleProfile.toMap())
        .then((value) => print(refFitness.documentID))
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
    refHealthCond
        .setData(healthConditions.toMap())
        .then((value) => print(refFitness.documentID))
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
    refAddiction
        .setData(addictionConditions.toMap())
        .then((value) => print(refFitness.documentID))
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
    FirebaseUser user = await auth.currentUser();

    CollectionReference refFitness = cloudDb
        .collection('users')
        .document(user.uid)
        .collection("user_data")
        .document("tags")
        .collection("fitness_tags");
    CollectionReference refMind = cloudDb
        .collection('users')
        .document(user.uid)
        .collection("user_data")
        .document("tags")
        .collection("mental_tags");
    CollectionReference refFood = cloudDb
        .collection('users')
        .document(user.uid)
        .collection("user_data")
        .document("tags")
        .collection("food_tags");
    CollectionReference refProductivity = cloudDb
        .collection('users')
        .document(user.uid)
        .collection("user_data")
        .document("tags")
        .collection("productivity_tags");
    CollectionReference refRelationship = cloudDb
        .collection('users')
        .document(user.uid)
        .collection("user_data")
        .document("tags")
        .collection("relationship_tags");
    CollectionReference refCareer = cloudDb
        .collection('users')
        .document(user.uid)
        .collection("user_data")
        .document("tags")
        .collection("career_tags");
    CollectionReference refFinance = cloudDb
        .collection('users')
        .document(user.uid)
        .collection("user_data")
        .document("tags")
        .collection("finance_tags");

    fitnessTags.forEach((element) {
      refFitness
          .document(element.id.toString())
          .setData(element.toMap())
          .then((value) => print(""));
    });
    mindfulTags.forEach((element) {
      refMind
          .document(element.id.toString())
          .setData(element.toMap())
          .then((value) => print(""));
    });
    foodTags.forEach((element) {
      refFood
          .document(element.id.toString())
          .setData(element.toMap())
          .then((value) => print(""));
    });
    productivityTags.forEach((element) {
      refProductivity
          .document(element.id.toString())
          .setData(element.toMap())
          .then((value) => print(""));
    });
    relationshipTags.forEach((element) {
      refRelationship
          .document(element.id.toString())
          .setData(element.toMap())
          .then((value) => print(""));
    });
    careerTags.forEach((element) {
      refCareer
          .document(element.id.toString())
          .setData(element.toMap())
          .then((value) => print(""));
    });
    financeTags.forEach((element) {
      refFinance
          .document(element.id.toString())
          .setData(element.toMap())
          .then((value) => print(""));
    });
    return true;
  }
}
