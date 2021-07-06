import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/utility/utils.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/domain/entities/track_comment.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/domain/entities/track_property.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/presentation/bloc/leaderboard/leaderboard_bloc.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/presentation/bloc/single_track/single_track_bloc.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/presentation/bloc/track_comments/track_comments_bloc.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/presentation/pages/track_story_page.dart';
import '../../../../../core/global/constants/constants.dart';
import '../../domain/entities/track.dart';
import '../../domain/entities/market_heading.dart';
import '../../domain/entities/track_goal.dart';
import './about_track_page.dart';
import '../widgets/single_comment.dart';
import './track_comments_page.dart';
import '../widgets/property_item.dart';
import '../widgets/feature_item.dart';
import '../../../COMMON/constants/enum_constants.dart';
import '../widgets/pop-ups/self_tracking_popup.dart';
import '../widgets/pop-ups/loading_dialog.dart';
import '../widgets/pop-ups/pause_dialog.dart';
import 'leaderboard_page.dart';
import 'track_log_page.dart';

class SingleTrackPage extends StatefulWidget {
  final Track track;
  final MarketHeading marketHeading;
  const SingleTrackPage({this.track, this.marketHeading});

  @override
  _SingleTrackPageState createState() => _SingleTrackPageState();
}

class _SingleTrackPageState extends State<SingleTrackPage> {
  SingleTrackBloc bloc;
  TrackCommentsBloc commentsBloc;
  // List<TrackProperty> properties = [];
  @override
  void initState() {
    bloc = sl();
    commentsBloc = sl();
    bloc.add(GetSingleTrackEvent(widget.track.id));
    commentsBloc.add(
      GetTrackCommentsEvent(
        trackComments: [],
        track_id: widget.track.id,
        size: 5,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    bloc.close();
    commentsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SingleTrackBloc>(
          create: (_) => bloc,
        ),
        BlocProvider<TrackCommentsBloc>(
          create: (_) => commentsBloc,
        ),
      ],
      child: BlocListener<SingleTrackBloc, SingleTrackState>(
        listener: (_, state) {
          if (state is SubscribeToTrackLoadingState) {
            showDialog(
              context: context,
              builder: (context) => LoadingDialog(),
              barrierDismissible: false,
            );
          }
          if (state is SubscribeToTrackFailedState) {
            // Navigator.pop(context);

            print("Can't subscribe now !!!!");
          }

          if (state is SubscribeToTrackLoadedState) {
            Navigator.pop(context);
            bloc.add(GetSingleTrackEvent(widget.track.id));
          }
        },
        child: SafeArea(
          child: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => LeaderboardPage()));
                    },
                    child: Text("Leaderboard"),
                    color: Colors.amber,
                    height: Gparam.topPadding * 2,
                  ),
                ),
                SliverToBoxAdapter(
                  child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => TrackLogPage()));
                    },
                    child: Text("Track Logs"),
                    color: Colors.blueAccent,
                    height: Gparam.topPadding / 2,
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: Gparam.topPadding / 2,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: Gparam.height * 0.15,
                    child: Row(
                      children: [
                        SizedBox(
                          width: Gparam.widthPadding,
                        ),
                        Hero(
                          tag:
                              "track-icon-${widget?.marketHeading?.id}-${widget?.track?.id}",
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: CachedNetworkImageProvider(
                                    widget.track.icon),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: Gparam.widthPadding / 2,
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: Gparam.height * 0.03,
                              ),
                              Text(
                                widget.track.name,
                                style: TextStyle(
                                  fontSize: Gparam.textMedium,
                                  fontFamily: 'Milliard',
                                ),
                              ),
                              Text(
                                "Market name",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Milliard',
                                  fontSize: Gparam.textSmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: Gparam.heightPadding,
                  ),
                ),
                SliverToBoxAdapter(
                  child: _buildTrackInfo(widget.track, context),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: Gparam.heightPadding / 2,
                  ),
                ),
                SliverToBoxAdapter(
                  child: BlocBuilder<SingleTrackBloc, SingleTrackState>(
                    builder: (_, state) {
                      if (state is GetSingleTrackLoadingState) {
                        return _buildLoading();
                      }
                      if (state is GetSingleTrackLoadedState) {
                        return _buildTrackingMethods(
                          state.trackGoals,
                          state.trackDetails,
                          state.trackProperties,
                        );
                      }
                      return Container();
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: Gparam.heightPadding * 2,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Row(
                    children: [
                      SizedBox(
                        width: Gparam.widthPadding,
                      ),
                      Text(
                        "What this track has",
                        style: Gtheme.textBold
                            .copyWith(fontSize: Gparam.textSmaller),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: Gparam.heightPadding / 2,
                  ),
                ),
                SliverToBoxAdapter(
                  child: BlocBuilder<SingleTrackBloc, SingleTrackState>(
                    builder: (_, state) {
                      if (state is GetSingleTrackLoadingState) {
                        return _buildLoading();
                      }
                      if (state is GetSingleTrackLoadedState) {
                        if (state.trackProperties.isEmpty) {
                          return SizedBox.shrink();
                        }
                        return _buildTrackProperties(state.trackProperties);
                      }
                      return Container();
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: Gparam.heightPadding,
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: Gparam.heightPadding,
                  ),
                ),
                SliverToBoxAdapter(
                  child: BlocBuilder<SingleTrackBloc, SingleTrackState>(
                    builder: (_, state) {
                      if (state is GetSingleTrackLoadingState) {
                        return _buildLoading();
                      }
                      if (state is GetSingleTrackLoadedState) {
                        if (state.colossals.isEmpty) {
                          return SizedBox.shrink();
                        }
                        return _buildColossals(state.colossals);
                      }
                      return Container();
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: Gparam.heightPadding,
                  ),
                ),
                SliverToBoxAdapter(
                    child: _buildAboutTrack(widget.track, context)),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: Gparam.heightPadding,
                  ),
                ),
                SliverToBoxAdapter(
                  child: _buildAutoFill(),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: Gparam.heightPadding,
                  ),
                ),
                SliverToBoxAdapter(
                  child: _buildTrackFeatures(),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: Gparam.heightPadding * 1.5,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Row(
                    children: [
                      SizedBox(
                        width: Gparam.widthPadding,
                      ),
                      Text(
                        "Comments",
                        style: Gtheme.textBold
                            .copyWith(fontSize: Gparam.textSmaller),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: Gparam.heightPadding,
                  ),
                ),
                BlocBuilder<TrackCommentsBloc, TrackCommentsState>(
                  builder: (_, state) {
                    if (state is GetTrackCommentsLoadingState) {
                      return SliverToBoxAdapter(child: _buildLoading());
                    }
                    if (state is GetTrackCommentsLoadedState) {
                      if (state.comments.isEmpty) {
                        return SliverToBoxAdapter(
                          child: Container(
                            height: 50,
                            child: Center(
                              child: Text(
                                "There is no comments to show",
                                style: Gtheme.textNormal.copyWith(
                                  fontSize: Gparam.textSmall,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      List<Widget> comments =
                          _buildCommentsSection(state.comments);
                      return SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            ...comments,
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => TrackCommentsPage(
                                      track_id: widget.track.id,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: 15,
                                margin:
                                    EdgeInsets.only(bottom: Gparam.topPadding),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: Gparam.widthPadding,
                                    ),
                                    Text(
                                      "View more",
                                      style: Gtheme.textBold.copyWith(
                                        fontSize: Gparam.textSmaller,
                                        color:
                                            Theme.of(context).primaryColorDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return SliverToBoxAdapter(child: Container());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColossals(List<String> colossals) {
    return Container(
      height: Gparam.height * 0.32,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: colossals.length * 2 + 1,
        itemBuilder: (_, i) {
          if (i == 0) {
            return SizedBox(
              width: Gparam.widthPadding,
            );
          }
          if (i % 2 == 1) {
            String url = colossals[i ~/ 2];
            String tag = i.toString();
            return InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TrackStoryPage(
                      url: url,
                      tag: tag,
                    ),
                  ),
                );
              },
              child: Hero(
                tag: tag,
                child: Container(
                  width: Gparam.width * 0.3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(20),
                    // ),
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl: url ?? "",
                      progressIndicatorBuilder: (context, url, progress) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (_, __, ___) => Icon(Icons.error),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return SizedBox(
              width: Gparam.widthPadding / 2,
            );
          }
        },
      ),
    );
  }

  Widget _buildLoading() {
    return Container(
      height: 400,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildTrackingMethods(
    List<TrackGoal> goals,
    Track track,
    List<TrackProperty> trackProperties,
  ) {
    print("ACTIVE STATE = " + track.u_active_state.toString());
    int active_state = track.u_active_state;
    return Container(
      height: Gparam.height * 0.05,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          SizedBox(
            width: Gparam.widthPadding,
          ),
          // -1: not traking / 0: paused / 1: active
          active_state == -1
              ? _buildSelfTrackingButton(track, trackProperties, goals)
              : active_state == 0
                  ? _buildTrackPausedButton()
                  : _buildTrackRunningButton(),
          SizedBox(
            width: Gparam.widthPadding / 4,
          ),
          widget.track.m_num_expert_groups > 0
              ? MaterialButton(
                  child: Text("Track with Experts"),
                  elevation: 0,
                  onPressed: () {},
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  color: Colors.greenAccent,
                )
              : Container(),
          SizedBox(
            width: Gparam.widthPadding / 4,
          ),
          MaterialButton(
            child: Text("Track with Friends"),
            elevation: 0,
            onPressed: () {},
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            color: Colors.greenAccent,
          ),
          SizedBox(
            width: Gparam.widthPadding,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutTrack(Track track, context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AboutTrackPage(track: track),
          ),
        );
      },
      child: Container(
        child: ListTile(
          contentPadding: EdgeInsets.only(
            left: Gparam.widthPadding,
            right: Gparam.widthPadding / 2,
          ),
          title: Text(
            "About this track\n",
            style: Gtheme.textBold.copyWith(fontSize: Gparam.textSmaller),
          ),
          subtitle: Text(
            track?.m_description ?? "Description of the track",
            style: Gtheme.textNormal.copyWith(fontSize: Gparam.textSmaller),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Container(
            child: Icon(Icons.arrow_forward, size: 30),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCommentsSection(List<TrackComment> comments) {
    return comments
        .map((comment) => SingleComment(trackComment: comment))
        .toList();
  }

  Widget _buildTrackInfo(Track track, BuildContext context) {
    return Container(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          SizedBox(
            width: Gparam.widthPadding,
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track.m_num_subs.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Gparam.textSmall,
                    fontFamily: 'Milliard',
                  ),
                ),
                Text(
                  "People Tracking",
                  style: TextStyle(
                    fontSize: Gparam.textVerySmall,
                    fontFamily: 'Milliard',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: Gparam.widthPadding * 2,
            child: VerticalDivider(
              color: Theme.of(context).highlightColor.withOpacity(.3),
              thickness: 2,
              indent: 20,
              endIndent: 30,
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track.ts_default_sub_days.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Gparam.textSmall,
                    fontFamily: 'Milliard',
                  ),
                ),
                Text(
                  "Track Duration",
                  style: TextStyle(
                    fontSize: Gparam.textVerySmall,
                    fontFamily: 'Milliard',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: Gparam.widthPadding * 2,
            child: VerticalDivider(
              color: Theme.of(context).highlightColor.withOpacity(.3),
              thickness: 2,
              indent: 20,
              endIndent: 30,
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fromLevelToDifficulty(track.m_level),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Gparam.textSmall,
                  ),
                ),
                Text(
                  "Habit Difficulty",
                  style: TextStyle(
                    fontSize: Gparam.textVerySmall,
                    fontFamily: 'Milliard',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: Gparam.widthPadding,
          ),
        ],
      ),
    );
  }

  Widget _buildTrackProperties(List<TrackProperty> properties) {
    return Container(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: properties.length * 2,
        itemBuilder: (_, i) {
          if (i == 0) {
            return SizedBox(
              width: Gparam.widthPadding,
            );
          }
          if (i % 2 == 0) {
            return SizedBox(
              width: Gparam.widthPadding / 2,
            );
          }
          return PropertyItem(trackProperty: properties[i ~/ 2]);
        },
      ),
    );
  }

  Widget _buildAutoFill() {
    int autoFill = widget.track.ts_autofill;
    return Row(
      children: [
        SizedBox(
          width: Gparam.widthPadding,
        ),
        Expanded(
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Theme.of(context).highlightColor),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: Gparam.widthPadding / 2,
                ),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(500),
                    border: Border.all(color: Theme.of(context).highlightColor),
                    color: autoFill == 0 ? Colors.grey : Colors.amber,
                  ),
                ),
                SizedBox(
                  width: Gparam.widthPadding / 2,
                ),
                Text(TrackAutoTracking.values[0]?.description ?? "Auto fill"),
              ],
            ),
          ),
        ),
        SizedBox(
          width: Gparam.widthPadding / 2,
        ),
      ],
    );
  }

  Widget _buildTrackFeatures() {
    List<Widget> features = [];
    if (widget.track.ts_root_logging_db_path != null) {
      features.add(
        FeatureItem(
          text: widget.track.m_db_string,
          icon_url: widget.track.m_db_icon,
        ),
      );
    }
    if (widget.track.u_root_level_logging_saved_path != null) {
      features.add(
        FeatureItem(
          text: widget.track.m_custom_db_string,
          icon_url: widget.track.m_custom_db_icon,
        ),
      );
    }
    if (widget.track.ts_root_logging_db_path != null) {
      // if (true) {
      features.add(
        FeatureItem(
          text: widget.track.m_template_string,
          icon_url: widget.track.m_template_icon,
        ),
      );
    }
    if (features.isEmpty) {
      return SizedBox.shrink();
    } else {
      return Container(
        height: 130,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: features.length * 2,
          itemBuilder: (_, i) {
            if (i == 0) {
              return SizedBox(
                width: Gparam.widthPadding,
              );
            }
            if (i % 2 == 0) {
              return SizedBox(
                width: Gparam.widthPadding / 2,
              );
            }
            return features[i ~/ 2];
          },
        ),
      );
    }
  }

  _buildSelfTrackingButton(
    Track track,
    List<TrackProperty> trackProperties,
    List<TrackGoal> goals,
  ) {
    return MaterialButton(
      child: Text("Self tracking"),
      onPressed: () async {
        showDialog(
          context: context,
          builder: (_) => Dialog(
            backgroundColor: Colors.transparent,
            child: SelfTrackingPopup(
              trackGoals: goals,
              track: track,
              props: trackProperties,
              bloc: bloc,
            ),
          ),
        );
      },
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      color: Colors.greenAccent,
    );
  }

  _buildTrackPausedButton() {
    return MaterialButton(
      child: Text("Tracking is paused"),
      onPressed: () async {
        // TODO
      },
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      color: Colors.greenAccent,
    );
  }

  _buildTrackRunningButton() {
    return MaterialButton(
      child: Text("Active"),
      onPressed: () async {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                  backgroundColor: Colors.transparent,
                  child: PauseDialog(
                    track: widget.track,
                    bloc: bloc,
                  ));
            });
      },
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      color: Colors.greenAccent,
    );
  }
  // end of the class
}

class SimpleButton extends StatelessWidget {
  final String text;
  final Function onTap;
  SimpleButton({this.onTap, this.text});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Gparam.widthPadding * 0.7,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).highlightColor),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Gparam.textSmaller,
            ),
          ),
        ),
      ),
    );
  }
}
