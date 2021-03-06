import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/domain/repositories/track_store_repository.dart';
import '../../domain/entities/market_banner.dart';
import '../../domain/entities/market_heading.dart';
import '../../domain/entities/market_tab.dart';
import '../../domain/entities/track.dart';

part 'track_store_event.dart';
part 'track_store_state.dart';

class TrackStoreBloc extends Bloc<TrackStoreEvent, TrackStoreState> {
  final TrackStoreRepository repository;
  TrackStoreBloc(this.repository) : super(TrackStoreInitial());
  @override
  Stream<TrackStoreState> mapEventToState(TrackStoreEvent event) async* {
    if (event is GetMarketsEvent) {
      yield GetMarketsLoadingState();
      bool failed = false;
      final marketBannersResult = await repository.getMarketBanners();
      final marketHeadingsResult = await repository.getMarketHeadings();
      final marketTabsResult = await repository.getMarketTabs();

      List<MarketBanner> marketBanners;
      List<MarketHeading> marketHeadings;
      List<MarketTab> marketTabs;

      marketBannersResult.fold((failure) {
        failed = true;
      }, (mBanners) {
        marketBanners = mBanners;
      });

      marketHeadingsResult.fold((failure) {
        failed = true;
      }, (mHeadings) {
        marketHeadings = mHeadings;
      });

      marketTabsResult.fold((failure) {
        failed = true;
      }, (mTabs) {
        marketTabs = mTabs;
      });
      if (failed) {
        yield GetMarketsFailedState();
      } else {
        yield GetMarketsLoadedState(
          marketBanners: marketBanners,
          marketHeadings: marketHeadings,
          marketTabs: marketTabs,
        );
      }
    }
  }
}
