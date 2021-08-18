import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_log.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_model.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_property_model.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_property_settings.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_summary.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_user_settings.dart';
import 'package:sorted/features/TRACKERS/COMMON/performance_track_data/track_property_data.dart';
import 'package:sorted/features/TRACKERS/PERMORMANCE/domain/repositories/performance_repository.dart';
part 'track_analysis_event.dart';
part 'track_analysis_state.dart';

class TrackAnalysisBloc extends Bloc<TrackAnalysisEvent, TrackAnalysisState> {
  final PerformanceRepository repository;
  TrackAnalysisBloc(this.repository) : super(TrackersInitial());
  @override
  Stream<TrackAnalysisState> mapEventToState(
    TrackAnalysisEvent event,
  ) async* {
    if (event is GetTrackData) {
      Failure failure;
      sl<FirebaseAnalytics>().logEvent(
          name: 'TrackAnalysisView',
          parameters: {"trackId": event.track.id.toString()});

      TrackModel track = event.track;
      TrackSummary summary = event.summary;
      TrackUserSettings trackSettings;
      List<List<TrackLog>> data;
      List<TrackPropertyModel> properties;
      List<TrackPropertySettings> propertySettings;

      properties = getAllProperties()
          .where((element) => (element.track_id == track.id))
          .toList();

      print(properties.length);

      if (summary.track_logs.length > 0) {
        var trackSettingsResult = await repository.getTrackSettings(track.id);
        trackSettingsResult.fold((l) => failure = l, (r) => trackSettings = r);

        if (failure == null) {
          List propertyResult = await Future.wait([
            for (int i = 0; i < properties.length; i++)
              getPropertySettings(properties[i].track_id, properties[i].id),
          ]);

          if (propertyResult.length > 0)
            propertySettings =
                propertyResult.map((e) => e as TrackPropertySettings).toList();
          // Getting log data only for the primary property

          var logResult = await repository.getPast3MonthTrackLogs(
              track.id, track.primary_property_id);

          logResult.fold((l) => failure = l, (r) => data = r);

          if (failure == null) {
            yield TrackDataLoaded(data, track, properties, summary,
                trackSettings, propertySettings);
          } else {
            yield TrackDataLoaded([[], [], []], track, properties, summary,
                trackSettings, propertySettings);
          }

          // yield (PerformanceLogLoaded(
          //     track, trackSettings, trackSummary, properties, propertySettings));
        } else
          yield TrackDataError(Failure.mapToString(failure));
      } else {
        yield TrackDataLoaded([[], [], []], track, properties, summary,
            trackSettings, propertySettings);
      }
    }
  }

  Future<TrackPropertySettings> getPropertySettings(
      int trackId, int propertyId) async {
    TrackPropertySettings thisProperty;
    var result = await repository.getPropertySettings(propertyId, trackId);
    result.fold((l) {
      thisProperty = getAllDefaultPropertySettings().singleWhere(
          (element) => (element.property_id == propertyId),
          orElse: () => TrackPropertySettings());
    }, (r) => thisProperty = r);
    if (thisProperty.property_id == 0)
      thisProperty = getAllDefaultPropertySettings().singleWhere(
          (element) => (element.property_id == propertyId),
          orElse: () => TrackPropertySettings());
    return thisProperty;
  }
}
