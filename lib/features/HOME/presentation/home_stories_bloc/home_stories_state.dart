part of 'home_stories_bloc.dart';

abstract class HomeStoriesState extends Equatable {
  const HomeStoriesState();
}

class HomeStoriesInitial extends HomeStoriesState {
  @override
  List<Object> get props => [];
}

class HomeStoriesLoaded extends HomeStoriesState {
  final List<TrackModel> subsTracks;
  final List<TrackSummary> trackSummaries;
  final List<bool> isLoading;

  HomeStoriesLoaded(this.subsTracks, this.trackSummaries, this.isLoading);

  @override
  List<Object> get props => [subsTracks, trackSummaries, isLoading];

  HomeStoriesLoaded copyWith({
    List<TrackModel> subsTracks,
    List<TrackSummary> trackSummaries,
    List<bool> isLoading,
  }) {
    return HomeStoriesLoaded(
      subsTracks ?? this.subsTracks,
      trackSummaries ?? this.trackSummaries,
      isLoading ?? this.isLoading,
    );
  }
}

class HomeStoriesError extends HomeStoriesState {
  final String message;

  HomeStoriesError(this.message);
  @override
  List<Object> get props => [message];
}
