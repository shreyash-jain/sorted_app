import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/animations/fade_animationTB.dart';
import 'package:sorted/core/global/animations/progress_goal.dart';
import 'package:sorted/core/global/animations/three_progress.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/core/routes/router.gr.dart';
import 'package:sorted/core/theme/theme.dart';
import 'package:sorted/features/FEED/presentation/widgets/track_diet_activity.dart';
import 'package:sorted/features/FEED/presentation/widgets/track_view_activity.dart';
import 'package:sorted/features/FEED/presentation/widgets/track_view_small.dart';
import 'package:sorted/features/HOME/presentation/home_stories_bloc/home_stories_bloc.dart';
import 'package:sorted/features/HOME/presentation/track_log_bloc/track_log_bloc.dart';
import 'package:sorted/features/PROFILE/presentation/bloc/profile_bloc.dart';
import 'package:sorted/features/PROFILE/presentation/widgets/person_display.dart';
import 'package:sorted/features/PROFILE/presentation/widgets/profile_top.dart';
import 'package:sorted/features/TRACKERS/COMMON/performance_track_data/track_data.dart';
import 'package:sorted/features/TRACKERS/COMMON/performance_track_data/track_property_data.dart';
import 'package:auto_route/auto_route.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage(
      {Key key,
      Function() triggerRefetch,
      this.title,
      Function(Brightness brightness) changeTheme})
      : super(key: key) {
    this.changeTheme = changeTheme;
    this.triggerRefetch = triggerRefetch;
  }

  final String title;

  @override
  _ProfileState createState() => _ProfileState();

  Function() triggerRefetch;

  Function(Brightness brightness) changeTheme;
}

class _ProfileState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  List<int> activity_position;
  ProfileBloc bloc;
  String name = "Shreyash Jain";
  ScrollController scrollController = ScrollController();
  var tab_controller;
  String user_image = 'assets/images/male1.png';

  Widget _tabBarView;

  @override
  void initState() {
    bloc = ProfileBloc(sl(), sl(), sl())..add(LoadProfile());

    super.initState();
    tab_controller = TabController(length: 1, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<ProfileBloc>(
            create: (BuildContext context) => bloc,
          ),
          BlocProvider<HomeStoriesBloc>(
            create: (BuildContext context) => sl<HomeStoriesBloc>(),
          ),
        ],
        child:
            BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
          if (state is ProfileLoaded)
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 2,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      state.details.name,
                      style: TextStyle(
                          fontFamily: 'Milliard',
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: Theme.of(context).highlightColor),
                      overflow: TextOverflow.clip,
                      softWrap: false,
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            bloc.add(Signout());

                            context.router
                                .replaceAll([SplashRoute(), OnboardRoute()]);
                          },
                          child: Text(
                            "Sign out",
                            style: TextStyle(
                                fontFamily: 'Milliard',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Theme.of(context).highlightColor),
                            overflow: TextOverflow.clip,
                            softWrap: false,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        InkWell(
                          onTap: () {
                            context.router
                                .push(ProfileEditRoute(profileBloc: bloc));
                          },
                          child: Text(
                            "Edit profile",
                            style: TextStyle(
                                fontFamily: 'Milliard',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Theme.of(context).highlightColor),
                            overflow: TextOverflow.clip,
                            softWrap: false,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              body: DefaultTabController(
                length: 1,
                child: NestedScrollView(
                  headerSliverBuilder: (context, _) {
                    return [
                      SliverList(
                        delegate: SliverChildListDelegate([
                          ProfileTop(
                              name: state.details.userName, state: state),
                        ]),
                      ),
                      SliverAppBar(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        pinned: true,
                        primary: false, // no reserve space for status bar
                        toolbarHeight: 0, // title height = 0
                        bottom: TabBar(
                          indicatorWeight: 1,
                          controller: tab_controller,
                          indicatorColor: Theme.of(context).highlightColor,
                          tabs: [
                            Tab(
                              icon: Icon(
                                Icons.timeline,
                                color: Theme.of(context).highlightColor,
                              ),
                              child: Text(
                                "Tracks",
                                style: TextStyle(
                                    fontFamily: 'Milliard',
                                    fontSize: Gparam.textVerySmall,
                                    fontWeight: FontWeight.w800,
                                    color: Theme.of(context).highlightColor),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      )
                    ];
                  },
                  body: TabBarView(
                    controller: tab_controller,
                    children: [
                      BlocBuilder<HomeStoriesBloc, HomeStoriesState>(
                        builder: (context, homestate) {
                          if (homestate is HomeStoriesLoaded)
                            return Container(
                              color: Colors.grey.shade200,
                              child: ListView(
                                padding: EdgeInsets.zero,
                                children: [
                                  BlocProvider(
                                    create: (context) => PerformanceLogBloc(
                                        sl(), sl(),
                                        homeStoriesBloc: sl<HomeStoriesBloc>())
                                      ..add(LoadDietlogStory(
                                          homestate.dietLogSummary)),
                                    child: ProfileTrackDietView(
                                      track: homestate.subsTracks[0],
                                      onClick: () {
                                        context.router.push(DietLogRoute(
                                            summary: homestate.dietLogSummary,
                                            homeBloc: sl<HomeStoriesBloc>()));
                                      },
                                    ),
                                  ),
                                  BlocProvider(
                                    create: (context) => PerformanceLogBloc(
                                        sl(), sl(),
                                        homeStoriesBloc: sl<HomeStoriesBloc>())
                                      ..add(LoadActivityStory(
                                          homestate.activityLogSummary)),
                                    child: ProfileTrackActivityView(
                                      track: homestate.subsTracks[1],
                                      onClick: () {
                                        context.router.push(ActivityLogRoute(
                                            summary:
                                                homestate.activityLogSummary,
                                            homeBloc: sl<HomeStoriesBloc>()));
                                      },
                                    ),
                                  ),
                                  ...homestate.subsTracks
                                      .skip(2)
                                      .toList()
                                      .asMap()
                                      .entries
                                      .map(
                                        (e) => ProfileTrackView(
                                          track: e.value,
                                          property: getAllProperties()
                                              .firstWhere((element) =>
                                                  e.value.primary_property_id ==
                                                  element.id),
                                          onClick: () {
                                            context.router.push(
                                                PerformanceAnalysisRoute(
                                                    track: e.value,
                                                    summary: homestate
                                                        .trackSummaries
                                                        .skip(2)
                                                        .toList()[e.key]));
                                          },
                                          summary: homestate.trackSummaries
                                              .skip(2)
                                              .toList()[e.key],
                                        ),
                                      ),
                                  SizedBox(
                                    height: 100,
                                  ),
                                ],
                              ),
                            );
                          else
                            return Container(
                              height: 00,
                            );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          else if (state is ProfileInitial)
            return LoadingWidget();
          else
            return Container(
              height: 0,
            );
        }));
  }
}
