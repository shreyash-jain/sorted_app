part of 'track_log_bloc.dart';

abstract class PerformanceLogState extends Equatable {
  const PerformanceLogState();
}

class PerformanceLogInitial extends PerformanceLogState {
  @override
  List<Object> get props => [];
}

class PerformanceLogLoaded extends PerformanceLogState {
  final TrackModel track;
  final TrackUserSettings trackSettings;
  final TrackSummary trackSummary;
  final List<TrackPropertyModel> properties;
  final List<TrackPropertySettings> propertySettings;

  PerformanceLogLoaded(this.track, this.trackSettings, this.trackSummary,
      this.properties, this.propertySettings);

  @override
  List<Object> get props =>
      [track, trackSettings, trackSummary, properties, propertySettings];
}

class PerformanceLogError extends PerformanceLogState {
  final String message;

  PerformanceLogError(this.message);
  @override
  List<Object> get props => [message];
}
