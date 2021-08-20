import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/global/animations/fade_animationTB.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/core/global/widgets/message_display.dart';
import 'package:sorted/features/PROFILE/presentation/bloc/profile_bloc.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/widgets/height_widget/height_card.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/widgets/weight_widget.dart/weight_card.dart';

class ProfileEditPage extends StatefulWidget implements AutoRouteWrapper {
  final ProfileBloc profileBloc;
  ProfileEditPage({Key key, this.profileBloc}) : super(key: key);
  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider.value(value: profileBloc, child: this);
  }

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  ProfileBloc bloc;
  int weight = 0, height = 0;

  @override
  void initState() {
    bloc = widget.profileBloc;

    if (bloc.state is ProfileLoaded) {
      weight = (bloc.state as ProfileLoaded).healthProfile.weight_kg.toInt();
      height = (bloc.state as ProfileLoaded).healthProfile.height_cm.toInt();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  if (bloc.state is ProfileLoaded) {
                    bloc.add(SaveDetails((bloc.state as ProfileLoaded).details,
                        (bloc.state as ProfileLoaded).healthProfile));
                    context.router.pop();
                  }
                },
                child: Text(
                  "Save",
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
                width: 20,
              )
            ],
          ),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoaded)
            return SafeArea(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(children: [
                    SizedBox(height: 20),
                    AnimatedOpacity(
                        duration: Duration(seconds: 1),
                        curve: Curves.easeOutQuint,
                        opacity: 1,
                        child: FadeAnimationTB(
                          .9,
                          SingleChildScrollView(
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
                                            borderRadius: new BorderRadius.all(
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
                                              color:
                                                  Colors.black.withOpacity(.8)),
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
                                              height: Gparam.heightPadding / 2,
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
                                                                      .w600,
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
                                                                      .w600,
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
                                              height: Gparam.heightPadding / 2,
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
                                                        fontFamily: 'Milliard',
                                                        fontSize:
                                                            Gparam.textSmaller,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black
                                                            .withOpacity(.8)),
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
                                                    fontSize:
                                                        Gparam.textExtraSmall,
                                                    fontWeight: FontWeight.w500,
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
                                                          state.healthProfile
                                                              .do_walk,
                                                          0),
                                                      fitnessActivityTile(
                                                          "Do Exercise",
                                                          state.healthProfile
                                                              .do_exercise,
                                                          1),
                                                      fitnessActivityTile(
                                                          "Do Yoga",
                                                          state.healthProfile
                                                              .do_yoga,
                                                          2),
                                                    ])),
                                            SizedBox(
                                              height: Gparam.heightPadding / 3,
                                            ),
                                            Container(
                                                height: 36,
                                                child: ListView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    children: [
                                                      fitnessActivityTile(
                                                          "Do Dance",
                                                          state.healthProfile
                                                              .do_dance,
                                                          3),
                                                      fitnessActivityTile(
                                                          "Play Sports",
                                                          state.healthProfile
                                                              .play_sports,
                                                          4),
                                                      fitnessActivityTile(
                                                          "Ride Cycle",
                                                          state.healthProfile
                                                              .ride_cycle,
                                                          5),
                                                    ])),
                                            SizedBox(
                                              height: Gparam.heightPadding / 3,
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(8),
                                              child: Row(
                                                children: [
                                                  Text("❤️"),
                                                  SizedBox(
                                                    width: 12,
                                                  ),
                                                  Text(
                                                    'Health Conditions',
                                                    style: TextStyle(
                                                        fontFamily: 'Milliard',
                                                        fontSize:
                                                            Gparam.textSmaller,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black
                                                            .withOpacity(.8)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: Gparam.heightPadding / 3,
                                            ),
                                            Container(
                                                height: 36,
                                                child: ListView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    children: [
                                                      healthConditionTile(
                                                          "Heart realted issues",
                                                          state.healthProfile
                                                              .has_high_bp,
                                                          0),
                                                      healthConditionTile(
                                                          "Diabetes",
                                                          state.healthProfile
                                                              .has_diabetes,
                                                          1),
                                                      healthConditionTile(
                                                          "Cholesterol",
                                                          state.healthProfile
                                                              .has_cholesterol,
                                                          2),
                                                      healthConditionTile(
                                                          "Hypertension",
                                                          state.healthProfile
                                                              .has_hypertension,
                                                          3),
                                                    ])),
                                            Divider(
                                              color: Colors.black26,
                                            ),
                                            Container(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(8),
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
                                                                      .w600,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      .8)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        Gparam.heightPadding /
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
                                                    height:
                                                        Gparam.heightPadding /
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
                                            borderRadius: new BorderRadius.all(
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
                                              color:
                                                  Colors.black.withOpacity(.8)),
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
                                              height: Gparam.heightPadding / 2,
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
                                                        fontFamily: 'Milliard',
                                                        fontSize:
                                                            Gparam.textSmaller,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black
                                                            .withOpacity(.8)),
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
                                                    fontSize:
                                                        Gparam.textExtraSmall,
                                                    fontWeight: FontWeight.w500,
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
                                                          state.healthProfile
                                                              .do_talk_ablout_feelings,
                                                          0),
                                                      mindfulActivityTile(
                                                          "Enjoy my work",
                                                          state.healthProfile
                                                              .do_enjoy_work,
                                                          1),
                                                    ])),
                                            SizedBox(
                                              height: Gparam.heightPadding / 3,
                                            ),
                                            Container(
                                                height: 36,
                                                child: ListView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    children: [
                                                      mindfulActivityTile(
                                                          "Do meditate",
                                                          state.healthProfile
                                                              .do_meditation,
                                                          2),
                                                      mindfulActivityTile(
                                                          "Love my self",
                                                          state.healthProfile
                                                              .do_love_self,
                                                          3),
                                                      mindfulActivityTile(
                                                          "Think positive",
                                                          state.healthProfile
                                                              .do_stay_positive,
                                                          4),
                                                    ])),
                                            SizedBox(
                                              height: Gparam.heightPadding / 3,
                                            ),
                                            Divider(
                                              color: Colors.black26,
                                            ),
                                            Container(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(8),
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
                                                                      .w600,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      .8)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        Gparam.heightPadding /
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
                                                    height:
                                                        Gparam.heightPadding /
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
                                            borderRadius: new BorderRadius.all(
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
                                              color:
                                                  Colors.black.withOpacity(.8)),
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
                                              height: Gparam.heightPadding / 2,
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
                                                        fontFamily: 'Milliard',
                                                        fontSize:
                                                            Gparam.textSmaller,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black
                                                            .withOpacity(.8)),
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
                                              height: Gparam.heightPadding / 3,
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
                                                        fontFamily: 'Milliard',
                                                        fontSize:
                                                            Gparam.textSmaller,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black
                                                            .withOpacity(.8)),
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
                                              height: Gparam.heightPadding / 2,
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
                          ),
                        )),
                  ]),
                ),
              ),
            );
          else if (state is ProfileError)
            return MessageDisplay(message: state.message);
          else if (state is ProfileInitial)
            return LoadingWidget();
          else
            return Container(
              height: 0,
            );
        },
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
                  (value == 0) ? Colors.black.withOpacity(.03) : Colors.black45,
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

  Widget healthConditionTile(String s, int value, int i) {
    return GestureDetector(
      onTap: () {
        handleHealthConditionTap(i);
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

  void handleHealthConditionTap(int i) {
    bloc.add(UpdateHealthCondition(i));
  }
}
