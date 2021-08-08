import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/entities/sub_profiles/fitness_goals.dart';
import 'package:sorted/core/global/entities/sub_profiles/food_preferences.dart';
import 'package:sorted/core/global/entities/sub_profiles/health_condition.dart';
import 'package:sorted/core/global/entities/sub_profiles/mindful_goals.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/core/global/widgets/message_display.dart';
import 'package:sorted/features/CONNECT/data/datasources/diet_preferences_db.dart';
import 'package:sorted/features/CONNECT/data/datasources/fitness_goals_db.dart';
import 'package:sorted/features/CONNECT/data/datasources/health_conditions_db.dart';
import 'package:sorted/features/CONNECT/data/models/expert/expert_calendar.dart';
import 'package:sorted/features/CONNECT/presentation/user_form_bloc/user_form_bloc.dart';
import 'package:auto_route/auto_route.dart';

class ClientRequestForm extends StatefulWidget {
  final ExpertCalendarModel calendarModel;
  final int packageType;

  final Function(
      List<int> fitnessGoals,
      List<int> dietPreferences,
      List<int> healthConditions,
      DateTime startDate,
      String details,
      int preferedSlot) onPressEnroll;

  ClientRequestForm(
      {Key key, this.calendarModel, this.packageType, this.onPressEnroll})
      : super(key: key);

  @override
  _ClientRequestFormState createState() => _ClientRequestFormState();
}

class _ClientRequestFormState extends State<ClientRequestForm> {
  UserRequestFormBloc healthProfileBloc;
  List<int> fitnessGoals = [];
  List<int> dietPreferences = [];
  List<int> healthConditions = [];
  int selectedDayPeriod = 0;
  List<int> morningSlots = [4, 5, 6, 7, 8, 9, 10, 11];
  List<String> morningSlotsStrings = [
    "4 am",
    "5 am",
    "6 am",
    "7 am",
    "8 am",
    "9 am",
    "10 am",
    "11 am"
  ];
  List<int> afternoonSlots = [12, 13, 14, 15, 16, 17];
  List<String> afternoonSlotsStrings = [
    "12 pm",
    "1 pm",
    "2 pm",
    "3 pm",
    "4 pm",
    "5 pm"
  ];
  String details = "";
  List<int> eveningSlots = [18, 19, 20, 21, 22];
  List<String> eveningSlotsStrings = ["6 pm", "7 pm", "8 pm", "9 pm", "10 pm"];
  int selectedSlot = 7;

  TextEditingController addDetailsController = TextEditingController();

  FocusNode addDetailsNode = FocusNode();

