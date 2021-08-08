import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:sorted/core/authentication/auth_cloud_data_source.dart';
import 'package:sorted/core/authentication/auth_native_data_source.dart';

import 'package:sorted/core/global/models/health_profile.dart';

import 'package:sorted/core/global/models/user_details.dart';
import 'package:sorted/core/network/network_info.dart';


import 'package:sorted/features/USER_INTRODUCTION/data/datasources/user_intro_cloud_data_source.dart';
import 'package:sorted/features/USER_INTRODUCTION/data/datasources/user_intro_native_data_source.dart';
import 'package:sorted/features/USER_INTRODUCTION/data/datasources/user_intro_shared_pref_data_source.dart';
import 'package:sorted/features/USER_INTRODUCTION/data/models/user_tag.dart';
import 'package:sorted/features/USER_INTRODUCTION/domain/repositories/user_intro_repository.dart';

import '../../../../core/error/failures.dart';

class UserIntroRepositoryImpl implements UserIntroductionRepository {
  final UserIntroCloud remoteDataSource;
  final UserIntroNative nativeDataSource;
  final UserIntroductionSharedPref sharedPref;
  final AuthCloudDataSource remoteAuth;
  final AuthNativeDataSource nativeAuth;

  final NetworkInfo networkInfo;

  UserIntroRepositoryImpl(
      {@required this.remoteDataSource,
      @required this.nativeDataSource,
      @required this.sharedPref,
      @required this.networkInfo,
      @required this.nativeAuth,
      @required this.remoteAuth});

  @override
  Future<Either<Failure, Stream<double>>> doInitialDownload() async {
    var failureOrBool = await oldUserState;
    Either<Failure, Stream<double>> result;
    await failureOrBool.fold((l) async {
      result = Left(l);
    }, (r) async {
      if (!(await networkInfo.isConnected)) {
        return Left(NetworkFailure());
      }
      if (r) {
        result = Right(remoteDataSource.getUserCloudData());
        print("old download");
      } else {
        result = Right(remoteDataSource.copyToUserCloudData());
        print("new download");
      }
    });
    print("doInitialDownload " + result.toString());
    return result;
  }

  @override
  Future<Either<Failure, bool>> get oldUserState async {
    try {
      return Right(await sharedPref.oldUserState());
    } on Exception {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, String>> get userName async {
    try {
      return Right(await sharedPref.userName());
    } on Exception {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> update(UserDetail detail) async {
    try {
      await nativeAuth.add(detail);
      try {
        remoteAuth.updateUserInCloud(detail);
      } on Exception {
        print("server exception");
      }
      return Right(true);
    } on Exception {
      return Future.value(Left(NativeDatabaseException()));
    }
  }

  @override
  Future<Either<Failure, UserDetail>> get userDetails async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await remoteAuth.getUserFromCloud());
      } on Exception {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> addUser(UserDetail detail) async {
    print(addUser);
    try {
      await nativeAuth.add(detail);
      try {
        print("coming to cloud");
        remoteAuth.addUserDetailInCloud(detail);
      } on Exception {
        print("failing cloud");
        print("server exception");
      }
      return Right(true);
    } on Exception {
      print("failing sql");
      return Future.value(Left(NativeDatabaseException()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUserActivityTable() async {
    try {
      await nativeDataSource.deleteUserActivityTable();
      try {
        await remoteDataSource.deleteUserActivityTable();
        return Right(null);
      } on Exception {
        print("server exception");
        return Right(null);
      }
    } on Exception {
      return Future.value(Left(NativeDatabaseException()));
    }
  }

  @override
  Future<Either<Failure, UserDetail>> getUserDetailsNative() async {
    UserDetail details;
    try {
      details = await nativeAuth.getUserDetail();
      return Right(details);
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, bool>> isUserNameAvailable(String username) async {
    bool result;
    try {
      result = await remoteDataSource.isUserNameAvailable(username);
      return Right(result);
    } on Exception {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> saveHealthProfile(
    HealthProfile lifestyleProfile,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await remoteDataSource.saveHealthProfile(
          lifestyleProfile,
        ));
      } on Exception {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, HealthProfile>> getHealthProfile() async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await remoteDataSource.getHealthProfile());
      } on Exception {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
