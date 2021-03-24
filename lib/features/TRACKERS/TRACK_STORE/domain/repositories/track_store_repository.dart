import 'package:dartz/dartz.dart';
import 'package:sorted/core/global/models/addiction_condition.dart';
import 'package:sorted/core/global/models/health_condition.dart';
import 'package:sorted/core/global/models/lifestyle_profile.dart';
import 'package:sorted/core/global/models/mental_health_profile.dart';
import 'package:sorted/core/global/models/physical_health_profile.dart';
import 'package:sorted/core/global/models/user_details.dart';
import 'package:sorted/features/PROFILE/data/models/activity.dart';
import 'package:sorted/features/PROFILE/data/models/user_activity.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_property_model.dart';
import 'package:sorted/features/USER_INTRODUCTION/data/models/user_tag.dart';
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
  Future<Either<Failure, void>> addTrackToRecentSearchs(
      {int id, String name, String icon});
  Future<Either<Failure, Track>> getTrackDetailsById(int id);
  Future<Either<Failure, List<TrackBrief>>> getRecentSearchs();
  Future<Either<Failure, List<Track>>> searchForTracks(String word);
  Future<Either<Failure, List<Track>>> getTabTracks(List<int> tracks);
  Future<Either<Failure, List<MarketBanner>>> getMarketBanners();
  Future<Either<Failure, List<MarketHeading>>> getMarketHeadings();
  Future<Either<Failure, List<MarketTab>>> getMarketTabs();
  Future<Either<Failure, List<String>>> getColossalsByTrackId(int track_id);
  Future<Either<Failure, List<TrackComment>>> getCommentsByTrackId(
      int track_id, int from, int size);
  Future<Either<Failure, List<TrackProperty>>> getPropertiesByTrackId(
      int track_id);
  Future<Either<Failure, List<TrackGoal>>> getGoalsByTrackId(int track_id);
}
