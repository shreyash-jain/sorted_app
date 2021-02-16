import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:meta/meta.dart';

import 'package:sorted/core/global/database/sqflite_init.dart';


abstract class TrackStoreCloud {
 
}

class TrackStoreCloudDataSourceImpl implements TrackStoreCloud {
  final FirebaseFirestore cloudDb;
  final FirebaseAuth auth;
  final SqlDatabaseService nativeDb;

  TrackStoreCloudDataSourceImpl(
      {@required this.cloudDb, @required this.auth, @required this.nativeDb});


}
