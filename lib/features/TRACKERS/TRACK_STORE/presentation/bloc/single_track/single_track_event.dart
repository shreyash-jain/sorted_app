part of 'single_track_bloc.dart';

abstract class SingleTrackEvent extends Equatable {
  const SingleTrackEvent();

  @override
  List<Object> get props => [];
}

class GetSingleTrackEvent extends SingleTrackEvent {
  final int track_id;
  GetSingleTrackEvent(@required this.track_id);
  @override
  List<Object> get props => [];
}
