import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:dartz/dartz_streaming.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/network/network_info.dart';
import 'package:sorted/features/ANALYSIS/data/datasources/analysis_cloud_data_source.dart';
import 'package:sorted/features/ANALYSIS/data/datasources/analysis_native_data_source.dart';
import 'package:sorted/features/ANALYSIS/data/datasources/analysis_remote_api_data_source.dart';
import 'package:sorted/features/ANALYSIS/data/datasources/analysis_shared_pref_data_source.dart';
import 'package:sorted/features/ANALYSIS/domain/repositories/analysis_repository.dart';



class AnalysisRepositoryImpl implements AnalysisRepository {
  final AnalysisCloud remoteDataSource;
  final  AnalysisNative nativeDataSource;
  final  AnalysisPref sharedPref;
  final NetworkInfo networkInfo;
  final  AnalysisRemoteApi remoteApi;

  final _random = new Random();

  AnalysisRepositoryImpl(
      {@required this.remoteApi,
      @required this.remoteDataSource,
      @required this.nativeDataSource,
      @required this.sharedPref,
      @required this.networkInfo});

  
}
