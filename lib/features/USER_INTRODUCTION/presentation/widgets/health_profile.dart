import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/global/animations/fade_animationTB.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/features/ONBOARDING/presentation/bloc/onboarding_bloc.dart';

import 'package:sorted/features/USER_INTRODUCTION/data/models/user_tag.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/constants.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/flow_bloc/flow_bloc.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/health_profile_bloc/health_profile_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/pages/loginDetails.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/widgets/height_widget/height_card.dart';

import 'package:sorted/features/USER_INTRODUCTION/presentation/widgets/progressBar.dart';

import 'package:sorted/features/USER_INTRODUCTION/presentation/widgets/weight_widget.dart/weight_card.dart';

class HealthProfileWidget extends StatefulWidget {
  final int currentPage;
  final LoginPage loginWidget;
  const HealthProfileWidget({
    Key key,
    this.loginWidget,
    this.currentPage,
  }) : super(key: key);

  @override
  _HealthProfileWidgetState createState() => _HealthProfileWidgetState();
}

class _HealthProfileWidgetState extends State<HealthProfileWidget> {
  final controller = TextEditingController();
  String inputStr;
  int height = 170;
  int weight = 70;

  FocusNode ageFocus = FocusNode();

  ScrollController _scrollController;
  HealthProfileBloc bloc;
  TextEditingController ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController(
      // NEW
      initialScrollOffset: 0.0, // NEW
      keepScrollOffset: true, // NEW
    );
    if (mounted)
      bloc = HealthProfileBloc(
          repository: sl(),
          flowBloc: BlocProvider.of<UserIntroductionBloc>(context))
        ..add(LoadProfile());

