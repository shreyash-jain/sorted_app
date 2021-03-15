part of 'track_store_bloc.dart';

abstract class TrackStoreState extends Equatable {
  const TrackStoreState();
}

class TrackStoreInitial extends TrackStoreState {
  @override
  List<Object> get props => [];
}

class GetMarketsLoadingState extends TrackStoreState {
  @override
  List<Object> get props => [];
}

class GetMarketsLoadedState extends TrackStoreState {
  final List<MarketBanner> marketBanners;
  final List<MarketHeading> marketHeadings;
  final List<MarketTab> marketTabs;

  const GetMarketsLoadedState({
    this.marketBanners,
    this.marketHeadings,
    this.marketTabs,
  });

  @override
  List<Object> get props => [
        marketBanners,
        marketHeadings,
        marketTabs,
      ];
}

class GetMarketsFailedState extends TrackStoreState {
  @override
  List<Object> get props => [];
}
