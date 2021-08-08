

import 'package:sorted/core/global/database/sqflite_init.dart';
import 'package:sorted/features/CONNECT/data/models/expert/expert_profile.dart';
import 'package:sorted/features/HOME/data/models/class_model.dart';

abstract class ConnectNativeDataSource {
  
  Future<List<ClassModel>> getExpertClasses();
}

class ConnectNativeDataSourceImpl implements ConnectNativeDataSource {
  final SqlDatabaseService nativeDb;

  ConnectNativeDataSourceImpl({this.nativeDb});

  @override
  Future<List<ClassModel>> getExpertClasses() {
    // TODO: implement getExpertClasses
    throw UnimplementedError();
  }

  



}
