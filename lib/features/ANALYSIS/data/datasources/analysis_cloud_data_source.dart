import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:meta/meta.dart';

import 'package:sorted/core/global/database/sqflite_init.dart';

import 'package:sqflite/sqflite.dart';

abstract class AnalysisCloud {
  
}

class AnalysisCloudDataSourceImpl implements AnalysisCloud {
  final FirebaseFirestore cloudDb;
  final FirebaseAuth auth;
  final SqlDatabaseService nativeDb;
  Batch batch;

  AnalysisCloudDataSourceImpl(
      {@required this.cloudDb, @required this.auth, @required this.nativeDb});

  /// Gets a random inspiration from cloud
  ///
  ///
  
}
