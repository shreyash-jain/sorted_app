part of 'single_track_bloc.dart';

abstract class SingleTrackState extends Equatable {
  const SingleTrackState();

  @override
  List<Object> get props => [];
}

class SingleTrackInitial extends SingleTrackState {}

class GetSingleTrackLoadingState extends SingleTrackState {}

class GetSingleTrackLoadedState extends SingleTrackState {
  List<String> colossals;
  List<TrackComment> trackComments;
  List<TrackProperty> trackProperties;
  List<TrackGoal> trackGoals;
  GetSingleTrackLoadedState({
    @required this.colossals,
    @required this.trackComments,
    @required this.trackProperties,
    @required this.trackGoals,
  });
}

class GetSingleTrackFailedState extends SingleTrackState {}
