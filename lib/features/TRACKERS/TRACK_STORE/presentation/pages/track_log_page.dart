import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heat_map_calendar/heat_map_calendar.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/presentation/bloc/track_log/track_log_bloc.dart';

class TrackLogPage extends StatefulWidget {
  @override
  _TrackLogPageState createState() => _TrackLogPageState();
}

class _TrackLogPageState extends State<TrackLogPage> {
  TrackLogBloc bloc;
  @override
  void initState() {
    print("FROM INIT");
    bloc = sl<TrackLogBloc>();
    bloc.add(GetTrackLogEvent());
    super.initState();
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TrackLogBloc>(
      create: (context) => bloc,
      child: SafeArea(
        child: Scaffold(
          body: BlocBuilder<TrackLogBloc, TrackLogState>(
            builder: (context, state) {
              print("Current state = " + state.toString());
              if (state is GetTrackLogLoadingState) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is GetTrackLogLoadedState) {
                return HeatMapCalendar(
                  dateFrom: DateTime.now().subtract(Duration(days: 60)),
                  dateTo: DateTime.now().add(Duration(days: 60)),
                  spaceBetweenMonths: 0,
                  alwaysIncludeTheFirstDayOfTheMonth: true,
                  textStyle: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).primaryColor,
                  ),
                  events: state.events,
                  colors: state.colors,
                );
              }
              return Container(child: Text("other state"));
            },
          ),
        ),
      ),
    );
  }
}
