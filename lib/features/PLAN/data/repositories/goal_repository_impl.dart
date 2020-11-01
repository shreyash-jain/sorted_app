import 'dart:io';
import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:dartz/dartz_streaming.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/database/datasources/attachments_sources/attachments_cloud_data_source.dart';
import 'package:sorted/core/global/database/datasources/attachments_sources/attachments_native_data_source.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/models/image.dart';
import 'package:sorted/core/network/network_info.dart';

import 'package:sorted/features/HOME/data/datasources/home_cloud_data_source.dart';
import 'package:sorted/features/HOME/data/datasources/home_native_data_source.dart';
import 'package:sorted/features/HOME/data/datasources/home_remote_api_data_source.dart';
import 'package:sorted/features/HOME/data/datasources/home_shared_pref_data_source.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/data/models/inspiration.dart';
import 'package:sorted/features/HOME/data/models/placeholder_info.dart' as ph;
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:sorted/features/HOME/domain/entities/display_thumbnail.dart';
import 'package:sorted/features/HOME/domain/entities/unsplash_image.dart';
import 'package:sorted/features/HOME/domain/repositories/home_repository.dart';
import 'package:sorted/features/PLAN/data/datasources/goal_sources/goal_cloud_data_source.dart';
import 'package:sorted/features/PLAN/data/datasources/goal_sources/goal_native_data_source.dart';
import 'package:sorted/features/PLAN/data/datasources/goal_sources/goal_shared_pref_data_source.dart';
import 'package:sorted/features/PLAN/data/datasources/task_sources/task_cloud_data_source.dart';
import 'package:sorted/features/PLAN/data/datasources/task_sources/task_native_data_source.dart';
import 'package:sorted/features/PLAN/data/models/goal.dart';
import 'package:sorted/features/PLAN/data/models/task_status.dart';
import 'package:sorted/features/PLAN/domain/repositories/goal_repository.dart';

class GoalRepositoryImpl implements GoalRepository {
  final TaskCloud remoteTaskDataSource;
  final TaskNative nativeTaskDataSource;
  final GoalSharedPref sharedPrefGoal;
  final NetworkInfo networkInfo;
  final GoalCloud remoteGoalDataSource;
  final GoalNative nativeGoalDataSource;
  final AttachmentsCloud remoteAttachmentDataSource;
  final AttachmentsNative nativeAttachmentDataSource;

  final _random = new Random();

  GoalRepositoryImpl(
      {@required this.remoteTaskDataSource,
      @required this.nativeTaskDataSource,
      @required this.networkInfo,
      @required this.sharedPrefGoal,
      @required this.nativeGoalDataSource,
      @required this.remoteAttachmentDataSource,
      @required this.nativeAttachmentDataSource,
      @required this.remoteGoalDataSource});

  @override
  Future<Either<Failure, GoalModel>> addGoal(GoalModel goal) async {
    try {
      await nativeGoalDataSource.addGoal(goal);
      try {
        remoteGoalDataSource.addGoal(goal);
      } on Exception {
        return Left(ServerFailure());
      }

      return Right(goal);
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, List<GoalModel>>> getGoals() async {
    Failure failure;
    try {
      return (Right(await nativeGoalDataSource.getAllGoals()));
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, void>> removeGoal(GoalModel goal) {
    // TODO: implement removeGoal
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<String>>> getGradientUrls() async {
    try {
      return Right(await remoteGoalDataSource.getGradientImages());
    } on Exception {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<String>>> getInspireUrls() async {
    try {
      return Right(await remoteGoalDataSource.getInspireImages());
    } on Exception {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<String>>> getStudyUrls() async {
    try {
      return Right(await remoteGoalDataSource.getStudiesImages());
    } on Exception {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<String>>> getWorkUrls() async {
    try {
      return Right(await remoteGoalDataSource.getWorkImages());
    } on Exception {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, GoalModel>> updateGoal(GoalModel goal) async {
    try {
      await nativeGoalDataSource.updateGoal(goal);
      try {
        remoteGoalDataSource.updateGoal(goal);
        return Right(goal);
      } on Exception {
        return Left(ServerFailure());
      }
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, List<UnsplashImage>>> getSearchImages(
      String search) async {
    try {
      return Right(await remoteGoalDataSource.getSearchImages(search));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, ImageModel>> storeImage(ImageModel image, File file) async {
    try {
       return Right(await remoteAttachmentDataSource.storeImage(file, "images", image));
     
    } catch (e) {
      Left(ServerFailure());
    }
  }
}