  @override
  void initState() {
    healthProfileBloc = UserRequestFormBloc(repository: sl());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) => healthProfileBloc
            ..add(LoadProfile(widget.packageType, widget.calendarModel)),
          child: BlocListener<UserRequestFormBloc, UserRequestFormProfileState>(
            listener: (context, state) {
              if (state is LoadedFormState) {
                if (state.fitnessGoals != null) {
                  fitnessGoals = [
                    ...fitnessGoals,
                    ...listFromFitnessGoals(state.fitnessGoals)
                  ].toSet().toList();
                }
                if (state.mindfulGoals != null) {
                  fitnessGoals = [
                    ...fitnessGoals,
                    ...listFromMindfulGoals(state.mindfulGoals)
                  ].toSet().toList();
                }
                if (state.foodPreferences != null) {
                  dietPreferences = [
                    ...dietPreferences,
                    ...listFromFoodPreference(state.foodPreferences)
                  ].toSet().toList();
                }
                if (state.healthConditions != null) {
                  healthConditions = [
                    ...healthConditions,
                    ...listFromHealthConditions(state.healthConditions)
                  ].toSet().toList();
                }
              }
            },
            child:
                BlocBuilder<UserRequestFormBloc, UserRequestFormProfileState>(
              builder: (context, state) {
                if (state is LoadedFormState)
                  return Container(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: Gparam.heightPadding,
                          ),
                          SizedBox(
                            height: Gparam.heightPadding,
                          ),
                          if (state.fitnessGoals != null)
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Gparam.widthPadding),
                              child: Row(
                                children: [
                                  Text("🎯"),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                    'My Fitness Goal',
                                    style: TextStyle(
                                        fontFamily: 'Milliard',
                                        fontSize: Gparam.textSmaller,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black.withOpacity(.8)),
                                  ),
                                ],
                              ),
                            ),
                          if (state.fitnessGoals != null)
                            SizedBox(
                              height: 16,
                            ),
                          if (state.fitnessGoals != null)
                            Container(
                                height: 36,
                                child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      SizedBox(
                                        width: Gparam.widthPadding,
                                      ),
                                      buttonTile(
                                          "Stay Fit",
                                          state.fitnessGoals.goal_stay_fit,
                                          0,
                                          0),
                                      buttonTile(
                                          "Gain Muscle",
                                          state.fitnessGoals.goal_gain_muscle,
                                          1,
                                          0),
                                      buttonTile(
                                          "Lose Weight",
                                          state.fitnessGoals.goal_loose_weight,
                                          2,
                                          0),
                                      buttonTile(
                                          "Be more Active",
                                          state.fitnessGoals
                                              .goal_get_more_active,
                                          3,
                                          0),
                                    ])),
                          SizedBox(
                            height: 16,
                          ),
                          Divider(
                            color: Colors.grey,
                          ),
                          if (state.mindfulGoals != null)
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Gparam.widthPadding),
                              child: Row(
                                children: [
                                  Text("🎯"),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                    'My Mindful Goal',
                                    style: TextStyle(
                                        fontFamily: 'Milliard',
                                        fontSize: Gparam.textSmaller,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black.withOpacity(.8)),
                                  ),
                                ],
                              ),
                            ),
                          if (state.mindfulGoals != null)
                            SizedBox(
                              height: 16,
                            ),
                          if (state.mindfulGoals != null)
                            Container(
                                height: 36,
                                child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      SizedBox(
                                        width: Gparam.widthPadding,
                                      ),
                                      buttonTile(
                                          "Control Anger",
                                          state.mindfulGoals.goal_control_anger,
                                          4,
                                          1),
                                      buttonTile(
                                          "Reduce Sleep",
                                          state.mindfulGoals.goal_reduce_stress,
                                          5,
                                          1),
                                      buttonTile(
                                          "Sleep More",
                                          state.mindfulGoals.goal_sleep_more,
                                          6,
                                          1),
                                      buttonTile(
                                          "Control Thoughts",
                                          state.mindfulGoals
                                              .goal_control_thoughts,
                                          7,
                                          1),
                                      buttonTile(
                                          "Live in present",
                                          state.mindfulGoals
                                              .goal_live_in_present,
                                          8,
                                          1),
                                      buttonTile(
                                          "Improve Will Power",
                                          state.mindfulGoals
                                              .goal_improve_will_power,
                                          9,
                                          1),
                                      buttonTile(
                                          "Overcome Addiction",
                                          state.mindfulGoals
                                              .goal_overcome_addiction,
                                          10,
                                          1),
                                    ])),
                          SizedBox(
                            height: 16,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: Gparam.widthPadding),
                            child: Row(
                              children: [
                                Text("🥗"),
                                SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  'My Diet Preference',
                                  style: TextStyle(
                                      fontFamily: 'Milliard',
                                      fontSize: Gparam.textSmaller,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black.withOpacity(.8)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          if (state.foodPreferences != null)
                            Container(
                                height: 36,
                                child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      SizedBox(
                                        width: Gparam.widthPadding,
                                      ),
                                      buttonTile("Vegan",
                                          state.foodPreferences.is_vegan, 0, 2),
                                      buttonTile(
                                          "Vegetarian",
                                          state.foodPreferences.is_vegetarian,
                                          1,
                                          2),
                                      buttonTile("Keto",
                                          state.foodPreferences.is_keto, 2, 2),
                                      buttonTile(
                                          "Sattvik",
                                          state.foodPreferences.is_sattvik,
                                          3,
                                          2),
                                    ])),
                          SizedBox(
                            height: 16,
                          ),
                          Divider(
                            color: Colors.grey,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: Gparam.widthPadding),
                            child: Row(
                              children: [
                                Text("❤️"),
                                SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  'Health Condition',
                                  style: TextStyle(
                                      fontFamily: 'Milliard',
                                      fontSize: Gparam.textSmaller,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black.withOpacity(.8)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          if (state.healthConditions != null)
                            Container(
                                height: 36,
                                child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      SizedBox(
                                        width: Gparam.widthPadding,
                                      ),
                                      buttonTile(
                                          "High BP",
                                          state.healthConditions.has_high_bp,
                                          0,
                                          3),
                                      buttonTile(
                                          "Diabetes",
                                          state.healthConditions.has_diabetes,
                                          1,
                                          3),
                                      buttonTile(
                                          "Cholesterol",
                                          state
                                              .healthConditions.has_cholesterol,
                                          2,
                                          3),
                                      buttonTile(
                                          "Thyroid",
                                          state.healthConditions.has_thyroid,
                                          3,
                                          3),
                                    ])),
                          SizedBox(
                            height: 16,
                          ),
                          Divider(
                            color: Colors.grey,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: Gparam.widthPadding),
                            child: Row(
                              children: [
                                Text(
                                  'Select Time Slot',
                                  style: TextStyle(
                                      fontFamily: 'Milliard',
                                      fontSize: Gparam.textSmaller,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black.withOpacity(.8)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Container(
                              height: 36,
                              child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    SizedBox(
                                      width: Gparam.widthPadding,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedDayPeriod = 0;
                                        });
                                      },
                                      child: dayPeriodTile(
                                          "Morning", (selectedDayPeriod == 0)),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedDayPeriod = 1;
                                        });
                                      },
                                      child: dayPeriodTile("Afternoon",
                                          (selectedDayPeriod == 1)),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedDayPeriod = 2;
                                        });
                                      },
                                      child: dayPeriodTile(
                                          "Evening", (selectedDayPeriod == 2)),
                                    ),
                                  ])),
                          SizedBox(
                            height: 16,
                          ),
                          Container(
                              height: 36,
                              child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    SizedBox(
                                      width: Gparam.widthPadding,
                                    ),
                                    if (selectedDayPeriod == 0)
                                      ...morningSlots
                                          .asMap()
                                          .entries
                                          .map((e) => GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    selectedSlot = 4 + e.key;
                                                  });
                                                },
                                                child: dayPeriodTile(
                                                    morningSlotsStrings[e.key],
                                                    (selectedSlot ==
                                                        4 + e.key)),
                                              )),
                                    if (selectedDayPeriod == 1)
                                      ...afternoonSlots
                                          .asMap()
                                          .entries
                                          .map((e) => GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    selectedSlot = 12 + e.key;
                                                  });
                                                },
                                                child: dayPeriodTile(
                                                    afternoonSlotsStrings[
                                                        e.key],
                                                    (selectedSlot ==
                                                        12 + e.key)),
                                              )),
                                    if (selectedDayPeriod == 2)
                                      ...eveningSlots
                                          .asMap()
                                          .entries
                                          .map((e) => GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    selectedSlot = 18 + e.key;
                                                  });
                                                },
                                                child: dayPeriodTile(
                                                    eveningSlotsStrings[e.key],
                                                    (selectedSlot ==
                                                        18 + e.key)),
                                              )),
                                  ])),
                          SizedBox(
                            height: 16,
                          ),
                          Padding(
                            padding: EdgeInsets.all(
                              Gparam.widthPadding,
                            ),
                            child: TextField(
                              cursorColor: Colors.black45,
                              maxLength: 500,
                              maxLines: 2,
                              controller: addDetailsController,
                              focusNode: addDetailsNode,
                              onChanged: (text) {
                                details = text;
                              },
                              decoration: InputDecoration(
                                labelText: "Add Message for your expert",
                                labelStyle: Gtheme.blackShadowBold28,
                                enabledBorder: OutlineInputBorder(
                                  // width: 0.0 produces a thin "hairline" border
                                  borderSide: BorderSide(
                                      color: Colors.grey.shade100, width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                      color: Colors.black, width: 2.0),
                                ),
                                border: const OutlineInputBorder(),
                              ),
                              cursorWidth: 2.0,
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MaterialButton(
                                height: 50,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                onPressed: () {
                                  print("something");
                                  if (widget.onPressEnroll != null) {
                                    widget.onPressEnroll(
                                        fitnessGoals,
                                        dietPreferences,
                                        healthConditions,
                                        state.startDate,
                                        details,
                                        selectedSlot);
                                    context.router.pop();
                                  }
                                },
                                color: Colors.grey.shade400,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.live_tv,
                                      size: 25,
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Gtheme.stext("Enroll",
                                        weight: GFontWeight.B1),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                else if (state is InitialFormState)
                  return LoadingWidget();
                else if (state is FormErrorState)
                  return MessageDisplay(message: state.message);
                else
                  return Container(
                    height: 0,
                  );
              },
            ),
          ),
        ),
      ),
    );
  }

  Container dayPeriodTile(String text, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
            color:
                (!isSelected) ? Colors.black.withOpacity(.03) : Colors.black87,
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
        text,
        style: TextStyle(
            fontFamily: 'Milliard',
            fontSize: Gparam.textSmaller,
            fontWeight: FontWeight.w500,
            color: Colors.black.withOpacity(.8)),
      ),
    );
  }

  Widget buttonTile(String s, int value, int i, int tagType) {
    return GestureDetector(
      onTap: () {
        switch (tagType) {
          case 0:
            handleFitnessGoalTap(i);

            break;
          case 1:
            handleMindfulGoalTap(i);

            break;
          case 2:
            handleFoodPreferenceTap(i);

            break;
          case 3:
            handleHealthConditionTap(i);

            break;
          default:
        }
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

  void handleFitnessGoalTap(int i) {
    setState(() {
      if (fitnessGoals.contains(i))
        fitnessGoals.remove(i);
      else
        fitnessGoals.add(i);
    });

    FitnessGoals goals = fitnessGoalsFromTags(fitnessGoals);

    healthProfileBloc.add(UpdateFitnessGoals(goals));
  }

  void handleMindfulGoalTap(int i) {
    setState(() {
      if (fitnessGoals.contains(i))
        fitnessGoals.remove(i);
      else
        fitnessGoals.add(i);
    });

    MindfulGoals mindulGoals = mindfulGoalsFromTags(fitnessGoals);

    healthProfileBloc.add(UpdateMindfulGoals(mindulGoals));
  }

  void handleFoodPreferenceTap(int i) {
    setState(() {
      if (dietPreferences.contains(i))
        dietPreferences.remove(i);
      else
        dietPreferences.add(i);
    });

    UserFoodPreferences preferences = foodPreferencesFromTags(dietPreferences);

    healthProfileBloc.add(UpdateFoodPreference(preferences));
  }

  void handleHealthConditionTap(int i) {
    setState(() {
      if (healthConditions.contains(i))
        healthConditions.remove(i);
      else
        healthConditions.add(i);
    });

    HealthConditions condition = healthConditionsFromTags(healthConditions);

    healthProfileBloc.add(UpdateHealthCondition(condition));
  }
}
