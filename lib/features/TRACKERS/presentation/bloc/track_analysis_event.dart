part of 'track_analysis_bloc.dart';

abstract class TrackAnalysisEvent extends Equatable {
  const TrackAnalysisEvent();
}

class GetTrackData extends TrackAnalysisEvent {
  final TrackModel track;
  final TrackSummary summary;

  GetTrackData(this.track, this.summary);

  List<Object> get props => [track, summary];
}


