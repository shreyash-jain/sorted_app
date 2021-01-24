import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:sorted/core/authentication/auth_cloud_data_source.dart';
import 'package:sorted/core/authentication/auth_native_data_source.dart';
import 'package:sorted/core/global/models/addiction_condition.dart';
import 'package:sorted/core/global/models/health_condition.dart';
import 'package:sorted/core/global/models/lifestyle_profile.dart';
import 'package:sorted/core/global/models/mental_health_profile.dart';
import 'package:sorted/core/global/models/physical_health_profile.dart';
import 'package:sorted/core/global/models/user_details.dart';
import 'package:sorted/core/network/network_info.dart';
import 'package:sorted/features/PROFILE/data/models/user_activity.dart';
import 'package:sorted/features/PROFILE/data/models/activity.dart';
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
  Future<Either<Failure, int>> add(UserAModel activity) async {
    UserAModel thisActivity = activity;
    try {
      print(" add u activity " + thisActivity.name);
      thisActivity = await nativeDataSource.add(activity);
      print(thisActivity.id.toString() + "  " + thisActivity.name);
      try {
        remoteDataSource.add(thisActivity);
      } on Exception {
        print("server exception");
      }
      return Right(thisActivity.id);
    } on Exception {
      print("NativeDatabaseException  ");
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
  Future<Either<Failure, List<UserTag>>> getCareerTags() async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await remoteDataSource.getCareerTags());
      } on Exception {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserTag>>> getChildrenOfTag(
      UserTag tag, String category) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await remoteDataSource.getChildrenOfTag(tag, category));
      } on Exception {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserTag>>> getFamilyTags() async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await remoteDataSource.getFamilyTags());
      } on Exception {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserTag>>> getFinanceTags() async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await remoteDataSource.getFinanceTags());
      } on Exception {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserTag>>> getFitnessTags() async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await remoteDataSource.getFitnessTags());
      } on Exception {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserTag>>> getFoodTags() async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await remoteDataSource.getFoodTags());
      } on Exception {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserTag>>> getMentalHealthTags() async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await remoteDataSource.getMentalHealthTags());
      } on Exception {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserTag>>> getProductivityTags() async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await remoteDataSource.getProductivityTags());
      } on Exception {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> saveHealthProfile(
      PhysicalHealthProfile fitnessProfile,
      MentalHealthProfile mentalProfile,
      LifestyleProfile lifestyleProfile,
      HealthConditions healthConditions,
      AddictionConditions addictionConditions) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await remoteDataSource.saveHealthProfile(
            fitnessProfile,
            mentalProfile,
            lifestyleProfile,
            healthConditions,
            addictionConditions));
      } on Exception {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> saveUserInterests(
      List<UserTag> fitnessTags,
      List<UserTag> mindfulTags,
      List<UserTag> foodTags,
      List<UserTag> productivityTags,
      List<UserTag> relationshipTags,
      List<UserTag> careerTags,
      List<UserTag> financeTags) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await remoteDataSource.saveUserInterests(
            fitnessTags,
            mindfulTags,
            foodTags,
            productivityTags,
            relationshipTags,
            careerTags,
            financeTags));
      } on Exception {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
