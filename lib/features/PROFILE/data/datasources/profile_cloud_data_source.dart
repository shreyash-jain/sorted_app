import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:sorted/core/global/database/sqflite_init.dart';
import 'package:sorted/core/global/models/health_profile.dart';



abstract class ProfileCloud {
  Future<HealthProfile> get fitnessProfile;




}

class ProfileCloudDataSourceImpl implements ProfileCloud {
  ProfileCloudDataSourceImpl(
      {@required this.auth, @required this.nativeDb, @required this.cloudDb});

  final FirebaseAuth auth;
  final FirebaseFirestore cloudDb;
  final SqlDatabaseService nativeDb;

  @override

  Future<HealthProfile> get fitnessProfile async {
    User user = auth.currentUser;
    int ans = 0;
    DocumentReference doc = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection("user_data")
        .doc("fitness_profile");

    DocumentSnapshot fitnessDoc = await doc.get();

    return HealthProfile.fromMap(fitnessDoc.data() as Map);
  }

  
}
