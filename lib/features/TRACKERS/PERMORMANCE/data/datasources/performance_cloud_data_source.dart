import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:meta/meta.dart';

import 'package:sorted/core/global/database/sqflite_init.dart';
import 'package:sorted/core/global/models/log.dart';
import 'package:sorted/features/PLANNER/data/models/activity.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/activity_log.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/activity_settings.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/activity_summary.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/diet_log.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/diet_settings.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/diet_summary.dart';

import 'package:sorted/features/TRACKERS/COMMON/models/track_summary.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_details.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_log.dart';

import 'package:sorted/features/TRACKERS/COMMON/models/track_model.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_property_model.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_goal_model.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_property_settings.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_user_settings.dart';

const String TRACKS_COLLECTION_PATH = 'tracking/tracks/data';
const String MARKET_BANNERS_COLLECTION_PATH = 'Market/MarketBanners/Data';
const String MARKET_HEADINGS_COLLECTION_PATH = 'Market/MarketHeadings/Data';
const String MARKET_TABS_COLLECTION_PATH = 'Market/MarketTabs/Data';
const String TRACK_LOG_MULTIFILL_COLLECTION_PATH = '/visulization/heatmap/data';
const String LEADERBOARD_COLLECTION_PATH =
    '/tracking/tracks/data/1/leaderboard';
const String COLOSSALS_COLLECTION_NAME = "colossals";
const String COMMENTS_COLLECTION_NAME = "comments";
const String COLOSSAL_URL_FIELD = "url";
const String COMMENTS_SENTIMENT_VALUE_FIELD = "sentiment_value";
const ID_FIELD = 'id';
const TRACK_NAME_FIELD = "name";
const SUB_USERS_COLLECTION = "sub_users";
const String UID_FIELD = "uid";

abstract class PerformanceCloud {
  Future<int> addTrackLog(TrackLog log);

  Future<List<List<TrackLog>>> getPast3MonthTrackLogs(
      int track_id, int property_id);

  Future<UserTracks> getUserTracks();

  Future<TrackPropertySettings> getPropertySettings(
      int property_id, int track_id);

  Future<TrackUserSettings> getTrackSettings(int id);

  Future<TrackSummary> getTrackSummary(int id);

  Future<int> setPropertySettings(TrackPropertySettings setting);

  Future<int> setTrackSettings(TrackUserSettings setting);

  Future<int> setTrackSummary(TrackSummary summary);

  Future<int> setUserTrack(UserTracks setting);

  Future<int> addActivityLog(ActivityLog log);

  Future<int> addDietLog(DietLog log);

  Future<ActivityLogSummary> getActivityLogSummary();

  Future<DietLogSummary> getDietLogSummary();

  Future<List<List<ActivityLog>>> getPast3MonthActivityLogs();

  Future<List<List<DietLog>>> getPast3MonthDietLogs();

  Future<int> setActivityLogSettings(ActivityLogSettings setting);

  Future<int> setActivitySummary(ActivityLogSummary summary);

  Future<int> setDietLogSettings(DietLogSettings setting);

  Future<int> setDietSummary(DietLogSummary summary);

  Future<ActivityLogSettings> getActivityLogSettings();

  Future<DietLogSettings> getDietLogSettings();

  Future<ActivityModel> getActivityById(int activityId);
}

class PerformanceCloudDataSourceImpl implements PerformanceCloud {
  final FirebaseFirestore cloudDb;
  final FirebaseAuth auth;
  final SqlDatabaseService nativeDb;

  PerformanceCloudDataSourceImpl({
    @required this.cloudDb,
    @required this.auth,
    @required this.nativeDb,
  });

  DocumentSnapshot lastCommentDoc;

  @override
  Future<int> addTrackLog(TrackLog log) async {
    var user = auth.currentUser;

    var logTime = log.time;
    var logMonthId =
        "m" + logTime.month.toString() + "y" + logTime.year.toString();
    var list = [log.toMap()];
    var result = cloudDb
        .collection(
            'users/${user.uid}/performance_data/${log.track_id}/properties/${log.property_id}/logs')
        .doc(logMonthId)
        .set({"data": FieldValue.arrayUnion(list)}, SetOptions(merge: true));

    return 1;
  }

