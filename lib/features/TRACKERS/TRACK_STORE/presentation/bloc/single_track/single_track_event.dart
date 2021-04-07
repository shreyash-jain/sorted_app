part of 'single_track_bloc.dart';

abstract class SingleTrackEvent extends Equatable {
  const SingleTrackEvent();

  @override
  List<Object> get props => [];
}

class GetSingleTrackEvent extends SingleTrackEvent {
  final int track_id;
  GetSingleTrackEvent(this.track_id);
  @override
  List<Object> get props => [track_id];
}

class SubscribeToTrackEvent extends SingleTrackEvent {
  final Track track;
  final List<TrackProperty> trackProps;
  SubscribeToTrackEvent({
    @required this.track,
    @required this.trackProps,
  });
  @override
  List<Object> get props => [track, trackProps];
}

class UnsubscribeFromTrackEvent extends SingleTrackEvent {
  final int track_id;
  UnsubscribeFromTrackEvent({
    @required this.track_id,
  });
  @override
  List<Object> get props => [track_id];
}

class PauseTrackEvent extends SingleTrackEvent {
  final Track track;

  PauseTrackEvent({
    @required this.track,
  });
  @override
  List<Object> get props => [track];
}

class ResumeTrackEvent extends SingleTrackEvent {
  final int track_id;

  ResumeTrackEvent({
    @required this.track_id,
  });
  @override
  List<Object> get props => [track_id];
}
