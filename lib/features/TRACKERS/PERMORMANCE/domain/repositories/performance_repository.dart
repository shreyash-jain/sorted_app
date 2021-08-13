import 'package:dartz/dartz.dart';

import 'package:sorted/core/error/failures.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/activity_log.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/activity_settings.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/activity_summary.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/diet_log.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/diet_settings.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/diet_summary.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_summary.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_details.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_log.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_property_settings.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_user_settings.dart';

abstract class PerformanceRepository {
  Future<Either<Failure, void>> addTrackToRecentSearchs({
    int id,
    String name,
    String icon,
  });

  Future<Either<Failure, UserTracks>> getUserTracks();
  Future<Either<Failure, TrackUserSettings>> getTrackSettings(int id);
  Future<Either<Failure, int>> setTrackSettings(TrackUserSettings setting);
  Future<Either<Failure, int>> setUserTrack(UserTracks setting);
  Future<Either<Failure, List<Map<String, dynamic>>>> getLeaderboardData();
  Future<Either<Failure, int>> addTrackLog(TrackLog log);
  Future<Either<Failure, TrackSummary>> getTrackSummary(int id);
  Future<Either<Failure, int>> setTrackSummary(TrackSummary summary);
  Future<Either<Failure, List<List<TrackLog>>>> getPast3MonthTrackLogs(
      int track_id, int property_id);
  Future<Either<Failure, TrackPropertySettings>> getPropertySettings(
      int property_id, int track_id);
  Future<Either<Failure, int>> setPropertySettings(
      TrackPropertySettings setting);

  //Actvities and Diet Log

  Future<Either<Failure, int>> setActivitySummary(ActivityLogSummary summary);
  Future<Either<Failure, int>> setDietSummary(ActivityLogSummary summary);
  Future<Either<Failure, int>> setActivityLogSettings(
      ActivityLogSettings setting);
  Future<Either<Failure, int>> setDietLogSettings(DietLogSettings setting);

  Future<Either<Failure, int>> addActivityLog(ActivityLog log);
  Future<Either<Failure, int>> addDietLog(DietLog log);

  Future<Either<Failure, DietLogSummary>> getDietLogSummary();
  Future<Either<Failure, ActivityLogSummary>> getActivityLogSummary();
  Future<Either<Failure, ActivityLogSettings>> getActivityLogSettings();
  Future<Either<Failure, DietLogSettings>> getDietLogSettings();

  Future<Either<Failure, List<List<ActivityLog>>>> getPast3MonthActivityLogs();
  Future<Either<Failure, List<List<DietLog>>>> getPast3MonthDietLogs();
}
