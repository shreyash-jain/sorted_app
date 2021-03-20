part of 'track_comments_bloc.dart';

abstract class TrackCommentsState extends Equatable {
  const TrackCommentsState();

  @override
  List<Object> get props => [];
}

class TrackCommentsInitial extends TrackCommentsState {}

class GetTrackCommentsLoadingState extends TrackCommentsState {}

class GetTrackCommentsLoadingPaginationState extends TrackCommentsState {}

class GetTrackCommentsLoadedState extends TrackCommentsState {
  final List<TrackComment> comments;
  const GetTrackCommentsLoadedState({this.comments});
  @override
  List<Object> get props => [comments];
}

class GetTrackCommentsFailedState extends TrackCommentsState {}
