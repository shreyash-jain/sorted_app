import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sorted/core/global/animations/fade_animationTB.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/widgets/UnicornOutlineButton.dart';
import 'package:sorted/core/global/widgets/message_display.dart';
import 'package:sorted/core/routes/router.gr.dart';
import 'package:sorted/features/CONNECT/presentation/widgets/classroom_preview.dart';
import 'package:sorted/features/HOME/presentation/bloc_affirmation/affirmation_bloc.dart';
import 'package:sorted/features/HOME/presentation/home_stories_bloc/home_stories_bloc.dart';
import 'package:sorted/features/HOME/presentation/track_log_bloc/track_log_bloc.dart';
import 'package:sorted/features/HOME/presentation/widgets/story/story_circle.dart';

import 'package:sorted/features/TRACKERS/COMMON/models/track_model.dart';
import 'package:sorted/features/TRACKERS/COMMON/performance_track_data/track_data.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/widgets/weight_widget.dart/weight_card.dart';

class FlexibleSpaceArea extends StatefulWidget {
  const FlexibleSpaceArea({
    Key key,
    @required this.currentSliverheight,
    @required this.name,
  }) : super(key: key);

  final double currentSliverheight;
  final String name;

  @override
  State<StatefulWidget> createState() => _FlexibleAreaState();
}

class _FlexibleAreaState extends State<FlexibleSpaceArea> {
  HomeStoriesBloc homeStoriesBloc;
  bool showArrow = true;
  List<TrackModel> tracks = [];

  ScrollController _controller;
  OverlayEntry _popupDialog;

  int weight = 60;

  @override
  void initState() {
    _controller = ScrollController();
    tracks = getTracksForClasses();

    homeStoriesBloc = sl<HomeStoriesBloc>()..add(LoadTrackStories());

    _controller.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        showArrow = false;
      });
    }
  }

  String getMeditationString(DateTime dateTime) {
    if (dateTime.hour > 19 || (dateTime.hour > 0 && dateTime.hour < 3)) {
      return "Night\nMeditation";
    } else if (dateTime.hour >= 3 && dateTime.hour < 15)
      return "Morning\nMeditation";
    return "Meditation";
  }

  String foodString(DateTime dateTime) {
    if (dateTime.hour > 19 || (dateTime.hour > 0 && dateTime.hour < 3)) {
      return "Dinner\nInspiration";
    } else if (dateTime.hour >= 3 && dateTime.hour < 10)
      return "Breakfast\nInspiration";
    else if (dateTime.hour >= 10 && dateTime.hour < 15)
      return "Lunch\nInspiration";
    else if (dateTime.hour >= 15 && dateTime.hour < 19)
      return "Snack\nInspiration";
    return "Meal Inspiration";
  }

  onClickChallenges(int id, int storyType, TrackModel track) {
    context.router.push(ChallengeRouteView());
  }

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
        title: (widget.currentSliverheight < Gparam.height / 4)
            ? Text(
                '',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: 'Milliard',
                  fontSize: 14.0,
                  color: Theme.of(context).highlightColor,
                  fontWeight: FontWeight.w600,
                ),
              )
            : Text(
                '',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: 'Milliard',
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
        background: Container(
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(45.0)),
            gradient: new LinearGradient(
                colors: [
                  Theme.of(context).scaffoldBackgroundColor,
                  Theme.of(context).scaffoldBackgroundColor,
                ],
                stops: [
                  0.2,
                  0.8
                ],
                begin: FractionalOffset.topRight,
                end: FractionalOffset.bottomCenter,
                tileMode: TileMode.clamp),
          ),
          padding: EdgeInsets.only(
            top: Gparam.topPadding / 3,
          ),
          child: FadeAnimationTB(
              1.6,
              Container(
                  child: Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          BlocProvider(
                            create: (context) => homeStoriesBloc,
                            child:
                                BlocBuilder<HomeStoriesBloc, HomeStoriesState>(
                              builder: (context, state) {
                                if (state is HomeStoriesLoaded)
                                  return Container(
                                      height: 140,
                                      width: Gparam.width,
                                      margin: EdgeInsets.only(top: 20),
                                      child: ListView(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          SizedBox(
                                            width: Gparam.widthPadding / 2,
                                          ),
                                          ...state.subsTracks
                                              .asMap()
                                              .entries
                                              .map((e) {
                                            return StoryCircleWidget(
                                                storyName: e.value.name,
                                                track: e.value,
                                                isActive:
                                                    state.isLoading[e.key],
                                                onClick: (a, b, c) {
                                                  // showDialog(
                                                  //   context: context,
                                                  //   builder: (BuildContext
                                                  //           context) =>
                                                  //       _buildWeightPopupDialog(
                                                  //           context),
                                                  // );

                                                  if (state.isLoading[e.key] ==
                                                      false) {
                                                    if (e.value.id == 1) {
                                                      context.router.push(
                                                          DietLogRoute(
                                                              summary: state
                                                                  .dietLogSummary,
                                                              homeBloc:
                                                                  homeStoriesBloc));
                                                    } else if (e.value.id ==
                                                        2) {
                                                      context.router.push(
                                                          ActivityLogRoute(
                                                              summary: state
                                                                  .activityLogSummary,
                                                              homeBloc:
                                                                  homeStoriesBloc));
                                                    } else {
                                                      new PerformanceLogBloc(
                                                          sl(), sl(),
                                                          homeStoriesBloc:
                                                              homeStoriesBloc)
                                                        ..add(LoadFromStory(
                                                            state.trackSummaries[
                                                                e.key],
                                                            e.value,
                                                            context));
                                                    }
                                                  }

                                                  print("Say");
                                                },
                                                filePath: e.value.icon,
                                                urlType: 0);
                                          }).toList(),

                                          // AffirmationCircleWidget(
                                          //     affirmationBloc: affirmationBloc),
                                          SizedBox(
                                            width: 4,
                                          ),
                                        ],
                                      ));
                                else if (state is HomeStoriesError)
                                  return MessageDisplay(message: state.message);
                                else if (state is HomeStoriesInitial)
                                  return Container(
                                      height: 140,
                                      child: ImagePlaceholderWidget());
                                else
                                  return Container(height: 0);
                              },
                            ),
                          ),
                        ]),
                  ),
                ],
              ))),
        ));
  }

  onClickWorkout(int id, int storyType, TrackModel track) {}

  onClickDiet(int id, int storyType, TrackModel track) {}

  Widget _buildWeightPopupDialog(BuildContext context) {
    print("helloooo");
    return StatefulBuilder(builder: (context, setState) {
      return new AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            height: Gparam.height / 2,
            width: Gparam.width,
            child: WeightCard(
              onGoBack: onGoBack,
              weight: weight,
              onChanged: (val) {
                setState(() => weight = val);
                print(val);
              },
            ),
          ));
    });
  }

  void onGoBack(void value) {}
}

