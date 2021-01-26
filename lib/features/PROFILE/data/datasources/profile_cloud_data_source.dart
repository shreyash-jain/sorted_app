import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:sorted/core/global/database/sqflite_init.dart';
import 'package:sorted/core/global/models/lifestyle_profile.dart';
import 'package:sorted/core/global/models/mental_health_profile.dart';
import 'package:sorted/core/global/models/physical_health_profile.dart';

abstract class ProfileCloud {
  Future<PhysicalHealthProfile> get fitnessProfile;
  Future<MentalHealthProfile> get mindfulProfile;
  Future<LifestyleProfile> get lifestyleProfile;
}

class ProfileCloudDataSourceImpl implements ProfileCloud {
  final Firestore cloudDb;
  final FirebaseAuth auth;
  final SqlDatabaseService nativeDb;

  ProfileCloudDataSourceImpl(
      {@required this.auth, @required this.nativeDb, @required this.cloudDb});

  @override
  // TODO: implement fitnessProfile
  Future<PhysicalHealthProfile> get fitnessProfile async {
    FirebaseUser user = await auth.currentUser();
    int ans = 0;
    DocumentReference document = cloudDb
        .collection('users')
        .document(user.uid)
        .collection("user_data")
        .document("fitness_profile");

    DocumentSnapshot fitnessDoc = await document.get();

    return PhysicalHealthProfile.fromSnapshot(fitnessDoc);
  }

  @override
  // TODO: implement lifestyleProfile
  Future<LifestyleProfile> get lifestyleProfile async {
    FirebaseUser user = await auth.currentUser();
    int ans = 0;
    DocumentReference document = cloudDb
        .collection('users')
        .document(user.uid)
        .collection("user_data")
        .document("lifestyle_profile");

    DocumentSnapshot fitnessDoc = await document.get();

    return LifestyleProfile.fromSnapshot(fitnessDoc);
  }

  @override
  // TODO: implement mindfulProfile
  Future<MentalHealthProfile> get mindfulProfile async {
    FirebaseUser user = await auth.currentUser();
    int ans = 0;
    DocumentReference document = cloudDb
        .collection('users')
        .document(user.uid)
        .collection("user_data")
        .document("lifestyle_profile");

    DocumentSnapshot fitnessDoc = await document.get();

    return MentalHealthProfile.fromSnapshot(fitnessDoc);
  }
}
