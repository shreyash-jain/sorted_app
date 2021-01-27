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
import 'package:sorted/core/theme/theme.dart';
import 'package:sorted/features/PROFILE/presentation/bloc/profile_bloc.dart';

class ProfilePage extends StatefulWidget {
  Function() triggerRefetch;
  Function(Brightness brightness) changeTheme;

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
}

class _ProfileState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  String name = "Shreyash Jain";
  String user_image = 'assets/images/male1.png';
  ProfileBloc bloc;
  Widget _tabBarView;

  List<int> activity_position;
  ScrollController scrollController = ScrollController();

  var tab_controller;
  @override
  void initState() {
    bloc = ProfileBloc(sl())..add(LoadProfile());

    super.initState();
    tab_controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "sorted_aadmi",
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
                  BlocProvider(
                      create: (context) => bloc,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(0)),
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(
                                    left: Gparam.widthPadding / 2),
                                alignment: Alignment.center,
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Hero(
                                                tag: "DemoTag",
                                                transitionOnUserGestures: true,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 0, bottom: 0),
                                                  child: Stack(
                                                    children: <Widget>[
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    16)),
                                                        child: Image(
                                                          image: NetworkImage(
                                                            "https://lh3.googleusercontent.com/-zWKfKmIX5nQ/YAqy9xUKSzI/AAAAAAAAur0/R5NLZjI-sagwMXt029xu4jc6Ch2ir7AawCEwYBhgLKtQDAL1OcqyUJu0SrbcXZ5R78z8MImj71HIH5PXCXpw4lX3goXCPju_yiEmASXIATZ0oLt20pWM2p0jnd1Co5mNdq85SlvPQuxmU0DmKnMF-qPepBvuNE9XUjVzpdA8X7rFDhfu5nSBdGRdTIuL7_C2L9B9eHUCDVElVN9BqhnQtFqN_nX2mjPpNb-RqmdmqtJxahgeKZFzBgFG8YS-x3bDRATlJ3SaW0rvh9WPYRaEwyhErVmqrX0Hj0HochEH-JbnecGhF9ohTWZiS1KfJH71Ufvz3GsKYnpl6bYWFnI8qQVPe0Phj8-C6vzmVBMYEFIpsQdXhgg0nWx8NGuV3ckMXU5CPtZFW3-yYSLBV0DvzEjau4jiPyeyft60b3LfpGdD6u72pvHaco6LqxF0NAvHoBQ1mVuZchQWqqhighhfV-s__t9DKI5D4PNMgM_covknydDkVQHAE5YZSMQ891NcNDT-ux0HAqtimSGtc4Zffha39jbqCw20InZ3TgD9mIKDN_tXHB4BGYhEYQGpDL6m3zrwHCIwLN0cl6lubR_YL9qaMTzeq0ZbEeMDQCa5jY-fJQG_MvtnpSgplVoJb8VWj7dRvjBqFTkoNCRulGSMs-ldyZGn0MKSet4AG/w140-h140-p/2021-01-22.jpg",
                                                          ),
                                                          height: 80,
                                                          width: 80,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Icon(
                                                  MdiIcons.starCircle,
                                                  size: 16,
                                                ),
                                                SizedBox(
                                                  width: 3,
                                                ),
                                                Text(
                                                  "Level",
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Theme.of(context)
                                                          .highlightColor),
                                                  textAlign: TextAlign.left,
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(4),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                30)),
                                                  ),
                                                  child: Text(
                                                    "3",
                                                    style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: Gparam.width -
                                              80 -
                                              Gparam.widthPadding / 2,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          Text(
                                                            "Tracks",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Montserrat',
                                                                fontSize: 12.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Theme.of(
                                                                        context)
                                                                    .highlightColor),
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(4),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          30)),
                                                        ),
                                                        child: Text(
                                                          "5",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                        "Score",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontSize: 12.0,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Theme.of(
                                                                    context)
                                                                .highlightColor),
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(4),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          30)),
                                                        ),
                                                        child: Text(
                                                          "48",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                        "Fit buddies",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontSize: 12.0,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Theme.of(
                                                                    context)
                                                                .highlightColor),
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(4),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          30)),
                                                        ),
                                                        child: Text(
                                                          "5",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              CustomThreeLinearProgressBar(
                                                radius: (Gparam.width -
                                                        100 -
                                                        Gparam.widthPadding /
                                                            2) /
                                                    2.6,
                                                ringColor:
                                                    Color(0xFF63056e),
                                                dotRadius: 40,
                                                shadowWidth: 4.0,
                                                progress1: .1,
                                                progress2: .3,
                                                progress3: .4,
                                                shadowColor:
                                                    Colors.greenAccent,
                                                dotColor: Colors.blueAccent,
                                              ),
                                              SizedBox(
                                                height: 6,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(4),
                                                        margin:
                                                            EdgeInsets.all(4),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: Theme.of(
                                                                      context)
                                                                  .highlightColor,
                                                              width: 1.5),
                                                          color: Theme.of(
                                                                  context)
                                                              .highlightColor
                                                              .withAlpha(20),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          30)),
                                                        ),
                                                        child: Text(
                                                          "+5 %",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontSize: 12,
                                                            color: Colors.green,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 3,
                                                      ),
                                                      Row(
                                                        children: <Widget>[
                                                          Container(
                                                            height: 8,
                                                            width: 8,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                  0xFF307df0),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          .03),
                                                                  width: 2),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    offset:
                                                                        Offset(
                                                                            1,
                                                                            1),
                                                                    color: Colors
                                                                        .black
                                                                        .withAlpha(
                                                                            10),
                                                                    blurRadius:
                                                                        2)
                                                              ],
                                                              borderRadius:
                                                                  new BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          12.0)),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 6,
                                                          ),
                                                          Text(
                                                            "Fitness",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Montserrat',
                                                                fontSize: 12.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Theme.of(
                                                                        context)
                                                                    .highlightColor),
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(4),
                                                        margin:
                                                            EdgeInsets.all(4),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: Theme.of(
                                                                      context)
                                                                  .highlightColor,
                                                              width: 1.5),
                                                          color: Theme.of(
                                                                  context)
                                                              .highlightColor
                                                              .withAlpha(20),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          30)),
                                                        ),
                                                        child: Text(
                                                          "+15 %",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontSize: 12,
                                                            color: Colors.green,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 3,
                                                      ),
                                                      Row(
                                                        children: <Widget>[
                                                          Container(
                                                            height: 8,
                                                            width: 8,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                  0xFF0ec76a),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          .03),
                                                                  width: 2),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    offset:
                                                                        Offset(
                                                                            1,
                                                                            1),
                                                                    color: Colors
                                                                        .black
                                                                        .withAlpha(
                                                                            10),
                                                                    blurRadius:
                                                                        2)
                                                              ],
                                                              borderRadius:
                                                                  new BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          12.0)),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 6,
                                                          ),
                                                          Text(
                                                            "Mindfulness",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Montserrat',
                                                                fontSize: 12.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Theme.of(
                                                                        context)
                                                                    .highlightColor),
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(4),
                                                        margin:
                                                            EdgeInsets.all(4),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: Theme.of(
                                                                      context)
                                                                  .highlightColor,
                                                              width: 1.5),
                                                          color: Theme.of(
                                                                  context)
                                                              .highlightColor
                                                              .withAlpha(20),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          30)),
                                                        ),
                                                        child: Text(
                                                          "-13 %",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontSize: 12,
                                                            color: Colors.red,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 3,
                                                      ),
                                                      Row(
                                                        children: <Widget>[
                                                          Container(
                                                            height: 8,
                                                            width: 8,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                  0xFF63056e),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          .03),
                                                                  width: 2),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    offset:
                                                                        Offset(
                                                                            1,
                                                                            1),
                                                                    color: Colors
                                                                        .black
                                                                        .withAlpha(
                                                                            10),
                                                                    blurRadius:
                                                                        2)
                                                              ],
                                                              borderRadius:
                                                                  new BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          12.0)),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 6,
                                                          ),
                                                          Text(
                                                            "Productivity",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Montserrat',
                                                                fontSize: 12.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Theme.of(
                                                                        context)
                                                                    .highlightColor),
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                  ],
                                )),
                            Divider(
                              color: Colors.grey,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: Gparam.widthPadding / 2),
                                    child: Text(
                                      name,
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: Gparam.textVerySmall,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Theme.of(context).highlightColor),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: Gparam.widthPadding / 2),
                                    child: Text(
                                      "You know what, health is wealth",
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: Gparam.textVerySmall,
                                          fontWeight: FontWeight.w300,
                                          color:
                                              Theme.of(context).highlightColor),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  BlocBuilder<ProfileBloc, ProfileState>(
                                    builder: (context, state) {
                                      if (state is ProfileLoaded)
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(
                                                  left:
                                                      Gparam.widthPadding / 2),
                                              height: 20,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    state.foodStrings.length +
                                                        1,
                                                shrinkWrap: true,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  if (index == 0) {
                                                    return Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              MdiIcons
                                                                  .foodAppleOutline,
                                                              size: 14,
                                                            ),
                                                            SizedBox(
                                                              width: 8,
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    );
                                                  }

                                                  return stringPersonality(
                                                    (state.foodStrings)[
                                                        index - 1],
                                                  );
                                                },
                                              ),
                                            ),
                                            Container(
                                                padding: EdgeInsets.only(
                                                    left: Gparam.widthPadding /
                                                        2),
                                                height: 20,
                                                child: GestureDetector(
                                                  onTap: () {},
                                                  child: Container(
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Icon(
                                                          MdiIcons
                                                              .bellSleepOutline,
                                                          size: 14,
                                                        ),
                                                        SizedBox(
                                                          width: 8,
                                                        ),
                                                        Text(
                                                          state.sleepString,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Montserrat',
                                                              fontSize: Gparam
                                                                  .textVerySmall,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Theme.of(
                                                                      context)
                                                                  .highlightColor
                                                                  .withOpacity(
                                                                      .6)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                            Container(
                                              height: 24,
                                              padding: EdgeInsets.only(
                                                  left:
                                                      Gparam.widthPadding / 2),
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: state
                                                        .personalityStrings
                                                        .length +
                                                    1,
                                                shrinkWrap: true,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  if (index == 0) {
                                                    return Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              MdiIcons
                                                                  .faceOutline,
                                                              size: 14,
                                                            ),
                                                            SizedBox(
                                                              width: 8,
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    );
                                                  }

                                                  return stringPersonality(
                                                    (state.personalityStrings)[
                                                        index - 1],
                                                  );
                                                },
                                              ),
                                            ),
                                            Divider(
                                              color: Colors.grey,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left:
                                                      Gparam.widthPadding / 2),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    MdiIcons.run,
                                                    color: Color(0xFF307df0),
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Container(
                                                    width: 2,
                                                    height: 60,
                                                    color: Color(0xFF307df0),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                          top: 0, bottom: 0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        Gparam.widthPadding /
                                                                            2,
                                                                    vertical:
                                                                        4),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "BMI",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Montserrat',
                                                                      fontSize:
                                                                          Gparam
                                                                              .textVerySmall,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .highlightColor),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                ),
                                                                Text(
                                                                  " " +
                                                                      state.bmi
                                                                          .toStringAsPrecision(
                                                                              3),
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Montserrat',
                                                                      fontSize:
                                                                          Gparam
                                                                              .textVerySmall,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w800,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .highlightColor),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 30,
                                                            child: ListView
                                                                .builder(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              itemCount: state
                                                                      .fitnessStrings
                                                                      .length +
                                                                  1,
                                                              shrinkWrap: true,
                                                              itemBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      int index) {
                                                                if (index ==
                                                                    0) {
                                                                  return SizedBox(
                                                                      width:
                                                                          Gparam.widthPadding /
                                                                              3);
                                                                }

                                                                return stringTile(
                                                                  state.fitnessStrings[
                                                                      index -
                                                                          1],
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left:
                                                      Gparam.widthPadding / 2),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    MdiIcons.meditation,
                                                    color: Color(0xFF0ec76a),
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Container(
                                                    width: 2,
                                                    height: 60,
                                                    color: Color(0xFF0ec76a),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                          top: 0, bottom: 0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        Gparam.widthPadding /
                                                                            2,
                                                                    vertical:
                                                                        4),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "Mental Score",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Montserrat',
                                                                      fontSize:
                                                                          Gparam
                                                                              .textVerySmall,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .highlightColor),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                ),
                                                                Text(
                                                                  " " +
                                                                      state
                                                                          .mentalHealthScore
                                                                          .toStringAsPrecision(
                                                                              3),
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Montserrat',
                                                                      fontSize:
                                                                          Gparam
                                                                              .textVerySmall,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w800,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .highlightColor),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 30,
                                                            child: ListView
                                                                .builder(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              itemCount: state
                                                                      .mindfulStrings
                                                                      .length +
                                                                  1,
                                                              shrinkWrap: true,
                                                              itemBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      int index) {
                                                                if (index ==
                                                                    0) {
                                                                  return SizedBox(
                                                                      width:
                                                                          Gparam.widthPadding /
                                                                              3);
                                                                }

                                                                return stringTile(
                                                                  state.mindfulStrings[
                                                                      index -
                                                                          1],
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left:
                                                      Gparam.widthPadding / 2),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    MdiIcons.headFlash,
                                                    color: Color(0xFF63056e),
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Container(
                                                    width: 2,
                                                    height: 60,
                                                    color: Color(0xFF63056e),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                          top: 0, bottom: 0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        Gparam.widthPadding /
                                                                            2,
                                                                    vertical:
                                                                        4),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "Productivity Score",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Montserrat',
                                                                      fontSize:
                                                                          Gparam
                                                                              .textVerySmall,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .highlightColor),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                ),
                                                                Text(
                                                                  " " +
                                                                      state
                                                                          .productivityScore
                                                                          .toStringAsPrecision(
                                                                              3),
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Montserrat',
                                                                      fontSize:
                                                                          Gparam
                                                                              .textVerySmall,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w800,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .highlightColor),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 30,
                                                            child: ListView
                                                                .builder(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              itemCount: state
                                                                      .productivityStrings
                                                                      .length +
                                                                  1,
                                                              shrinkWrap: true,
                                                              itemBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      int index) {
                                                                if (index ==
                                                                    0) {
                                                                  return SizedBox(
                                                                      width:
                                                                          Gparam.widthPadding /
                                                                              3);
                                                                }

                                                                return stringTile(
                                                                  state.productivityStrings[
                                                                      index -
                                                                          1],
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      if (state is ProfileInitial) {
                                        return Container(
                                          width: 0,
                                          height: 0,
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                ]),
              ),
              SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
  }

  Widget stringTile(
    String s,
  ) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(right: 4),
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
              color: Theme.of(context).highlightColor.withOpacity(.2),
              width: 1),
          boxShadow: [
            BoxShadow(
                offset: Offset(1, 1),
                color: Colors.black.withAlpha(2),
                blurRadius: 2)
          ],
          borderRadius: new BorderRadius.all(Radius.circular(12.0)),
        ),
        child: Text(
          s,
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: Gparam.textVerySmall,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).highlightColor.withOpacity(.6)),
        ),
      ),
    );
  }

  Widget stringPersonality(
    String s,
  ) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        child: Text(
          s + "  •  ",
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: Gparam.textVerySmall,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).highlightColor.withOpacity(.6)),
        ),
      ),
    );
  }
}