    print("Login Body");
  }

  void _toEnd() {
    // NEW
    _scrollController.animateTo(
      // NEW
      _scrollController.position.maxScrollExtent, // NEW
      duration: const Duration(milliseconds: 500), // NEW
      curve: Curves.ease, // NEW
    ); // NEW
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: ListView(
        children: <Widget>[
          Container(
            height: 80,
            margin: EdgeInsets.only(top: Gparam.heightPadding),
            child: Stack(
              children: [
                Row(children: <Widget>[
                  Container(
                      height: Gparam.height / 10,
                      width: (Gparam.width / 1),
                      child: Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ProgressBar(
                                  currentPage: widget.currentPage,
                                  widget: widget.loginWidget)
                            ],
                          ),
                        ],
                      )),
                ]),
              ],
            ),
          ),
          AnimatedOpacity(
              duration: Duration(seconds: 1),
              curve: Curves.easeOutQuint,
              opacity: 1,
              child: FadeAnimationTB(
                .9,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocProvider(
                      create: (_) => bloc,
                      child:
                          BlocListener<HealthProfileBloc, HealthProfileState>(
                        listener: (context, state) {},
                        child:
                            BlocBuilder<HealthProfileBloc, HealthProfileState>(
                          builder: (context, state) {
                            if (state is LoadedState) {
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: Gparam.widthPadding,
                                          top: 0,
                                          bottom: Gparam.widthPadding),
                                      child: Row(
                                        children: [
                                          Container(
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black
                                                        .withOpacity(.03),
                                                    width: 2),
                                                boxShadow: [
                                                  BoxShadow(
                                                      offset: Offset(1, 1),
                                                      color: Colors.black
                                                          .withAlpha(10),
                                                      blurRadius: 2)
                                                ],
                                                borderRadius:
                                                    new BorderRadius.all(
                                                        Radius.circular(12.0)),
                                              ),
                                              child: Text("🏃")),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Container(
                                            child: Text(
                                              'Physical Fitness Profile',
                                              style: TextStyle(
                                                  fontFamily: 'Milliard',
                                                  fontSize: Gparam.textSmaller,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.black
                                                      .withOpacity(.8)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: Gparam.widthPadding / 2),
                                      padding: EdgeInsets.only(
                                          left: 2,
                                          bottom: Gparam.heightPadding / 2),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        border: Border.all(
                                            color: Colors.blueAccent, width: 1),
                                        boxShadow: [
                                          BoxShadow(
                                              offset: Offset(1, 1),
                                              color: Colors.black.withAlpha(2),
                                              blurRadius: 2)
                                        ],
                                        borderRadius: new BorderRadius.all(
                                            Radius.circular(12.0)),
                                      ),
                                      child: FadeAnimationTB(
                                          1.6,
                                          Container(
                                            child: ListView(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              children: [
                                                SizedBox(
                                                  height:
                                                      Gparam.heightPadding / 2,
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(8),
                                                  child: Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          showDialog(
                                                            context: context,
                                                            builder: (BuildContext
                                                                    context) =>
                                                                _buildHeightPopupDialog(
                                                                    context),
                                                          );
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Text("📏"),
                                                            SizedBox(
                                                              width: 12,
                                                            ),
                                                            Text(
                                                              'Height',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Milliard',
                                                                  fontSize: Gparam
                                                                      .textSmaller,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          .8)),
                                                            ),
                                                            SizedBox(
                                                              width: 12,
                                                            ),
                                                            Text(
                                                                state.healthProfile
                                                                        .height_cm
                                                                        .toString() +
                                                                    " cm",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Milliard',
                                                                    fontSize: Gparam
                                                                        .textSmaller,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            .8))),
                                                          ],
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      GestureDetector(
                                                        onTap: () {
                                                          showDialog(
                                                            context: context,
                                                            builder: (BuildContext
                                                                    context) =>
                                                                _buildWeightPopupDialog(
                                                                    context),
                                                          );
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Text("⚖️"),
                                                            SizedBox(
                                                              width: 12,
                                                            ),
                                                            Text(
                                                              'Weight',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Milliard',
                                                                  fontSize: Gparam
                                                                      .textSmaller,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          .8)),
                                                            ),
                                                            SizedBox(
                                                              width: 12,
                                                            ),
                                                            Text(
                                                                state.healthProfile
                                                                        .weight_kg
                                                                        .toInt()
                                                                        .toString() +
                                                                    " kg",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Milliard',
                                                                    fontSize: Gparam
                                                                        .textSmaller,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            .8))),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height:
                                                      Gparam.heightPadding / 2,
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(8),
                                                  child: Row(
                                                    children: [
                                                      Text("🔁"),
                                                      SizedBox(
                                                        width: 12,
                                                      ),
                                                      Text(
                                                        'Daily Fitness activity',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Milliard',
                                                            fontSize: Gparam
                                                                .textSmaller,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    .8)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(8),
                                                  child: Text(
                                                    'I generally ...',
                                                    style: TextStyle(
                                                        fontFamily: 'Milliard',
                                                        fontSize: Gparam
                                                            .textExtraSmall,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black
                                                            .withOpacity(.5)),
                                                  ),
                                                ),
                                                Container(
                                                    height: 36,
                                                    child: ListView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        children: [
                                                          fitnessActivityTile(
                                                              "Go on a walk/Run",
                                                              state
                                                                  .healthProfile
                                                                  .do_walk,
                                                              0),
                                                          fitnessActivityTile(
                                                              "Do Exercise",
                                                              state
                                                                  .healthProfile
                                                                  .do_exercise,
                                                              1),
                                                          fitnessActivityTile(
                                                              "Do Yoga",
                                                              state
                                                                  .healthProfile
                                                                  .do_yoga,
                                                              2),
                                                        ])),
                                                SizedBox(
                                                  height:
                                                      Gparam.heightPadding / 3,
                                                ),
                                                Container(
                                                    height: 36,
                                                    child: ListView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        children: [
                                                          fitnessActivityTile(
                                                              "Do Dance",
                                                              state
                                                                  .healthProfile
                                                                  .do_dance,
                                                              3),
                                                          fitnessActivityTile(
                                                              "Play Sports",
                                                              state
                                                                  .healthProfile
                                                                  .play_sports,
                                                              4),
                                                          fitnessActivityTile(
                                                              "Ride Cycle",
                                                              state
                                                                  .healthProfile
                                                                  .ride_cycle,
                                                              5),
                                                        ])),
                                                SizedBox(
                                                  height:
                                                      Gparam.heightPadding / 3,
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(8),
                                                  child: Row(
                                                    children: [
                                                      Checkbox(
                                                          value: true,
                                                          onChanged: null),
                                                      Text(
                                                        'I have a health condition',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Milliard',
                                                            fontSize: Gparam
                                                                .textSmaller,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    .8)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Divider(
                                                  color: Colors.black26,
                                                ),
                                                Container(
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(8),
                                                        child: Row(
                                                          children: [
                                                            Text("🎯"),
                                                            SizedBox(
                                                              width: 12,
                                                            ),
                                                            Text(
                                                              'My Fitness Goal',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Milliard',
                                                                  fontSize: Gparam
                                                                      .textSmaller,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          .8)),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: Gparam
                                                                .heightPadding /
                                                            3,
                                                      ),
                                                      Container(
                                                          height: 36,
                                                          child: ListView(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              children: [
                                                                fitnessGoalTile(
                                                                    "Stay Fit",
                                                                    state
                                                                        .healthProfile
                                                                        .goal_stay_fit,
                                                                    0),
                                                                fitnessGoalTile(
                                                                    "Gain Muscle",
                                                                    state
                                                                        .healthProfile
                                                                        .goal_gain_muscle,
                                                                    1),
                                                                fitnessGoalTile(
                                                                    "Lose Weight",
                                                                    state
                                                                        .healthProfile
                                                                        .goal_loose_weight,
                                                                    2),
                                                                fitnessGoalTile(
                                                                    "Be more Active",
                                                                    state
                                                                        .healthProfile
                                                                        .goal_get_more_active,
                                                                    3),
                                                              ])),
                                                      SizedBox(
                                                        height: Gparam
                                                                .heightPadding /
                                                            3,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                    ),
                                    SizedBox(
                                      height: Gparam.heightPadding,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: Gparam.widthPadding,
                                          top: 0,
                                          bottom: Gparam.heightPadding),
                                      child: Row(
                                        children: [
                                          Container(
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black
                                                        .withOpacity(.03),
                                                    width: 2),
                                                boxShadow: [
                                                  BoxShadow(
                                                      offset: Offset(1, 1),
                                                      color: Colors.black
                                                          .withAlpha(10),
                                                      blurRadius: 2)
                                                ],
                                                borderRadius:
                                                    new BorderRadius.all(
                                                        Radius.circular(12.0)),
                                              ),
                                              child: Text("🧠")),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Container(
                                            child: Text(
                                              'Mental Health Profile',
                                              style: TextStyle(
                                                  fontFamily: 'Milliard',
                                                  fontSize: Gparam.textSmaller,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.black
                                                      .withOpacity(.8)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: Gparam.widthPadding / 2),
                                      padding: EdgeInsets.only(
                                          left: 2,
                                          bottom: Gparam.heightPadding / 2),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        border: Border.all(
                                            color: Colors.greenAccent,
                                            width: 1),
                                        boxShadow: [
                                          BoxShadow(
                                              offset: Offset(1, 1),
                                              color: Colors.black.withAlpha(2),
                                              blurRadius: 2)
                                        ],
                                        borderRadius: new BorderRadius.all(
                                            Radius.circular(12.0)),
                                      ),
                                      child: FadeAnimationTB(
                                          1.6,
                                          Container(
                                            child: ListView(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              children: [
                                                SizedBox(
                                                  height:
                                                      Gparam.heightPadding / 2,
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(8),
                                                  child: Row(
                                                    children: [
                                                      Text("🔁"),
                                                      SizedBox(
                                                        width: 12,
                                                      ),
                                                      Text(
                                                        'Daily Mindful activity',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Milliard',
                                                            fontSize: Gparam
                                                                .textSmaller,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    .8)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(8),
                                                  child: Text(
                                                    'I generally ...',
                                                    style: TextStyle(
                                                        fontFamily: 'Milliard',
                                                        fontSize: Gparam
                                                            .textExtraSmall,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black
                                                            .withOpacity(.5)),
                                                  ),
                                                ),
                                                Container(
                                                    height: 36,
                                                    child: ListView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        children: [
                                                          mindfulActivityTile(
                                                              "Talk about my feelings",
                                                              state
                                                                  .healthProfile
                                                                  .do_talk_ablout_feelings,
                                                              0),
                                                          mindfulActivityTile(
                                                              "Enjoy my work",
                                                              state
                                                                  .healthProfile
                                                                  .do_enjoy_work,
                                                              1),
                                                        ])),
                                                SizedBox(
                                                  height:
                                                      Gparam.heightPadding / 3,
                                                ),
                                                Container(
                                                    height: 36,
                                                    child: ListView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        children: [
                                                          mindfulActivityTile(
                                                              "Do meditate",
                                                              state
                                                                  .healthProfile
                                                                  .do_meditation,
                                                              2),
                                                          mindfulActivityTile(
                                                              "Love my self",
                                                              state
                                                                  .healthProfile
                                                                  .do_love_self,
                                                              3),
                                                          mindfulActivityTile(
                                                              "Think positive",
                                                              state
                                                                  .healthProfile
                                                                  .do_stay_positive,
                                                              4),
                                                        ])),
                                                SizedBox(
                                                  height:
                                                      Gparam.heightPadding / 3,
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(8),
                                                  child: Row(
                                                    children: [
                                                      Checkbox(
                                                          value: true,
                                                          onChanged: null),
                                                      Text(
                                                        'I have a mental condition',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Milliard',
                                                            fontSize: Gparam
                                                                .textSmaller,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    .8)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Divider(
                                                  color: Colors.black26,
                                                ),
                                                Container(
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(8),
                                                        child: Row(
                                                          children: [
                                                            Text("🎯"),
                                                            SizedBox(
                                                              width: 12,
                                                            ),
                                                            Text(
                                                              'My mind Goal',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Milliard',
                                                                  fontSize: Gparam
                                                                      .textSmaller,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          .8)),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: Gparam
                                                                .heightPadding /
                                                            3,
                                                      ),
                                                      Container(
                                                          height: 36,
                                                          child: ListView(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              children: [
                                                                mindfulGoalTile(
                                                                    "Live in present",
                                                                    state
                                                                        .healthProfile
                                                                        .goal_live_in_present,
                                                                    0),
                                                                mindfulGoalTile(
                                                                    "Reduce stress",
                                                                    state
                                                                        .healthProfile
                                                                        .goal_reduce_stress,
                                                                    1),
                                                                mindfulGoalTile(
                                                                    "Get more sleep",
                                                                    state
                                                                        .healthProfile
                                                                        .goal_sleep_more,
                                                                    2),
                                                                mindfulGoalTile(
                                                                    "Control Anger",
                                                                    state
                                                                        .healthProfile
                                                                        .goal_control_anger,
                                                                    3),
                                                                mindfulGoalTile(
                                                                    "Control Thoughts",
                                                                    state
                                                                        .healthProfile
                                                                        .goal_control_thoughts,
                                                                    4),
                                                              ])),
                                                      SizedBox(
                                                        height: Gparam
                                                                .heightPadding /
                                                            3,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                    ),
                                    SizedBox(height: Gparam.heightPadding),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: Gparam.widthPadding,
                                          top: 0,
                                          bottom: Gparam.heightPadding),
                                      child: Row(
                                        children: [
                                          Container(
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black
                                                        .withOpacity(.03),
                                                    width: 1),
                                                boxShadow: [
                                                  BoxShadow(
                                                      offset: Offset(1, 1),
                                                      color: Colors.black
                                                          .withAlpha(10),
                                                      blurRadius: 2)
                                                ],
                                                borderRadius:
                                                    new BorderRadius.all(
                                                        Radius.circular(12.0)),
                                              ),
                                              child: Text("😇")),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Container(
                                            child: Text(
                                              'Lifestyle Profile',
                                              style: TextStyle(
                                                  fontFamily: 'Milliard',
                                                  fontSize: Gparam.textSmaller,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.black
                                                      .withOpacity(.8)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: Gparam.widthPadding / 2),
                                      padding: EdgeInsets.only(
                                          left: 2,
                                          bottom: Gparam.heightPadding / 2),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        border: Border.all(
                                            color: Colors.black12, width: 1),
                                        boxShadow: [
                                          BoxShadow(
                                              offset: Offset(1, 1),
                                              color: Colors.black.withAlpha(2),
                                              blurRadius: 2)
                                        ],
                                        borderRadius: new BorderRadius.all(
                                            Radius.circular(12.0)),
                                      ),
                                      child: FadeAnimationTB(
                                          1.6,
                                          Container(
                                            child: ListView(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              children: [
                                                SizedBox(
                                                  height:
                                                      Gparam.heightPadding / 2,
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(8),
                                                  child: Row(
                                                    children: [
                                                      Text("💤"),
                                                      SizedBox(
                                                        width: 12,
                                                      ),
                                                      Text(
                                                        'Sleep pattern',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Milliard',
                                                            fontSize: Gparam
                                                                .textSmaller,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    .8)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                    height: 36,
                                                    child: ListView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        children: [
                                                          sleepActivityTile(
                                                            "Early bird",
                                                            0,
                                                            "🐓",
                                                            state.healthProfile
                                                                .is_early_bird,
                                                          ),
                                                          sleepActivityTile(
                                                            "Night owl",
                                                            1,
                                                            "🦉",
                                                            state.healthProfile
                                                                .is_night_owl,
                                                          ),
                                                          sleepActivityTile(
                                                            "Humming bird",
                                                            2,
                                                            "🐦",
                                                            state.healthProfile
                                                                .is_humming_bird,
                                                          ),
                                                        ])),
                                                SizedBox(
                                                  height:
                                                      Gparam.heightPadding / 3,
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(8),
                                                  child: Row(
                                                    children: [
                                                      Text("🍏"),
                                                      SizedBox(
                                                        width: 12,
                                                      ),
                                                      Text(
                                                        'Food preference',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Milliard',
                                                            fontSize: Gparam
                                                                .textSmaller,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    .8)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                    height: 36,
                                                    child: ListView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        children: [
                                                          foodActivityTile(
                                                            "Vegetarian",
                                                            state.healthProfile
                                                                .is_vegetarian,
                                                            0,
                                                          ),
                                                          foodActivityTile(
                                                            "Vegan",
                                                            state.healthProfile
                                                                .is_vegan,
                                                            1,
                                                          ),
                                                          foodActivityTile(
                                                            "Keto",
                                                            state.healthProfile
                                                                .is_keto,
                                                            2,
                                                          ),
                                                          foodActivityTile(
                                                            "Sattvik",
                                                            state.healthProfile
                                                                .is_sattvik,
                                                            3,
                                                          ),
                                                        ])),
                                                SizedBox(
                                                  height:
                                                      Gparam.heightPadding / 2,
                                                )
                                              ],
                                            ),
                                          )),
                                    ),
                                    SizedBox(
                                      height: 90,
                                    )
                                  ],
                                ),
                              );
                            } else if (state is LoadingState) {
                              return LoadingWidget();
                            }
                            return Container();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildHeightPopupDialog(BuildContext context) {
    print("helloooo");
    return StatefulBuilder(builder: (context, setState) {
      return new AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            height: Gparam.height,
            width: Gparam.width,
            child: HeightCard(
              onGoBack: (context) {
                Navigator.pop(context);
              },
              height: height,
              onChanged: (val) {
                setState(() => height = val);
                print(val);
                bloc.add(UpdateHeight(val.toDouble()));
              },
            ),
          ));
    });
  }

  Widget _buildWeightPopupDialog(BuildContext context) {
    print("helloooo");
    return StatefulBuilder(builder: (context, setState) {
      return new AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            height: Gparam.height / 2,
            width: Gparam.width,
            child: WeightCard(
              onGoBack: (context) {
                Navigator.pop(context);
              },
              weight: weight,
              onChanged: (val) {
                setState(() => weight = val);
                print(val);
                bloc.add(UpdateWeight(val.toDouble()));
              },
            ),
          ));
    });
  }

  Widget fitnessActivityTile(String s, int value, int i) {
    return GestureDetector(
      onTap: () {
        handleFitnessActivityTap(i);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
              color:
                  (value == 0) ? Colors.black.withOpacity(.03) : Colors.black87,
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
              fontFamily: 'Milliard',
              fontSize: Gparam.textSmaller,
              fontWeight: FontWeight.w500,
              color: Colors.black.withOpacity(.8)),
        ),
      ),
    );
  }

  Widget foodActivityTile(String s, int value, int i) {
    return GestureDetector(
      onTap: () {
        handleFoodActivityTap(i);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
              color:
                  (value == 0) ? Colors.black.withOpacity(.03) : Colors.black87,
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
              fontFamily: 'Milliard',
              fontSize: Gparam.textSmaller,
              fontWeight: FontWeight.w500,
              color: Colors.black.withOpacity(.8)),
        ),
      ),
    );
  }

  Widget sleepActivityTile(String s, int i, String e, int value) {
    return GestureDetector(
      onTap: () {
        handleSleepActivityTap(i);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
              color:
                  (value == 0) ? Colors.black.withOpacity(.03) : Colors.black87,
              width: 1),
          boxShadow: [
            BoxShadow(
                offset: Offset(1, 1),
                color: Colors.black.withAlpha(2),
                blurRadius: 2)
          ],
          borderRadius: new BorderRadius.all(Radius.circular(12.0)),
        ),
        child: Row(
          children: [
            Text(
              e,
              style: TextStyle(
                  fontFamily: 'Milliard',
                  fontSize: Gparam.textSmaller,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(.8)),
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              s,
              style: TextStyle(
                  fontFamily: 'Milliard',
                  fontSize: Gparam.textSmaller,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(.8)),
            ),
          ],
        ),
      ),
    );
  }

  Widget mindfulActivityTile(String s, int value, int i) {
    return GestureDetector(
      onTap: () {
        mindfulActivityTap(i);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
              color:
                  (value == 0) ? Colors.black.withOpacity(.03) : Colors.black87,
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
              fontFamily: 'Milliard',
              fontSize: Gparam.textSmaller,
              fontWeight: FontWeight.w500,
              color: Colors.black.withOpacity(.8)),
        ),
      ),
    );
  }

  Widget fitnessGoalTile(
    String s,
    int value,
    int i,
  ) {
    return GestureDetector(
      onTap: () {
        handleFitnessGoalTap(i);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
              color:
                  (value == 0) ? Colors.black.withOpacity(.03) : Colors.black87,
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
              fontFamily: 'Milliard',
              fontSize: Gparam.textSmaller,
              fontWeight: FontWeight.w500,
              color: Colors.black.withOpacity(.8)),
        ),
      ),
    );
  }

  Widget mindfulGoalTile(String s, int value, int i) {
    return GestureDetector(
      onTap: () {
        handleMindfulGoalTap(i);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
              color:
                  (value == 0) ? Colors.black.withOpacity(.03) : Colors.black87,
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
              fontFamily: 'Milliard',
              fontSize: Gparam.textSmaller,
              fontWeight: FontWeight.w500,
              color: Colors.black.withOpacity(.8)),
        ),
      ),
    );
  }

  void handleFitnessActivityTap(int i) {
    bloc.add(UpdateHealthDailyActivity(i));
  }

  void handleMindfulGoalTap(int i) {
    bloc.add(UpdateMentalGoalActivity(i));
  }

  void handleFitnessGoalTap(int i) {
    bloc.add(UpdateHealthGoalActivity(i));
  }

  void mindfulActivityTap(int i) {
    bloc.add(UpdateMentalDailyActivity(i));
  }

  void handleFoodActivityTap(int i) {
    bloc.add(UpdateFoodPreference(i));
  }

  void handleSleepActivityTap(int i) {
    bloc.add(UpdateSleepActivity(i));
  }
}
