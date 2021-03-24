import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:sorted/core/authentication/auth_cloud_data_source.dart';
import 'package:sorted/core/authentication/auth_native_data_source.dart';
import 'package:sorted/core/global/models/addiction_condition.dart';
import 'package:sorted/core/network/network_info.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_property_model.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/data/datasources/track_store_native_data_source.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/domain/entities/track_brief.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/domain/entities/track_comment.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/domain/entities/track_goal.dart';
import 'package:sorted/features/USER_INTRODUCTION/data/datasources/user_intro_cloud_data_source.dart';
import 'package:sorted/features/USER_INTRODUCTION/data/datasources/user_intro_native_data_source.dart';
import 'package:sorted/features/USER_INTRODUCTION/data/datasources/user_intro_shared_pref_data_source.dart';
import 'package:sorted/features/USER_INTRODUCTION/data/models/user_tag.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/domain/repositories/track_store_repository.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/track.dart';
import '../../domain/entities/market_banner.dart';
import '../../domain/entities/market_lifestyle.dart';
import '../../domain/entities/market_heading.dart';
import '../../domain/entities/market_tab.dart';
import '../../domain/entities/track_property.dart';
import '../datasources/track_store_cloud_data_source.dart';
import '../models/track_brief_model.dart';

class TrackStoreRepositoryImpl implements TrackStoreRepository {
  final UserIntroCloud remoteDataSource;
  final UserIntroNative nativeDataSource;
  final UserIntroductionSharedPref sharedPref;
  final AuthCloudDataSource remoteAuth;
  final AuthNativeDataSource nativeAuth;
  final TrackStoreCloud cloudDataSource;
  final TrackStoreNative trackStoreNative;
  final NetworkInfo networkInfo;

  TrackStoreRepositoryImpl({
    @required this.remoteDataSource,
    @required this.nativeDataSource,
    @required this.sharedPref,
    @required this.networkInfo,
    @required this.nativeAuth,
    @required this.remoteAuth,
    @required this.cloudDataSource,
    @required this.trackStoreNative,
  });
  @override
  Future<Either<Failure, List<Track>>> getTabTracks(List<int> trackIds) async {
    if (await networkInfo.isConnected) {
      print("Connected");
      try {
        final List<Track> tracks =
            await cloudDataSource.getTracksByIds(trackIds);
        print(tracks.map((t) => t.id).toList());
        return Right(tracks);
      } catch (error) {
        return Left(ServerFailure());
      }
    } else {
      print("No internet connection");
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<MarketBanner>>> getMarketBanners() async {
    if (await networkInfo.isConnected) {
      try {
        print("Connected");
        final List<MarketBanner> marketBanners =
            await cloudDataSource.getMarketBanners();
        print('Market banners = ');
        print(marketBanners.map((e) => e.heading).toList());
        return Right(marketBanners);
      } catch (error) {
        return Left(ServerFailure());
      }
    } else {
      print("No internet connection");
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<MarketHeading>>> getMarketHeadings() async {
    if (await networkInfo.isConnected) {
      try {
        final List<MarketHeading> marketHeadings = [];
        final marketHeadingModels = await cloudDataSource.getMarketHeadings();

        final List<Track> allTracks = await cloudDataSource.getAllTracks();
        marketHeadingModels.forEach((marketHeadingModel) {
          MarketHeading marketHeading = marketHeadingModel;
          print('TRACK IDS= ');
          print(marketHeadingModel.tracks);
          marketHeading.tracksDetail = allTracks
              .where((track) => marketHeadingModel.tracks.contains(track.id))
              .toList();
          marketHeadings.add(marketHeading);
        });
        return Right(marketHeadings);
      } catch (error) {
        return Left(ServerFailure());
      }
    } else {
      print("No internet connection");
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<MarketTab>>> getMarketTabs() async {
    if (await networkInfo.isConnected) {
      try {
        print("Connected");
        final List<MarketTab> marketTabs =
            await cloudDataSource.getMarketTabs();
        print('Market tabs = ');
        print(marketTabs.map((e) => e.name).toList());
        return Right(marketTabs);
      } catch (error) {
        return Left(ServerFailure());
      }
    } else {
      print("No internet connection");
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Track>>> searchForTracks(String word) async {
    if (await networkInfo.isConnected) {
      try {
        print("Connected");
        final List<Track> searchedTracks =
            await cloudDataSource.searchForTracks(word);
        print('Searched Tracks = ');
        print(searchedTracks.map((e) => e.name).toList());
        return Right(searchedTracks);
      } catch (error) {
        return Left(ServerFailure());
      }
    } else {
      print("No internet connection");
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<TrackBrief>>> getRecentSearchs() async {
    try {
      List<TrackBrief> tracks = await trackStoreNative.getRecentSearchs();
      return Right(tracks.reversed.toList());
    } catch (err) {
      print("CACHE ERROR " + err.toString());
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addTrackToRecentSearchs(
      {int id, String name, String icon}) async {
    try {
      await trackStoreNative.removeSearchByID(id);
      await trackStoreNative.addRecentSearch(
        TrackBriefModel(
          track_id: id,
          track_name: name,
          track_icon: icon,
        ),
      );
      return Right(true);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Track>> getTrackDetailsById(int id) async {
    if (await networkInfo.isConnected) {
      try {
        print("Connected");
        final Track trackDetails =
            await cloudDataSource.getTrackDetailsById(id);
        print(trackDetails.name);
        return Right(trackDetails);
      } catch (error) {
        return Left(ServerFailure());
      }
    } else {
      print("No internet connection");
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<String>>> getColossalsByTrackId(
      int track_id) async {
    if (await networkInfo.isConnected) {
      try {
        final List<String> colossals =
            await cloudDataSource.getColossalsByTrackId(track_id);
        return Right(colossals);
      } catch (error) {
        return Left(ServerFailure());
      }
    } else {
      print("No internet connection");
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<TrackComment>>> getCommentsByTrackId(
      int track_id, int from, int size) async {
    if (await networkInfo.isConnected) {
      try {
        final List<TrackComment> comments =
            await cloudDataSource.getCommentsByTrackId(track_id, from, size);
        return Right(comments);
      } catch (error) {
        return Left(ServerFailure());
      }
    } else {
      print("No internet connection");
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<TrackProperty>>> getPropertiesByTrackId(
      int track_id) async {
    if (await networkInfo.isConnected) {
      try {
        final List<TrackProperty> properties =
            await cloudDataSource.getPropertiesByTrackId(track_id);
        return Right(properties);
      } catch (error) {
        return Left(ServerFailure());
      }
    } else {
      print("No internet connection");
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<TrackGoal>>> getGoalsByTrackId(
      int track_id) async {
    if (await networkInfo.isConnected) {
      try {
        final List<TrackGoal> goals =
            await cloudDataSource.getGoalsByTrackId(track_id);
        return Right(goals);
      } catch (error) {
        return Left(ServerFailure());
      }
    } else {
      print("No internet connection");
      return Left(NetworkFailure());
    }
  }
}
