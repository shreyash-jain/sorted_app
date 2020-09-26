import 'dart:math';

import 'package:meta/meta.dart';

import 'package:sorted/core/global/database/sqflite_init.dart';


abstract class AnalysisNative {
  
}

class AnalysisNativeDataSourceImpl implements AnalysisNative {
  final SqlDatabaseService nativeDb;

  AnalysisNativeDataSourceImpl({@required this.nativeDb});

 
}
