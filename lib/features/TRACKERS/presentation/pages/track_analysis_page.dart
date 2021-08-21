import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_model.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_summary.dart';
import 'package:sorted/features/TRACKERS/presentation/bloc/track_analysis_bloc.dart';
import 'package:sorted/features/TRACKERS/presentation/widgets/analysis_header.dart';
import 'package:sorted/features/TRACKERS/presentation/widgets/analysis_heat_map.dart';
import 'package:sorted/features/TRACKERS/presentation/widgets/analysis_prev_logs.dart';
import 'package:sorted/features/TRACKERS/presentation/widgets/property_set_goal.dart';

class PerformanceAnalysisPage extends StatefulWidget {
  final TrackSummary summary;
  final TrackModel track;
  PerformanceAnalysisPage({Key key, this.summary, this.track})
      : super(key: key);

  @override
  _PerformanceAnalysisPageState createState() =>
      _PerformanceAnalysisPageState();
}

class _PerformanceAnalysisPageState extends State<PerformanceAnalysisPage> {
  TrackAnalysisBloc trackAnalysisBloc;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    trackAnalysisBloc = TrackAnalysisBloc(sl())
      ..add(GetTrackData(widget.track, widget.summary));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          controller: scrollController,
          child: BlocProvider(
            create: (context) => trackAnalysisBloc,
            child: BlocConsumer<TrackAnalysisBloc, TrackAnalysisState>(
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                if (state is TrackDataLoaded)
                  return Column(
                    children: [
                      TrackAnalysisHeader(
                        track: state.track,
                        summary: state.summary,
                        property: state.properties[0],
                      ),
                      TrackAnalysisPrevLogs(
                        summary: state.summary,
                        property: state.properties[0],
                      ),
                      if (state.properties[0].has_goal != 0 &&
                          state.propertiesSettings != null)
                        PropertySetGoal(
                          track: state.track,
                          property: state.properties[0],
                          propertySettings: state.propertiesSettings[0],
                        ),
                      if (state.properties[0].property_type != 1)
                        ListAnalysis(
                          controller: scrollController,
                          settings: state.propertiesSettings[0],
                          track: state.track,
                          property: state.properties[0],
                          logs: state.data,
                        ),
                      SizedBox(
                        height: 100,
                      )
                    ],
                  );
                else if (state is TrackersInitial) {
                  return Center(child: LoadingWidget());
                } else
                  return Container(height: 0);
              },
            ),
          ),
        ),
      ),
    );
  }
}
