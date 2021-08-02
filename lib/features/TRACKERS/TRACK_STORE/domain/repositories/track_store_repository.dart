import 'package:dartz/dartz.dart';


import 'package:sorted/features/TRACKERS/TRACK_STORE/domain/entities/log_multifill.dart';

import 'package:sorted/core/error/failures.dart';
import '../entities/market_heading.dart';
import '../entities/track.dart';
import '../entities/market_banner.dart';
import '../entities/market_tab.dart';
import '../entities/track_brief.dart';
import '../entities/track_comment.dart';
import '../entities/track_property.dart';
import '../entities/track_goal.dart';

abstract class TrackStoreRepository {
  Future<Either<Failure, void>> addTrackToRecentSearchs({
    int id,
    String name,
    String icon,
  });
  Future<Either<Failure, Track>> getTrackDetailsById(int id);
  Future<Either<Failure, List<TrackBrief>>> getRecentSearchs();
  Future<Either<Failure, List<Track>>> searchForTracks(String word);
  Future<Either<Failure, List<Track>>> getTabTracks(List<int> tracks);
  Future<Either<Failure, List<MarketBanner>>> getMarketBanners();
  Future<Either<Failure, List<MarketHeading>>> getMarketHeadings();
  Future<Either<Failure, List<MarketTab>>> getMarketTabs();
  Future<Either<Failure, List<String>>> getColossalsByTrackId(int track_id);
  Future<Either<Failure, List<TrackComment>>> getCommentsByTrackId(
    int track_id,
    int from,
    int size,
  );
  Future<Either<Failure, List<TrackProperty>>> getPropertiesByTrackId(
      int track_id);
  Future<Either<Failure, List<TrackGoal>>> getGoalsByTrackId(int track_id);

  Future<Either<Failure, void>> subscribeToTrack(
    Track track,
    List<TrackProperty> trackProps,
  );
  Future<Either<Failure, void>> unsubscribeFromTrack(
    int track_id,
  );
  Future<Either<Failure, void>> pauseTrack(
    Track track,
  );
  Future<Either<Failure, List<LogMultifill>>> getTrackLog();
  Future<Either<Failure, List<Map<String, dynamic>>>> getLeaderboardData();
}
