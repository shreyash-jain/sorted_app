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
import 'package:sorted/core/theme/theme.dart';
import 'package:sorted/features/PROFILE/presentation/bloc/profile_bloc.dart';
import 'package:sorted/features/PROFILE/presentation/widgets/person_display.dart';
import 'package:sorted/features/PROFILE/presentation/widgets/profile_top.dart';

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
    bloc = ProfileBloc(sl())..add(LoadProfile());

    super.initState();
    tab_controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => bloc,
        child:
            BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
          if (state is ProfileLoaded)
            return Scaffold(
              backgroundColor: Theme.of(context).primaryColor,
              appBar: AppBar(
                elevation: 2,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      state.details.userName,
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: Theme.of(context).highlightColor),
                      overflow: TextOverflow.clip,
                      softWrap: false,
                    ),
                    Text(
                      "Edit profile",
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Theme.of(context).highlightColor),
                      overflow: TextOverflow.clip,
                      softWrap: false,
                    ),
                  ],
                ),
              ),
              body: DefaultTabController(
                length: 3,
                child: NestedScrollView(
                  headerSliverBuilder: (context, _) {
                    return [
                      SliverList(
                        delegate: SliverChildListDelegate([
                          ProfileTop(name: name, state: state),
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
                                    fontFamily: 'Montserrat',
                                    fontSize: Gparam.textVerySmall,
                                    fontWeight: FontWeight.w800,
                                    color: Theme.of(context).highlightColor),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Tab(
                              icon: Icon(
                                MdiIcons.postOutline,
                                color: Theme.of(context).highlightColor,
                              ),
                              child: Text(
                                "Posts",
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: Gparam.textVerySmall,
                                    fontWeight: FontWeight.w800,
                                    color: Theme.of(context).highlightColor),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Tab(
                              icon: Icon(
                                MdiIcons.timelineTextOutline,
                                color: Theme.of(context).highlightColor,
                              ),
                              child: Text(
                                "Journal",
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
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
                      GridView.count(
                        padding: EdgeInsets.zero,
                        crossAxisCount: 3,
                        children: Colors.primaries.map((color) {
                          return Container(color: color, height: 150.0);
                        }).toList(),
                      ),
                      ListView(
                        padding: EdgeInsets.zero,
                        children: Colors.primaries.map((color) {
                          return Container(color: color, height: 150.0);
                        }).toList(),
                      ),
                      GridView.count(
                        padding: EdgeInsets.zero,
                        crossAxisCount: 3,
                        children: Colors.primaries.map((color) {
                          return Container(color: color, height: 150.0);
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          else if (state is ProfileInitial) return LoadingWidget();
        }));
  }
}

