import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/features/CONNECT/presentation/consultation/widgets/day_diet_tile.dart';
import 'package:sorted/features/CONNECT/presentation/diet_plan_bloc/diet_plan_bloc.dart';

class DietPlanView extends StatefulWidget {
  DietPlanView({Key key}) : super(key: key);

  @override
  _DietPlanViewState createState() => _DietPlanViewState();
}

class _DietPlanViewState extends State<DietPlanView> {
  DietPlanBloc recipePlanBloc;
  int selectedDay = 0;
  @override
  void initState() {
    super.initState();
    selectedDay = DateTime.now().weekday - 1;
    recipePlanBloc = DietPlanBloc(sl(), sl(), sl())
      ..add(GetRecommendedDietPlan());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocProvider(
            create: (context) => recipePlanBloc,
            child: BlocBuilder<DietPlanBloc, DietPlanState>(
              builder: (context, state) {
                if (state is DietPlanLoaded)
                  return Column(children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Gparam.widthPadding, vertical: 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Gtheme.stext("My Diet Plan",
                              size: GFontSize.S, weight: GFontWeight.B2),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 30,
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: [
                          SizedBox(
                            width: Gparam.widthPadding,
                          ),
                          ...state.planEntitiy.dayDiets
                              .asMap()
                              .entries
                              .map((e) => InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedDay = e.key;
                                      });
                                    },
                                    child: Container(
                                        margin: EdgeInsets.only(right: 16),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                                width: 3.0,
                                                color: (selectedDay == e.key)
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                    : Colors.grey.shade300),
                                          ),
                                          color: Colors.white,
                                        ),
                                        child: Gtheme.stext(e.value.dayName,
                                            size: GFontSize.M,
                                            weight: GFontWeight.B2)),
                                  ))
                              .toList(),
                        ],
                      ),
                    ),
                    if (state.planEntitiy.dayDiets[selectedDay] != null)
                      DayDietWidget(
                          dayDiet: state.planEntitiy.dayDiets[selectedDay]),
                  ]);
                else if (state is DietPlanInitial)
                  return Center(child: LoadingWidget());
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
}