  @override
  Future<List<List<TrackLog>>> getPast3MonthTrackLogs(
      int track_id, int property_id) async {
    var now = DateTime.now();
    var thisMonth = DateTime(now.year, now.month, now.day, 1, 0);
    var currentMonthId =
        "m" + thisMonth.month.toString() + "y" + thisMonth.year.toString();
    var prevMonth =
        new DateTime(thisMonth.year, thisMonth.month - 1, thisMonth.day);
    var prevMonthId =
        "m" + prevMonth.month.toString() + "y" + prevMonth.year.toString();
    var prev1Month =
        new DateTime(prevMonth.year, prevMonth.month - 1, prevMonth.day);
    var prev1MonthId =
        "m" + prev1Month.month.toString() + "y" + prev1Month.year.toString();

    try {
      List responses = await Future.wait([
        getLogsFromDocument(currentMonthId, track_id, property_id),
        getLogsFromDocument(prevMonthId, track_id, property_id),
        getLogsFromDocument(prev1MonthId, track_id, property_id)
      ]);

      print("t here fromSnapshot   " + responses.toString());

      return responses.map((e) => e as List<TrackLog>).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<TrackLog>> getLogsFromDocument(
      String id, int track_id, int property_id) async {
    var user = auth.currentUser;

    var result = await FirebaseFirestore.instance
        .collection(
            'users/${user.uid}/performance_data/$track_id/properties/$property_id/logs')
        .doc(id)
        .get();

    if (result != null && result.exists) {
      return List<TrackLog>.from((result.data() as Map)['data'].map((i) {
            var z = Map<String, dynamic>.from(i);
            print("t here fromSnapshot $z");

            return TrackLog.fromMap(z) ?? TrackLog();
          }) ??
          const []);
    } else
      return [];
  }

  @override
  Future<TrackPropertySettings> getPropertySettings(
      int property_id, int track_id) async {
    var user = auth.currentUser;
    var snapShot = await cloudDb
        .collection('users/${user.uid}/performance_data/$track_id/properties')
        .doc(property_id.toString())
        .get();
    if (snapShot == null || !snapShot.exists)
      return Future.value(TrackPropertySettings());

    return TrackPropertySettings.fromMap(snapShot.data() as Map);
  }

  @override
  Future<TrackUserSettings> getTrackSettings(int id) async {
    var user = auth.currentUser;
    var snapShot = await cloudDb
        .collection('users/${user.uid}/performance_data/$id/trackSettings')
        .doc('data')
        .get();
    if (snapShot == null || !snapShot.exists)
      return Future.value(TrackUserSettings());

    return TrackUserSettings.fromMap(snapShot.data() as Map);
  }

  @override
  Future<TrackSummary> getTrackSummary(int id) async {
    var user = auth.currentUser;

    var snapShot = await cloudDb
        .collection('users/${user.uid}/performance_data/$id/trackSummary')
        .doc('data')
        .get();
    if (snapShot == null || !snapShot.exists)
      return Future.value(TrackSummary());

    return TrackSummary.fromMap(snapShot.data() as Map);
  }

  @override
  Future<UserTracks> getUserTracks() async {
    var user = auth.currentUser;
    var snapShot = await cloudDb
        .collection('users/${user.uid}/performance_data/')
        .doc('subs')
        .get();
    if (snapShot == null || !snapShot.exists) return Future.value(UserTracks());

    return UserTracks.fromMap(snapShot.data() as Map);
  }

  @override
  Future<int> setPropertySettings(TrackPropertySettings setting) async {
    var user = auth.currentUser;
    var snapShot = cloudDb
        .collection(
            'users/${user.uid}/performance_data/${setting.track_id}/properties')
        .doc(setting.property_id.toString())
        .set(setting.toMap());
    return 1;
  }

  @override
  Future<int> setTrackSettings(TrackUserSettings setting) async {
    var user = auth.currentUser;
    var snapShot = await cloudDb
        .collection(
            'users/${user.uid}/performance_data/${setting.track_id}/trackSettings')
        .doc('data')
        .set(setting.toMap());
    return 1;
  }

  @override
  Future<int> setTrackSummary(TrackSummary summary) async {
    var user = auth.currentUser;

    var snapShot = cloudDb
        .collection(
            'users/${user.uid}/performance_data/${summary.track_id}/trackSummary')
        .doc('data')
        .set(summary.toMap());
    return 1;
  }

  @override
  Future<int> setUserTrack(UserTracks setting) async {
    var user = auth.currentUser;

    var snapShot = await cloudDb
        .collection('users/${user.uid}/performance_data/')
        .doc('subs')
        .set(setting.toMap());
    return 1;
  }

  @override
  Future<int> addActivityLog(ActivityLog log) async {
    var user = auth.currentUser;

    var logTime = log.time;
    var logMonthId =
        "m" + logTime.month.toString() + "y" + logTime.year.toString();
    var list = [log.toMap()];
    var result = cloudDb
        .collection('users/${user.uid}/performance_data/2/properties/1/logs')
        .doc(logMonthId)
        .set({"data": FieldValue.arrayUnion(list)}, SetOptions(merge: true));

    return 1;
  }

  @override
  Future<int> addDietLog(DietLog log) async {
    var user = auth.currentUser;

    var logTime = log.time;
    var logMonthId =
        "m" + logTime.month.toString() + "y" + logTime.year.toString();
    var list = [log.toMap()];
    var result = cloudDb
        .collection('users/${user.uid}/performance_data/1/properties/1/logs')
        .doc(logMonthId)
        .set({"data": FieldValue.arrayUnion(list)}, SetOptions(merge: true));

    return 1;
  }

  @override
  Future<ActivityLogSettings> getActivityLogSettings() async {
    var user = auth.currentUser;
    var snapShot = await cloudDb
        .collection('users/${user.uid}/performance_data/2/trackSettings')
        .doc('data')
        .get();
    if (snapShot == null || !snapShot.exists)
      return Future.value(ActivityLogSettings());

    return ActivityLogSettings.fromMap(snapShot.data() as Map);
  }

  @override
  Future<ActivityLogSummary> getActivityLogSummary() async {
    var user = auth.currentUser;
    var snapShot = await cloudDb
        .collection('users/${user.uid}/performance_data/2/trackSummary')
        .doc('data')
        .get();
    if (snapShot == null || !snapShot.exists)
      return Future.value(ActivityLogSummary());

    return ActivityLogSummary.fromMap(snapShot.data() as Map);
  }

  @override
  Future<DietLogSettings> getDietLogSettings() async {
    var user = auth.currentUser;
    var snapShot = await cloudDb
        .collection('users/${user.uid}/performance_data/21/trackSettings')
        .doc('data')
        .get();
    if (snapShot == null || !snapShot.exists)
      return Future.value(DietLogSettings());

    return DietLogSettings.fromMap(snapShot.data() as Map);
  }

  @override
  Future<DietLogSummary> getDietLogSummary() async {
    var user = auth.currentUser;
    var snapShot = await cloudDb
        .collection('users/${user.uid}/performance_data/1/trackSummary')
        .doc('data')
        .get();
    if (snapShot == null || !snapShot.exists)
      return Future.value(DietLogSummary());

    return DietLogSummary.fromMap(snapShot.data() as Map);
  }

  @override
  Future<List<List<ActivityLog>>> getPast3MonthActivityLogs() async {
    var now = DateTime.now();
    var thisMonth = DateTime(now.year, now.month, now.day, 1, 0);
    var currentMonthId =
        "m" + thisMonth.month.toString() + "y" + thisMonth.year.toString();
    var prevMonth =
        new DateTime(thisMonth.year, thisMonth.month - 1, thisMonth.day);
    var prevMonthId =
        "m" + prevMonth.month.toString() + "y" + prevMonth.year.toString();
    var prev1Month =
        new DateTime(prevMonth.year, prevMonth.month - 1, prevMonth.day);
    var prev1MonthId =
        "m" + prev1Month.month.toString() + "y" + prev1Month.year.toString();

    try {
      List responses = await Future.wait([
        getActivityLogsFromDocument(currentMonthId),
        getActivityLogsFromDocument(prevMonthId),
        getActivityLogsFromDocument(prev1MonthId)
      ]);
      return responses.map((e) => e as List<ActivityLog>).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<List<DietLog>>> getPast3MonthDietLogs() async {
    var now = DateTime.now();
    var thisMonth = DateTime(now.year, now.month, now.day, 1, 0);
    var currentMonthId =
        "m" + thisMonth.month.toString() + "y" + thisMonth.year.toString();
    var prevMonth =
        new DateTime(thisMonth.year, thisMonth.month - 1, thisMonth.day);
    var prevMonthId =
        "m" + prevMonth.month.toString() + "y" + prevMonth.year.toString();
    var prev1Month =
        new DateTime(prevMonth.year, prevMonth.month - 1, prevMonth.day);
    var prev1MonthId =
        "m" + prev1Month.month.toString() + "y" + prev1Month.year.toString();

    try {
      List responses = await Future.wait([
        getDietLogsFromDocument(currentMonthId),
        getDietLogsFromDocument(prevMonthId),
        getDietLogsFromDocument(prev1MonthId)
      ]);
      return responses.map((e) => e as List<DietLog>).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<ActivityLog>> getActivityLogsFromDocument(String id) async {
    var user = auth.currentUser;

    var result = await FirebaseFirestore.instance
        .collection('users/${user.uid}/performance_data/2/properties/1/logs')
        .doc(id)
        .get();
    if (result != null && result.exists) {
      return List<ActivityLog>.from((result.data() as Map)['data'].map((i) {
            var z = Map<String, dynamic>.from(i);
            print("t here fromSnapshot $z");

            return ActivityLog.fromMap(z) ?? ActivityLog();
          }) ??
          const []);
    } else
      return [];
  }

  Future<List<DietLog>> getDietLogsFromDocument(String id) async {
    var user = auth.currentUser;
    var result = await FirebaseFirestore.instance
        .collection('users/${user.uid}/performance_data/1/properties/1/logs')
        .doc(id)
        .get();
    if (result != null && result.exists) {
      return List<DietLog>.from((result.data() as Map)['data'].map((i) {
            var z = Map<String, dynamic>.from(i);
            print("t here fromSnapshot $z");

            return DietLog.fromMap(z) ?? DietLog();
          }) ??
          const []);
    } else
      return [];
  }

  @override
  Future<int> setActivityLogSettings(ActivityLogSettings setting) async {
    var user = auth.currentUser;
    var snapShot = await cloudDb
        .collection('users/${user.uid}/performance_data/2/trackSettings')
        .doc('data')
        .set(setting.toMap());
    return 1;
  }

  @override
  Future<int> setActivitySummary(ActivityLogSummary summary) async {
    var user = auth.currentUser;

    var snapShot = cloudDb
        .collection('users/${user.uid}/performance_data/2/trackSummary')
        .doc('data')
        .set(summary.toMap());
    return 1;
  }

  @override
  Future<int> setDietLogSettings(DietLogSettings setting) async {
    var user = auth.currentUser;
    var snapShot = await cloudDb
        .collection('users/${user.uid}/performance_data/1/trackSettings')
        .doc('data')
        .set(setting.toMap());
    return 1;
  }

  @override
  Future<int> setDietSummary(DietLogSummary summary) async {
    var user = auth.currentUser;

    var snapShot = cloudDb
        .collection('users/${user.uid}/performance_data/1/trackSummary')
        .doc('data')
        .set(summary.toMap());
    return 1;
  }

  @override
  Future<ActivityModel> getActivityById(int activityId) async {
    var snapShot = await cloudDb
        .collection('ActivitiesDb/data/activities')
        .doc(activityId.toString())
        .get();

        
    if (snapShot != null) {
      return ActivityModel.fromSnapshot(snapShot);
    } else
      return Future.value(ActivityModel(id: -1));
  }
}
