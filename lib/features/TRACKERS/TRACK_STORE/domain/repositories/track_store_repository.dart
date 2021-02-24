import 'package:dartz/dartz.dart';
import 'package:sorted/core/global/models/addiction_condition.dart';
import 'package:sorted/core/global/models/health_condition.dart';
import 'package:sorted/core/global/models/lifestyle_profile.dart';
import 'package:sorted/core/global/models/mental_health_profile.dart';
import 'package:sorted/core/global/models/physical_health_profile.dart';
import 'package:sorted/core/global/models/user_details.dart';
import 'package:sorted/features/PROFILE/data/models/activity.dart';
import 'package:sorted/features/PROFILE/data/models/user_activity.dart';
import 'package:sorted/features/USER_INTRODUCTION/data/models/user_tag.dart';
import 'package:sorted/core/error/failures.dart';
import '../entities/market_heading.dart';
import '../entities/track.dart';
import '../entities/market_banner.dart';

abstract class TrackStoreRepository {
  Future<Either<Failure, List<Track>>> getTracks();
  Future<Either<Failure, List<MarketBanner>>> getMarketBanners();
  Future<Either<Failure, List<MarketHeading>>> getMarketHeadings();
}
