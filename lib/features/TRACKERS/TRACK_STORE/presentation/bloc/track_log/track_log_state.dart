part of 'track_log_bloc.dart';

abstract class TrackLogState extends Equatable {
  const TrackLogState();

  @override
  List<Object> get props => [];
}

class TrackLogInitial extends TrackLogState {}

class GetTrackLogLoadedState extends TrackLogState {
  final Map<String, double> events;
  final Map<String, Color> colors;

  GetTrackLogLoadedState({
    this.events,
    this.colors,
  });
}

class GetTrackLogLoadingState extends TrackLogState {}

class GetTrackLogFailedState extends TrackLogState {}