class AffirmationCircleWidget extends StatelessWidget {
  const AffirmationCircleWidget({
    Key key,
    @required this.affirmationBloc,
  }) : super(key: key);

  final AffirmationBloc affirmationBloc;

  String getAffirmationString(DateTime dateTime) {
    if (dateTime.hour > 19 || (dateTime.hour > 0 && dateTime.hour < 3)) {
      return "Bedtime\nAffirmations";
    } else if (dateTime.hour >= 3 && dateTime.hour < 15)
      return "Sunshine\nAffirmations";
    return "Affirmations";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocProvider(
            create: (_) => affirmationBloc,
            child: BlocListener<AffirmationBloc, AffirmationState>(
                listener: (context, state) {},
                child: BlocBuilder<AffirmationBloc, AffirmationState>(
                    builder: (context, state) {
                  if (state is InitialState) {
                    return GestureDetector(
                      onTap: () async {
                        print("heeeeeelo");
                        //print(affirmationBloc);

                        // BlocProvider.of<AffirmationBloc>(context)
                        //     .add(LoadStories());

                        print("heeeeeelo1");
                      },
                      child: UnicornOutlineButton(
                        strokeWidth: 2,
                        radius: 100,
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColorLight,
                            Theme.of(context).accentColor,
                            Theme.of(context).backgroundColor
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        onPressed: null,
                        child: Hero(
                            tag: "thumbnail" + 0.toString(),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                    height: 70,
                                    width: 70,
                                    margin: EdgeInsets.all(2),
                                    decoration: new BoxDecoration(
                                      borderRadius: new BorderRadius.all(
                                          Radius.circular(60.0)),
                                      border: null,
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(1, 1),
                                            color: Colors.black.withAlpha(40),
                                            blurRadius: 10)
                                      ],
                                      gradient: new LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            Colors.transparent,
                                          ],
                                          begin: FractionalOffset.topCenter,
                                          end: FractionalOffset.bottomCenter,
                                          stops: [1.0, 0.0],
                                          tileMode: TileMode.clamp),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(60.0),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/home%2Faffirmation.jpg?alt=media&token=a5e30e61-4501-4479-8223-fab5080a6f25",
                                              fit: BoxFit.cover,
                                              height: 70,
                                              width: 70,
                                              errorWidget:
                                                  (context, url, error) => Icon(
                                                Icons.error,
                                                color: Colors.grey,
                                              ),
                                            )),
                                      ],
                                    )),
                                Text("Initial")
                              ],
                            )),
                      ),
                    );
                  } else if (state is LoadingState) {
                    return UnicornOutlineButton(
                        strokeWidth: 2,
                        radius: 100,
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColorLight,
                            Theme.of(context).accentColor,
                            Theme.of(context).backgroundColor
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        onPressed: null,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    height: 70,
                                    width: 70,
                                    margin: EdgeInsets.all(2),
                                    decoration: new BoxDecoration(
                                      borderRadius: new BorderRadius.all(
                                          Radius.circular(60.0)),
                                      border: null,
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(1, 1),
                                            color: Colors.black.withAlpha(40),
                                            blurRadius: 10)
                                      ],
                                      gradient: new LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            Colors.transparent,
                                          ],
                                          begin: FractionalOffset.topCenter,
                                          end: FractionalOffset.bottomCenter,
                                          stops: [1.0, 0.0],
                                          tileMode: TileMode.clamp),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(60.0),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/home%2Faffirmation.jpg?alt=media&token=a5e30e61-4501-4479-8223-fab5080a6f25",
                                              fit: BoxFit.cover,
                                              height: 70,
                                              width: 70,
                                              errorWidget:
                                                  (context, url, error) => Icon(
                                                Icons.error,
                                                color: Colors.grey,
                                              ),
                                            )),
                                      ],
                                    )),
                              ],
                            ),
                            Container(
                              height: 70,
                              width: 70,
                              child: CircularProgressIndicator(),
                            ),
                            Text("Loading")
                          ],
                        ));
                  } else if (state is Error) {
                    return Container(
                      width: 0,
                      height: 0,
                    );
                  } else if (state is LoadedState) {
                    return UnicornOutlineButton(
                      strokeWidth: 2,
                      radius: 100,
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColorLight,
                          Theme.of(context).accentColor,
                          Theme.of(context).backgroundColor
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      onPressed: () {
                        context.router.push(
                          AffirmationPV(
                              affirmations:
                                  (affirmationBloc.state as LoadedState)
                                      .affirmations,
                              startIndex: 0,
                              outerBloc: affirmationBloc),
                        );
                      },
                      child: Hero(
                          tag: "thumbnail" + 0.toString(),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                  height: 70,
                                  width: 70,
                                  margin: EdgeInsets.all(2),
                                  decoration: new BoxDecoration(
                                    borderRadius: new BorderRadius.all(
                                        Radius.circular(60.0)),
                                    border: null,
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(1, 1),
                                          color: Colors.black.withAlpha(40),
                                          blurRadius: 10)
                                    ],
                                    gradient: new LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          Colors.transparent,
                                        ],
                                        begin: FractionalOffset.topCenter,
                                        end: FractionalOffset.bottomCenter,
                                        stops: [1.0, 0.0],
                                        tileMode: TileMode.clamp),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(60.0),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/home%2Faffirmation.jpg?alt=media&token=a5e30e61-4501-4479-8223-fab5080a6f25",
                                            fit: BoxFit.cover,
                                            height: 70,
                                            errorWidget:
                                                (context, url, error) => Icon(
                                              Icons.error,
                                              color: Colors.grey,
                                            ),
                                            width: 70,
                                          )),
                                    ],
                                  )),
                              Text("Loaded")
                            ],
                          )),
                    );
                  } else
                    return Container(height: 0);
                }))),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(getAffirmationString(DateTime.now()),
              textAlign: TextAlign.center,
              style: TextStyle(
                  letterSpacing: -.3,
                  fontFamily: 'Milliard',
                  fontSize: Gparam.textExtraSmall,
                  fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
}
