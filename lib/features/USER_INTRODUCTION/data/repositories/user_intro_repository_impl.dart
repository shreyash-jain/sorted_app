import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:sorted/core/authentication/auth_cloud_data_source.dart';
import 'package:sorted/core/authentication/auth_native_data_source.dart';
import 'package:sorted/core/global/models/user_details.dart';
import 'package:sorted/core/network/network_info.dart';
import 'package:sorted/features/PROFILE/data/models/user_activity.dart';
import 'package:sorted/features/PROFILE/data/models/activity.dart';
import 'package:sorted/features/USER_INTRODUCTION/data/datasources/user_intro_cloud_data_source.dart';
import 'package:sorted/features/USER_INTRODUCTION/data/datasources/user_intro_native_data_source.dart';
import 'package:sorted/features/USER_INTRODUCTION/data/datasources/user_intro_shared_pref_data_source.dart';
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
  Future<Either<Failure, int>> add(UserAModel activity) async {
    UserAModel thisActivity=activity;
    try {
      thisActivity = await nativeDataSource.add(activity);
      try {
        remoteDataSource.add(thisActivity);
      } on Exception {
        print("server exception");
      }
      return Right(thisActivity.id);
    } on Exception {
      return Future.value(Left(NativeDatabaseException()));
    }
  }

  @override
  Future<Either<Failure, List<ActivityModel>>> get cloudActivities async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await remoteDataSource.allActivities);
      } on Exception {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> delete(UserAModel activity) async {
    try {
      await nativeDataSource.delete(activity);
      try {
        remoteDataSource.delete(activity);
        return Right(true);
      } on Exception {
        print("server exception");
        return Right(false);
      }
    } on Exception {
      return Future.value(Left(NativeDatabaseException()));
    }
  }

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
      if (r)
        result = Right(remoteDataSource.getUserCloudData());
      else
        result = Right(remoteDataSource.copyToUserCloudData());
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
  Future<Either<Failure, List<UserAModel>>> get userActivities async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await remoteDataSource.userActivities);
      } on Exception {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
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
    try {
      await nativeAuth.add(detail);
      try {
        remoteAuth.addUserDetailInCloud(detail);
      } on Exception {
        print("server exception");
      }
      return Right(true);
    } on Exception {
      return Future.value(Left(NativeDatabaseException()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUserActivityTable() async {
    try {
      await nativeDataSource.deleteUserActivityTable();
      try {
        remoteDataSource.deleteUserActivityTable();
        return Right(null);
      } on Exception {
        print("server exception");
        return Right(null);
      }
    } on Exception {
      return Future.value(Left(NativeDatabaseException()));
    }
  }
}
