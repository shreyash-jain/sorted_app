import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:sorted/core/authentication/auth_cloud_data_source.dart';
import 'package:sorted/core/authentication/auth_native_data_source.dart';

import 'package:sorted/core/network/network_info.dart';
import 'package:sorted/features/PLANNER/data/models/activity.dart';
import 'package:sorted/features/PLANNER/domain/entities/entities/elastic_activity_response_parser.dart';
import 'package:sorted/features/PLANNER/domain/entities/entities/filter_query.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/diet_summary.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/diet_settings.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/diet_log.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/activity_summary.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/activity_settings.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/activity_log.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_user_settings.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_property_settings.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_log.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_details.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_summary.dart';
import 'package:sorted/features/TRACKERS/PERMORMANCE/data/datasources/elastic_cloud_data_source.dart';

import 'package:sorted/features/TRACKERS/PERMORMANCE/domain/repositories/performance_repository.dart';

import 'package:sorted/features/USER_INTRODUCTION/data/datasources/user_intro_cloud_data_source.dart';
import 'package:sorted/features/USER_INTRODUCTION/data/datasources/user_intro_native_data_source.dart';
import 'package:sorted/features/USER_INTRODUCTION/data/datasources/user_intro_shared_pref_data_source.dart';

import '../../../../../core/error/failures.dart';

import '../datasources/performance_cloud_data_source.dart';

class PerformanceRepositoryImpl implements PerformanceRepository {
  final UserIntroCloud remoteDataSource;
  final UserIntroNative nativeDataSource;
  final UserIntroductionSharedPref sharedPref;
  final AuthCloudDataSource remoteAuth;
  final AuthNativeDataSource nativeAuth;
  final PerformanceCloud cloudDataSource;
  final ElasticRemoteApi elasticRemoteApi;
  final NetworkInfo networkInfo;

  PerformanceRepositoryImpl({
    @required this.elasticRemoteApi,
    @required this.remoteDataSource,
    @required this.nativeDataSource,
    @required this.sharedPref,
    @required this.networkInfo,
    @required this.nativeAuth,
    @required this.remoteAuth,
    @required this.cloudDataSource,
  });

  @override
  Future<Either<Failure, void>> addTrackToRecentSearchs(
      {int id, String name, String icon}) {}

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getLeaderboardData() {
    // TODO: implement getLeaderboardData
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, int>> addTrackLog(TrackLog log) async {
    if (await networkInfo.isConnected) {
      try {
        return (Right(await cloudDataSource.addTrackLog(log)));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, List<List<TrackLog>>>> getPast3MonthTrackLogs(
      int track_id, int property_id) async {
    if (await networkInfo.isConnected) {
      try {
        return (Right(await cloudDataSource.getPast3MonthTrackLogs(
            track_id, property_id)));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, TrackPropertySettings>> getPropertySettings(
      int property_id, int track_id) async {
    if (await networkInfo.isConnected) {
      try {
        return (Right(
            await cloudDataSource.getPropertySettings(property_id, track_id)));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, TrackUserSettings>> getTrackSettings(int id) async {
    if (await networkInfo.isConnected) {
      try {
        return (Right(await cloudDataSource.getTrackSettings(id)));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, TrackSummary>> getTrackSummary(int id) async {
    if (await networkInfo.isConnected) {
      try {
        return (Right(await cloudDataSource.getTrackSummary(id)));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, UserTracks>> getUserTracks() async {
    if (await networkInfo.isConnected) {
      try {
        return (Right(await cloudDataSource.getUserTracks()));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, int>> setPropertySettings(
      TrackPropertySettings setting) async {
    if (await networkInfo.isConnected) {
      try {
        return (Right(await cloudDataSource.setPropertySettings(setting)));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, int>> setTrackSettings(
      TrackUserSettings setting) async {
    if (await networkInfo.isConnected) {
      try {
        return (Right(await cloudDataSource.setTrackSettings(setting)));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, int>> setTrackSummary(TrackSummary summary) async {
    if (await networkInfo.isConnected) {
      try {
        return (Right(await cloudDataSource.setTrackSummary(summary)));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, int>> setUserTrack(UserTracks setting) async {
    if (await networkInfo.isConnected) {
      try {
        return (Right(await cloudDataSource.setUserTrack(setting)));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, int>> addActivityLog(ActivityLog log) async {
    if (await networkInfo.isConnected) {
      try {
        return (Right(await cloudDataSource.addActivityLog(log)));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, int>> addDietLog(DietLog log) async {
    if (await networkInfo.isConnected) {
      try {
        return (Right(await cloudDataSource.addDietLog(log)));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, ActivityLogSummary>> getActivityLogSummary() async {
    if (await networkInfo.isConnected) {
      try {
        return (Right(await cloudDataSource.getActivityLogSummary()));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, DietLogSummary>> getDietLogSummary() async {
    if (await networkInfo.isConnected) {
      try {
        return (Right(await cloudDataSource.getDietLogSummary()));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, List<List<ActivityLog>>>>
      getPast3MonthActivityLogs() async {
    if (await networkInfo.isConnected) {
      try {
        return (Right(await cloudDataSource.getPast3MonthActivityLogs()));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, List<List<DietLog>>>> getPast3MonthDietLogs() async {
    if (await networkInfo.isConnected) {
      try {
        return (Right(await cloudDataSource.getPast3MonthDietLogs()));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, int>> setActivityLogSettings(
      ActivityLogSettings setting) async {
    if (await networkInfo.isConnected) {
      try {
        return (Right(await cloudDataSource.setActivityLogSettings(setting)));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, ActivityLogSettings>> getActivityLogSettings() async {
    if (await networkInfo.isConnected) {
      try {
        return (Right(await cloudDataSource.getActivityLogSettings()));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, int>> setActivitySummary(
      ActivityLogSummary summary) async {
    if (await networkInfo.isConnected) {
      try {
        return (Right(await cloudDataSource.setActivitySummary(summary)));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, int>> setDietLogSettings(
      DietLogSettings setting) async {
    if (await networkInfo.isConnected) {
      try {
        return (Right(await cloudDataSource.setDietLogSettings(setting)));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, DietLogSettings>> getDietLogSettings() async {
    if (await networkInfo.isConnected) {
      try {
        return (Right(await cloudDataSource.getDietLogSettings()));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, int>> setDietSummary(
      ActivityLogSummary summary) async {
    if (await networkInfo.isConnected) {
      try {
        return (Right(await cloudDataSource.setDietSummary(summary)));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, List<ActivityModel>>> getSearchActivities(
      List<FilterQuery> filters) async {
    if (await networkInfo.isConnected) {
      try {
        List<ActivityHits> hits =
            await elasticRemoteApi.getArticlesSearchResults(filters);
        List<ActivityModel> items = [];
        hits.forEach((element) {
          items.add(ActivityModel.fromActivityModel(element.activity));
        });

        return (Right(items));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, ActivityModel>> getActivityById(int activityId) async {
    if (await networkInfo.isConnected) {
      try {
        ActivityModel activity =
            await cloudDataSource.getActivityById(activityId);

        return (Right(activity));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }
}
