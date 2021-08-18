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
  @override
  void initState() {
    super.initState();
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
                          Gtheme.stext("Diet Plan",
                              size: GFontSize.S, weight: GFontWeight.B2),
                        ],
                      ),
                    ),
                    ...state.planEntitiy.dayDiets
                        .asMap()
                        .entries
                        .map((e) => DayDietWidget(dayDiet: e.value))
                        .toList(),
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
