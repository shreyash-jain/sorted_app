import 'package:meta/meta.dart';
import 'package:sorted/core/global/database/sqflite_init.dart';
import 'package:sqflite/sqflite.dart';
import '../models/track_brief_model.dart';

String SEARCH_TABLE_NAME = "Track_Store_Search";

abstract class TrackStoreNative {
  Future<List<TrackBriefModel>> getRecentSearchs();
  Future<void> addRecentSearch(TrackBriefModel track);
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
}
