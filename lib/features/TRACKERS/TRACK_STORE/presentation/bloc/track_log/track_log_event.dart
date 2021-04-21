part of 'track_log_bloc.dart';

abstract class TrackLogEvent extends Equatable {
  const TrackLogEvent();

  @override
  List<Object> get props => [];
}

class GetTrackLogEvent extends TrackLogEvent {}
