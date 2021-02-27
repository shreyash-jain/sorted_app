import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:sorted/core/authentication/auth_cloud_data_source.dart';
import 'package:sorted/core/authentication/auth_native_data_source.dart';
import 'package:sorted/core/global/models/addiction_condition.dart';
import 'package:sorted/core/network/network_info.dart';
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
import '../datasources/track_store_cloud_data_source.dart';

class TrackStoreRepositoryImpl implements TrackStoreRepository {
  final UserIntroCloud remoteDataSource;
  final UserIntroNative nativeDataSource;
  final UserIntroductionSharedPref sharedPref;
  final AuthCloudDataSource remoteAuth;
  final AuthNativeDataSource nativeAuth;
  final TrackStoreCloud cloudDataSource;

  final NetworkInfo networkInfo;

  TrackStoreRepositoryImpl({
    @required this.remoteDataSource,
    @required this.nativeDataSource,
    @required this.sharedPref,
    @required this.networkInfo,
    @required this.nativeAuth,
    @required this.remoteAuth,
    @required this.cloudDataSource,
  });
  @override
  Future<Either<Failure, List<Track>>> getTracks() async {
    if (await networkInfo.isConnected) {
      print("Connected");
      try {
        final List<Track> tracks = await cloudDataSource.getAllTracks();
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
          print(marketHeadingModel.icon_url);
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
}
