import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleapis/dfareporting/v3_3.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/utility/utils.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/data/models/track_comments.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/domain/entities/track_comment.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/presentation/bloc/single_track/single_track_bloc.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/presentation/bloc/track_comments/track_comments_bloc.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/presentation/pages/track_story_page.dart';
import '../../../../../core/global/constants/constants.dart';
import '../../domain/entities/track.dart';
import '../../domain/entities/market_heading.dart';
import './about_track_page.dart';
import '../widgets/single_comment.dart';
import './track_comments_page.dart';

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
      child: SafeArea(
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: Gparam.topPadding,
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
                          width: Gparam.height * 0.15,
                          height: Gparam.height * 0.15,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image:
                                  CachedNetworkImageProvider(widget.track.icon),
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
                              ),
                            ),
                            Text(
                              "Market name",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
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
                  height: Gparam.heightPadding * 2,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: Gparam.height * 0.11,
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
                              widget.track.m_num_subs.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Gparam.textSmall,
                              ),
                            ),
                            Text(
                              "people",
                              style: TextStyle(
                                fontSize: Gparam.textSmall,
                              ),
                            ),
                            Text(
                              "Tracking",
                              style: TextStyle(
                                fontSize: Gparam.textSmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: Gparam.widthPadding * 2,
                        child: VerticalDivider(
                          color: Theme.of(context).highlightColor,
                          thickness: 1,
                        ),
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.track.ts_default_sub_days.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Gparam.textSmall,
                              ),
                            ),
                            Text(
                              "Track",
                              style: TextStyle(
                                fontSize: Gparam.textSmall,
                              ),
                            ),
                            Text(
                              "Duration",
                              style: TextStyle(
                                fontSize: Gparam.textSmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: Gparam.widthPadding * 2,
                        child: VerticalDivider(
                          color: Theme.of(context).highlightColor,
                          thickness: 1,
                        ),
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fromLevelToDifficulty(widget.track.m_level),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Gparam.textSmall,
                              ),
                            ),
                            Text(
                              "Habit",
                              style: TextStyle(
                                fontSize: Gparam.textSmall,
                              ),
                            ),
                            Text(
                              "Difficulty",
                              style: TextStyle(
                                fontSize: Gparam.textSmall,
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
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: Gparam.heightPadding,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: Gparam.height * 0.07,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      SizedBox(
                        width: Gparam.widthPadding,
                      ),
                      SimpleButton(
                        text: "Self tracking",
                        onTap: () {},
                      ),
                      SizedBox(
                        width: Gparam.widthPadding / 2,
                      ),
                      widget.track.m_num_expert_groups > 0
                          ? SimpleButton(
                              text: "Track with Expert",
                              onTap: () {},
                            )
                          : Container(),
                      SizedBox(
                        width: Gparam.widthPadding / 2,
                      ),
                      SimpleButton(
                        text: "Track with Friends",
                        onTap: () {},
                      ),
                      SizedBox(
                        width: Gparam.widthPadding,
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: Gparam.heightPadding * 2,
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
                                      color: Theme.of(context).primaryColorDark,
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
