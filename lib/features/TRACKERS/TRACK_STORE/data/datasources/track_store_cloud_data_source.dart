import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:meta/meta.dart';

import 'package:sorted/core/global/database/sqflite_init.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_model.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/data/models/track_comment_model.dart';
import '../models/market_banner_model.dart';
import '../models/market_heading_model.dart';
import '../models/market_lifestyle_model.dart';
import '../models/market_tab_model.dart';

const String TRACKS_COLLECTION_PATH = 'tracking/tracks/data';
const String MARKET_BANNERS_COLLECTION_PATH = 'Market/MarketBanners/Data';
const String MARKET_HEADINGS_COLLECTION_PATH = 'Market/MarketHeadings/Data';
const String MARKET_TABS_COLLECTION_PATH = 'Market/MarketTabs/Data';
const String COLOSSALS_COLLECTION_NAME = "colossals";
const String COMMENTS_COLLECTION_NAME = "comments";
const String COLOSSAL_URL_FIELD = "url";
const String COMMENTS_SENTIMENT_VALUE_FIELD = "sentiment_value";
const ID_FIELD = 'id';
const TRACK_NAME_FIELD = "name";

abstract class TrackStoreCloud {
  Future<List<TrackModel>> searchForTracks(String word);
  Future<List<TrackModel>> getAllTracks();
  Future<TrackModel> getTrackDetailsById(int track_id);
  Future<List<TrackModel>> getTracksByIds(List<int> trackIds);
  Future<List<MarketHeadingModel>> getMarketHeadings();
  Future<List<MarketBannerModel>> getMarketBanners();
  Future<List<MarketTabModel>> getMarketTabs();
  Future<List<String>> getColossalsByTrackId(int track_id);
  Future<List<TrackCommentModel>> getCommentsByTrackId(
      int track_id, int from, int size);
}

class TrackStoreCloudDataSourceImpl implements TrackStoreCloud {
  final FirebaseFirestore cloudDb;
  final FirebaseAuth auth;
  final SqlDatabaseService nativeDb;

  TrackStoreCloudDataSourceImpl({
    @required this.cloudDb,
    @required this.auth,
    @required this.nativeDb,
  });

  @override
  Future<List<TrackModel>> getAllTracks() async {
    QuerySnapshot querySnapshot =
        await cloudDb.collection(TRACKS_COLLECTION_PATH).get();
    List<TrackModel> tracks = [];
    querySnapshot.docs.forEach((doc) {
      print("track = " + doc.data().toString());
      tracks.add(TrackModel.fromSnapshot(doc));
    });
    return tracks;
  }

  Future<List<TrackModel>> getTracksByIds(List<int> trackIds) async {
    QuerySnapshot querySnapshot = await cloudDb
        .collection(TRACKS_COLLECTION_PATH)
        .where(ID_FIELD, whereIn: trackIds)
        .get();
    List<TrackModel> tracks = [];
    querySnapshot.docs.forEach((doc) {
      print("track = " + doc.data().toString());
      tracks.add(TrackModel.fromSnapshot(doc));
    });

    return tracks;
  }

  @override
  Future<List<MarketBannerModel>> getMarketBanners() async {
    QuerySnapshot querySnapshot =
        await cloudDb.collection(MARKET_BANNERS_COLLECTION_PATH).get();
    print("DOCS = ");
    List<MarketBannerModel> marketBanners = [];
    querySnapshot.docs.forEach((doc) {
      print(doc.data());
      marketBanners.add(MarketBannerModel.fromSnapshot(doc));
    });
    return marketBanners;
  }

  @override
  Future<List<MarketHeadingModel>> getMarketHeadings() async {
    QuerySnapshot querySnapshot =
        await cloudDb.collection(MARKET_HEADINGS_COLLECTION_PATH).get();

    List<MarketHeadingModel> marketHeadings = [];
    querySnapshot.docs.forEach((doc) async {
      marketHeadings.add(MarketHeadingModel.fromSnapshot(doc));
    });

    return marketHeadings;
  }

  @override
  Future<List<MarketTabModel>> getMarketTabs() async {
    QuerySnapshot querySnapshot =
        await cloudDb.collection(MARKET_TABS_COLLECTION_PATH).get();

    List<MarketTabModel> marketTabs = [];
    querySnapshot.docs.forEach((doc) async {
      marketTabs.add(MarketTabModel.fromSnapshot(doc));
    });

    return marketTabs;
  }

  @override
  Future<List<TrackModel>> searchForTracks(String word) async {
    print("WORD = $word");
    QuerySnapshot querySnapshot = await cloudDb
        .collection(TRACKS_COLLECTION_PATH)
        .where(TRACK_NAME_FIELD, isGreaterThanOrEqualTo: word.toUpperCase())
        .get();
    List<TrackModel> tracks = [];
    querySnapshot.docs.forEach((doc) {
      print("track = " + doc.data().toString());
      tracks.add(TrackModel.fromSnapshot(doc));
    });
    return tracks;
  }

  @override
  Future<TrackModel> getTrackDetailsById(int track_id) async {
    QuerySnapshot querySnapshot = await cloudDb
        .collection(TRACKS_COLLECTION_PATH)
        .where(ID_FIELD, isEqualTo: track_id)
        .get();
    TrackModel track = TrackModel.fromSnapshot(querySnapshot.docs[0]);

    return track;
  }

  @override
  Future<List<String>> getColossalsByTrackId(int track_id) async {
    QuerySnapshot querySnapshot = await cloudDb
        .collection(
            "$TRACKS_COLLECTION_PATH/$track_id/$COLOSSALS_COLLECTION_NAME")
        .get();
    List<String> colossals = [];
    querySnapshot.docs.forEach((colossal) {
      colossals.add(colossal.data()[COLOSSAL_URL_FIELD]);
    });

    return colossals;
  }

  @override
  Future<List<TrackCommentModel>> getCommentsByTrackId(
      int track_id, int from, int size) async {
    QuerySnapshot querySnapshot = await cloudDb
        .collection(
            "$TRACKS_COLLECTION_PATH/$track_id/$COMMENTS_COLLECTION_NAME")
        .orderBy(COMMENTS_SENTIMENT_VALUE_FIELD)
        .limit(size)
        .get();
    List<TrackCommentModel> trackComments = [];
    querySnapshot.docs.forEach((doc) {
      trackComments.add(TrackCommentModel.fromSnapshot(doc));
      print("DATA = " + doc.data()["comment"].toString());
    });

    return trackComments;
  }
}
