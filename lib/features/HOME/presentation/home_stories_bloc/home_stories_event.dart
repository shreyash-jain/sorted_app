part of 'home_stories_bloc.dart';

abstract class HomeStoriesEvent extends Equatable {
  const HomeStoriesEvent();
  @override
  List<Object> get props => [];
}

class LoadTrackStories extends HomeStoriesEvent {}

class StartLoading extends HomeStoriesEvent {
  final TrackModel trackModel;

  StartLoading(this.trackModel);
  @override
  List<Object> get props => [trackModel];
}

class EndLoading extends HomeStoriesEvent {
  final TrackModel trackModel;

  EndLoading(this.trackModel);
  @override
  List<Object> get props => [trackModel];
}

class UpdateTrackSummary extends HomeStoriesEvent {
  final TrackSummary summary;

  UpdateTrackSummary(this.summary);
  @override
  List<Object> get props => [summary];
}
