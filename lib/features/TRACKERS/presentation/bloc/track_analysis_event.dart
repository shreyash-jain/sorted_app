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


class UpdateTrackPropertySettings extends TrackAnalysisEvent {
  final TrackPropertySettings settings;
 

  UpdateTrackPropertySettings(this.settings);

  List<Object> get props => [settings];
}


class UpdateTrackSettings extends TrackAnalysisEvent {
  final TrackUserSettings settings;

  UpdateTrackSettings(this.settings);

  List<Object> get props => [settings];
}


