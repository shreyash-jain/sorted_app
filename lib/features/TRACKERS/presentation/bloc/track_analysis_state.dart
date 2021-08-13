part of 'track_analysis_bloc.dart';

abstract class TrackAnalysisState extends Equatable {
  const TrackAnalysisState();
}

class TrackersInitial extends TrackAnalysisState {
  @override
  List<Object> get props => [];
}

class TrackDataLoaded extends TrackAnalysisState {
  final List<List<TrackLog>> data;
  final TrackModel track;
  final List<TrackPropertyModel> properties;
  final TrackSummary summary;
  final TrackUserSettings trackSettings;
  final List<TrackPropertySettings> propertiesSettings;

  TrackDataLoaded(this.data, this.track, this.properties, this.summary,
      this.trackSettings, this.propertiesSettings);
  @override
  List<Object> get props =>
      [data, track, properties, summary, trackSettings, propertiesSettings];
}

class TrackDataError extends TrackAnalysisState {
  final String message;

  TrackDataError(this.message);
  List<Object> get props => [message];
}

class NoDataState extends TrackAnalysisState {
  final TrackModel track;
  final List<TrackPropertyModel> properties;
  final TrackSummary summary;

  NoDataState(this.track, this.properties, this.summary);
  List<Object> get props => [track, properties, summary];
  
}
