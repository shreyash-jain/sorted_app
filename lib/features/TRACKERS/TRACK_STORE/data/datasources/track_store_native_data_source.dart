import 'package:meta/meta.dart';
import 'package:sorted/core/global/database/sqflite_init.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_model.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_property_model.dart';
import 'package:sqflite/sqflite.dart';
import '../models/track_brief_model.dart';

String SEARCH_TABLE_NAME = "Track_Store_Search";
String TRACK_ID_FIELD = 'track_id';
String SUB_TRACKS_TABLE_NAME = "Sub_Tracks";
String TRACK_PROPERTIES_TABLE_NAME = "Track_Properties";
String ID_FIELD = "id";

abstract class TrackStoreNative {
  Future<List<TrackBriefModel>> getRecentSearchs();
  Future<void> addRecentSearch(TrackBriefModel track);
  Future<void> removeAllSearchs();
  Future<void> removeSearchByID(int id);
  Future<TrackModel> getTrackById(int track_id);
  Future<void> addTrack(TrackModel track);
  Future<void> addTrackProperties(List<TrackPropertyModel> trackProps);
  Future<List<TrackPropertyModel>> getTrackProperties(int track_id);
  Future<void> deleteTrack(int track_id);
  Future<void> deleteTrackProperties(int track_id);
  Future<void> updateTrack(TrackModel track);
}

class TrackStoreNativeDataSourceImpl implements TrackStoreNative {
  final SqlDatabaseService nativeDb;

  TrackStoreNativeDataSourceImpl({@required this.nativeDb});

  @override
  Future<List<TrackBriefModel>> getRecentSearchs() async {
    print('I am here !!!');
    Database db = await nativeDb.database;
    List<Map> data = await db.query(SEARCH_TABLE_NAME);
    print("DATA = " + data.toString());
    List<TrackBriefModel> tracks =
        data.map((t) => TrackBriefModel.fromMap(t)).toList();
    return tracks;
  }

  @override
  Future<void> addRecentSearch(TrackBriefModel track) async {
    Database db = await nativeDb.database;
    await db.insert(SEARCH_TABLE_NAME, track.toMap());
  }

  @override
  Future<void> removeAllSearchs() async {
    Database db = await nativeDb.database;
    await db.delete(SEARCH_TABLE_NAME, where: '1');
  }

  @override
  Future<void> removeSearchByID(int id) async {
    Database db = await nativeDb.database;
    await db.delete(SEARCH_TABLE_NAME,
        where: '$TRACK_ID_FIELD = ?', whereArgs: [id]);
  }

  @override
  Future<TrackModel> getTrackById(int track_id) async {
    Database db = await nativeDb.database;
    List<Map> data = await db.query(SUB_TRACKS_TABLE_NAME,
        where: '$ID_FIELD = ?', whereArgs: [track_id]);

    List<TrackModel> tracks = data.map((t) => TrackModel.fromMap(t)).toList();
    if (tracks.isEmpty) return null;
    return tracks[0];
  }

  @override
  Future<void> addTrack(TrackModel track) async {
    Database db = await nativeDb.database;
    await db.insert(SUB_TRACKS_TABLE_NAME, track.toMap());
    // await db.delete(SUB_TRACKS_TABLE_NAME, where: '1');
  }

  @override
  Future<void> addTrackProperties(List<TrackPropertyModel> trackProps) async {
    Database db = await nativeDb.database;
    trackProps.forEach((trackProp) async {
      await db.insert(TRACK_PROPERTIES_TABLE_NAME, trackProp.toMap());
    });
  }

  @override
  Future<List<TrackPropertyModel>> getTrackProperties(int track_id) async {
    Database db = await nativeDb.database;
    List<Map> data = await db.query(
      TRACK_PROPERTIES_TABLE_NAME,
      where: 'track_id = ?',
      whereArgs: [track_id],
    );
    List<TrackPropertyModel> trackProps =
        data.map((trackP) => TrackPropertyModel.fromMap(trackP)).toList();
    return trackProps;
  }

  @override
  Future<void> deleteTrack(int track_id) async {
    Database db = await nativeDb.database;

    await db.delete(
      SUB_TRACKS_TABLE_NAME,
      where: "id = ?",
      whereArgs: [track_id],
    );
  }

  @override
  Future<void> deleteTrackProperties(int track_id) async {
    Database db = await nativeDb.database;
    await db.delete(
      TRACK_PROPERTIES_TABLE_NAME,
      where: "track_id = ?",
      whereArgs: [track_id],
    );
  }

  @override
  Future<void> updateTrack(TrackModel track) async {
    Database db = await nativeDb.database;
    await db.update(
      SUB_TRACKS_TABLE_NAME,
      track.toMap(),
      where: "id = ?",
      whereArgs: [track.id],
    );
  }
}
