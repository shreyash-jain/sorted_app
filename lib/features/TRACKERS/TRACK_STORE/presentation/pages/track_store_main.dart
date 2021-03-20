import './tab_tracks_page.dart';
import './market_page.dart';

import 'package:flutter/material.dart';
import 'package:sorted/features/HOME/presentation/pages/homePage.dart';
import 'package:sorted/features/HOME/presentation/widgets/animated_fab.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/features/SETTINGS/presentation/pages/settings_page.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/presentation/bloc/track_store_bloc.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/presentation/bloc/track_store_search/track_store_search_bloc.dart';
import '../../domain/entities/market_banner.dart';
import '../../domain/entities/track_brief.dart';
import '../../domain/entities/track.dart';
import '../../domain/entities/market_tab.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/global/constants/constants.dart';
import '../widgets/build_market_heading.dart';
import '../widgets/market_carousel.dart';
import '../widgets/market_carousel_shimmer.dart';
import '../widgets/market_headings_shimmer.dart';
import '../widgets/search_track_item.dart';
import '../widgets/search_track_item_brief.dart';
import '../widgets/track_item_large.dart';
import './single_track_page.dart';

class TrackStoreMain extends StatefulWidget {
  @override
  _TrackStoreMainState createState() => _TrackStoreMainState();
}

class _TrackStoreMainState extends State<TrackStoreMain> {
  TrackStoreBloc bloc;
  TrackStoreSearchBloc searchBloc;
  double searchResultsHeight = Gparam.height * 0.4;
  bool isSearchVisible = false;
  final searchController = TextEditingController();
  // TODO add new bloc

  @override
  void initState() {
    bloc = sl<TrackStoreBloc>();
    bloc.add(GetMarketsEvent());
    searchBloc = sl<TrackStoreSearchBloc>();
    super.initState();
  }

