import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:meta/meta.dart';

import 'package:sorted/core/global/database/sqflite_init.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_model.dart';
import '../models/market_banner_model.dart';
import '../models/market_heading_model.dart';
import '../models/market_lifestyle_model.dart';

const String TRACKS_COLLECTION_PATH = 'tracking/tracks/data';
const String MARKET_BANNERS_COLLECTION_PATH = 'Market/MarketBanners/Data';
const String MARKET_HEADINGS_COLLECTION_PATH = 'Market/MarketHeadings/Data';
const ID_FIELD = 'id';

abstract class TrackStoreCloud {
  Future<List<TrackModel>> getAllTracks();
  Future<List<TrackModel>> getTracksByIds(List<int> trackIds);
  Future<List<MarketHeadingModel>> getMarketHeadings();
  Future<List<MarketBannerModel>> getMarketBanners();
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
    // return [
    //   TrackModel(
    //     name: "track 1",
    //   ),
    //   TrackModel(
    //     name: "track 2",
    //   ),
    //   TrackModel(
    //     name: "track 3",
    //   ),
    // ];
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
    // return <MarketBannerModel>[
    //   MarketBannerModel(
    //       heading: "Explore lifeStyles", sub_heading: "comme and explore"),
    //   MarketBannerModel(
    //       heading: "Explore Challenges", sub_heading: "Challenges to do ")
    // ];
  }

  @override
  Future<List<MarketHeadingModel>> getMarketHeadings() async {
    QuerySnapshot querySnapshot =
        await cloudDb.collection(MARKET_HEADINGS_COLLECTION_PATH).get();

    // // List<TrackModel> tracks = await getTracks();

    List<MarketHeadingModel> marketHeadings = [];
    querySnapshot.docs.forEach((doc) async {
      marketHeadings.add(MarketHeadingModel.fromSnapshot(doc));
    });
    //   QuerySnapshot tracksQuery = await firestore
    //       .collection(TRACKS_COLLECTION_PATH)
    //       .where("id", whereIn: marketHeadingModel.trackIds)
    //       .get();
    //   marketHeadingModel.tracks =
    //       tracksQuery.docs.map((e) => TrackModel.fromJson(e.data())).toList();
    //   // tracks
    //   //     .where((track) => marketHeadingModel.trackIds.contains(track.id))
    //   //     .toList();
    //   marketHeadings.add(marketHeadingModel);
    // });
    return marketHeadings;
    // return <MarketHeadingModel>[
    //   MarketHeadingModel(
    //     name: "Morning routring",
    //   ),
    //   MarketHeadingModel(
    //     name: "Healthy lifestyle",
    //   ),
    //   MarketHeadingModel(
    //     name: "Morning exo",
    //   ),
    // ];
  }
}
