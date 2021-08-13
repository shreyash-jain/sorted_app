part of 'track_log_bloc.dart';

abstract class PerformanceEvent extends Equatable {
  const PerformanceEvent();
  @override
  List<Object> get props => [];
}

class LoadFromStory extends PerformanceEvent {
  final TrackSummary trackSummary;
  final TrackModel track;
  final BuildContext context;

  LoadFromStory(this.trackSummary, this.track, this.context);
  @override
  List<Object> get props => [trackSummary, track, context];
}



