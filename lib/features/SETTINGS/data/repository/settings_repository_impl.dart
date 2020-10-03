import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:dartz/dartz_streaming.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/network/network_info.dart';
import 'package:sorted/features/SETTINGS/data/datasources/settings_cloud_data_source.dart';
import 'package:sorted/features/SETTINGS/data/datasources/settings_native_data_source.dart';
import 'package:sorted/features/SETTINGS/data/datasources/settings_shared_pref_data_source.dart';
import 'package:sorted/features/SETTINGS/data/models/settings_details.dart';
import 'package:sorted/features/SETTINGS/domain/repository/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsCloud remoteDataSource;
  final SettingsNative nativeDataSource;
  final SettingsSharedPref sharedPref;
  final NetworkInfo networkInfo;

  final _random = new Random();

  SettingsRepositoryImpl(
      {@required this.remoteDataSource,
      @required this.nativeDataSource,
      @required this.sharedPref,
      @required this.networkInfo});

  @override
  Future<Either<Failure, SettingsDetails>> get settingsDetail async {
    SettingsDetails details;
    try {
      details = await nativeDataSource.getSettings();
      return Right(details);
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, void>> updateSettingsDetails(
      SettingsDetails details) async {
    Failure failure;
    try {
      await nativeDataSource.updateSettings(details);
      try {
        remoteDataSource.addSettings(details);
        return Right(null);
      } on Exception {
        failure = ServerFailure();

        return Left(failure);
      }
    } on Exception {
      failure = NativeDatabaseException();
      return Left(failure);
    }
  }
}
