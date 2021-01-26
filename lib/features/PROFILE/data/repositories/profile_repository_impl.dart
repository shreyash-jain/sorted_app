import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:sorted/core/global/models/lifestyle_profile.dart';
import 'package:sorted/core/global/models/mental_health_profile.dart';
import 'package:sorted/core/global/models/physical_health_profile.dart';
import 'package:sorted/core/network/network_info.dart';
import 'package:sorted/features/PROFILE/data/datasources/profile_cloud_data_source.dart';
import 'package:sorted/features/PROFILE/data/datasources/profile_native_data_source.dart';
import 'package:sorted/features/PROFILE/data/datasources/profile_shared_pref_data_source.dart';
import 'package:sorted/features/PROFILE/domain/repositories/profile_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileCloud remoteDataSource;
  final ProfileSharedPref localDataSource;
  final NetworkInfo networkInfo;
  final ProfileNative nativeDataSource;

  ProfileRepositoryImpl(
      {this.remoteDataSource,
      this.localDataSource,
      this.networkInfo,
      this.nativeDataSource});

  @override
  Future<Either<Failure, PhysicalHealthProfile>>
      getFitnessProfileFromCloud() async {
    try {
      return Right(await remoteDataSource.fitnessProfile);
    } on CacheException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, LifestyleProfile>> getLifestyleFromCloud() async {
    try {
      return Right(await remoteDataSource.lifestyleProfile);
    } on CacheException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, MentalHealthProfile>>
      getMindfulProfileFromCloud() async {
    try {
      return Right(await remoteDataSource.mindfulProfile);
    } on CacheException {
      return Left(ServerFailure());
    }
  }
}
