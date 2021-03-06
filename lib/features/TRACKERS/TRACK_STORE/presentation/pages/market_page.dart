import 'package:flutter/material.dart';
import 'package:sorted/features/HOME/presentation/pages/homePage.dart';
import 'package:sorted/features/HOME/presentation/widgets/animated_fab.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/features/SETTINGS/presentation/pages/settings_page.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/presentation/bloc/track_store_bloc.dart';
import '../../domain/entities/market_banner.dart';
import '../../domain/entities/market_heading.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/global/constants/constants.dart';
import '../widgets/build_market_heading.dart';
import '../widgets/market_carousel.dart';
import '../widgets/market_carousel_shimmer.dart';
import '../widgets/market_headings_shimmer.dart';

// ignore: must_be_immutable
class MarketPage extends StatefulWidget {
  @override
  _MarketPageState createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Builder(
        builder: (BuildContext context) {
          return CustomScrollView(
            key: PageStorageKey<String>(""),
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: BlocListener<TrackStoreBloc, TrackStoreState>(
                  listener: (context, state) {
                    if (state is GetMarketsLoadedState) {
                      print("Loaded markets");
                    }
                    if (state is GetMarketsFailedState) {
                      print("Failed to load markets!");
                    }
                  },
                  child: BlocBuilder<TrackStoreBloc, TrackStoreState>(
                    builder: (_, state) {
                      return Container(
                        height: 160,
                        child: (state is GetMarketsLoadedState)
                            ? MarketCarousel(
                                markets: state.marketBanners,
                              )
                            : MarketCarouselShimmer(),
                      );
                    },
                  ),
                ),
              ),
              BlocBuilder<TrackStoreBloc, TrackStoreState>(
                builder: (_, state) {
                  return (state is GetMarketsLoadedState)
                      ? SliverList(
                          delegate: SliverChildListDelegate(
                            state.marketHeadings
                                .map(
                                    (e) => BuildMarketHeading(marketHeading: e))
                                .toList(),
                          ),
                        )
                      : SliverToBoxAdapter(
                          child: Container(
                            child: MarketHeadingsShimmer(),
                          ),
                        );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