  @override
  void dispose() {
    bloc?.close();
    searchBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => bloc,
        ),
        BlocProvider(
          create: (context) => searchBloc,
        )
      ],
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: BlocBuilder<TrackStoreBloc, TrackStoreState>(
            builder: (_, state) {
              if (state is GetMarketsLoadedState) {
                print("State = $state");
                print("WELL DONE MAN ${state.marketTabs.length}");

                return Stack(
                  children: [
                    DefaultTabController(
                      length: state.marketTabs.length,
                      child: NestedScrollView(
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            SliverToBoxAdapter(
                              child: Container(
                                height: Gparam.topPadding / 2,
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: Gparam.widthPadding / 2),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .highlightColor
                                        .withOpacity(.1),
                                    borderRadius: BorderRadius.circular(
                                        Gparam.topPadding / 4),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                        child: Icon(
                                          Icons.menu,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        height: 40,
                                        width: Gparam.width * 0.7,
                                        child: TextField(
                                          controller: searchController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            hintText:
                                                'Search Track & Lifestyle',
                                            hintStyle: TextStyle(
                                              fontFamily: 'Montserrat',
                                              color: Theme.of(context)
                                                  .highlightColor,
                                              fontSize: Gparam.textSmaller,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          onChanged: (val) {
                                            if (val == null || val == "") {
                                              searchBloc
                                                  .add(GetSuggestionsEvent());
                                            } else {
                                              print("let's search !!!");
                                              searchBloc
                                                  .add(SearchEvent(word: val));
                                            }
                                          },
                                          onSubmitted: (val) {
                                            setState(() {
                                              searchResultsHeight =
                                                  Gparam.height * 0.9;
                                            });
                                          },
                                          onTap: () {
                                            setState(() {
                                              isSearchVisible = true;
                                              // searchResultsHeight =
                                              //     Gparam.height * 0.4;
                                            });
                                            String text = searchController.text;
                                            if (text == "" || text == null) {
                                              searchBloc
                                                  .add(GetSuggestionsEvent());
                                            }
                                          },
                                          autofocus: false,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      isSearchVisible
                                          ? InkWell(
                                              onTap: () {
                                                setState(() {
                                                  isSearchVisible = false;
                                                });
                                              },
                                              child: Icon(
                                                Icons.cancel,
                                              ),
                                            )
                                          : SizedBox.shrink(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SliverAppBar(
                              automaticallyImplyLeading: false,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              flexibleSpace: Column(
                                children: [
                                  TabBar(
                                    indicatorColor:
                                        Theme.of(context).textSelectionColor,
                                    labelColor:
                                        Theme.of(context).textSelectionColor,
                                    labelStyle: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: Gparam.textVerySmall,
                                        fontWeight: FontWeight.w500),
                                    isScrollable: true,
                                    unselectedLabelColor:
                                        Theme.of(context).highlightColor,
                                    tabs: state.marketTabs
                                        .map((MarketTab marketTab) =>
                                            Tab(text: marketTab.name))
                                        .toList(),
                                  ),
                                  Divider(
                                    height: 1,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                              pinned: true,
                            ),
                          ];
                        },
                        body: Stack(
                          children: [
                            TabBarView(
                              children:
                                  state.marketTabs.map((MarketTab marketTab) {
                                if (marketTab.id == 0) return MarketPage();
                                return TabTracksPage(tracks: marketTab.tracks);
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isSearchVisible,
                      child: Positioned(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            margin: EdgeInsets.only(
                              top: 50 + Gparam.topPadding / 2,
                              left: Gparam.widthPadding / 2,
                              right: Gparam.widthPadding / 2,
                            ),
                            width: Gparam.width,
                            height: searchResultsHeight,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).dialogBackgroundColor,
                            ),
                            child: BlocListener<TrackStoreSearchBloc,
                                TrackStoreSearchState>(
                              listener: (context, state) {
                                if (state is GetTrackDetailsLoadedState) {
                                  _trackDetailsLoaded(state.track);
                                }
                              },
                              child: BlocBuilder<TrackStoreSearchBloc,
                                  TrackStoreSearchState>(
                                builder: (context, state) {
                                  if (state is SearchLoadingState) {
                                    return _buildLoadingSearch();
                                  }

                                  if (state is SearchLoadedState) {
                                    return _buildSearchResults(
                                        state.searchedTracks);
                                  }
                                  if (state is SuggestionsLoadedState) {
                                    return _buildSuggestions(state.briefTracks);
                                  }
                                  return Container();
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              if (state is GetMarketsLoadingState) {
                return _buildTrackStoreShimmer();
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingSearch() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildSearchResults(List<Track> searchedTracks) {
    return ListView.builder(
      itemCount: searchedTracks.length,
      itemBuilder: (_, i) => SearchTrackItem(
        track: searchedTracks[i],
      ),
    );
  }

  Widget _buildSuggestions(List<TrackBrief> briefTracks) {
    return Column(
      children: [
        Container(
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(left: Gparam.widthPadding / 2),
                child: Text('Recent search'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: briefTracks.length,
            itemBuilder: (_, i) => SearchTrackItemBrief(
              trackBrief: briefTracks[i],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrackStoreShimmer() {
    return Container(
      height: Gparam.height,
      child: ListView(
        children: [
          SizedBox(
            height: Gparam.topPadding / 2,
          ),
          Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.symmetric(horizontal: Gparam.widthPadding / 2),
            decoration: BoxDecoration(
              color: Theme.of(context).highlightColor.withOpacity(.1),
              borderRadius: BorderRadius.circular(Gparam.topPadding / 4),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  child: Icon(
                    Icons.menu,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: 40,
                  width: Gparam.width * 0.7,
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: 'Search Track & Lifestyle',
                      hintStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Theme.of(context).highlightColor,
                        fontSize: Gparam.textSmaller,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    enabled: false,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  height: Gparam.topPadding,
                ),
              ],
            ),
          ),
          SizedBox(
            height: Gparam.topPadding,
          ),
          Container(
            height: 160,
            child: MarketCarouselShimmer(),
          ),
          MarketHeadingsShimmer(),
        ],
      ),
    );
  }

  void _trackDetailsLoaded(Track track) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SingleTrackPage(
          track: track,
        ),
      ),
    );
    searchBloc.add(GetSuggestionsEvent());
  }
}
