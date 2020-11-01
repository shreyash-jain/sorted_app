import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/core/global/widgets/message_display.dart';
import 'package:sorted/features/PLAN/presentation/bloc/plan_bloc/plan_bloc.dart';
import 'package:sorted/features/PLAN/presentation/pages/choice_goal_guide.dart';
import 'package:sorted/features/PLAN/presentation/pages/plan_loaded_page.dart';
import 'package:sorted/features/PLAN/presentation/pages/smart_goal_guide.dart';

class PlanHome extends StatefulWidget {
  const PlanHome({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PlanHomeState();
}

class PlanHomeState extends State<PlanHome> {
  PlanBloc bloc;
  @override
  void initState() {
    bloc = sl<PlanBloc>()..add(LoadPlanPage());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: new LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Center(child: buildBody(context));
      })),
    );
  }

  BlocProvider<PlanBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: Center(
        child: ListView(
          children: <Widget>[
            // Top half
            BlocBuilder<PlanBloc, PlanState>(
              builder: (context, state) {
                if (state is Error) {
                  return MessageDisplay(
                    message: 'Start searching!',
                  );
                } else if (state is PlanLoading) {
                  return Container(
                    width: 0,
                    height: 0,
                  );
                } else if (state is PlanLoaded) {
                  print("updated plan");
                  return PlanLoadedWidget();
                }
              },
            ),
            SizedBox(height: 20),
            FlatButton(
              child: Text('FlatButton'),
              onPressed: () {
                bloc.add(TestEvent());
              },
            ),

            // Bottom half
          ],
        ),
      ),
    );
  }
}
