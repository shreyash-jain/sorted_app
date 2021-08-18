part of 'feed_bloc.dart';

abstract class FeedState extends Equatable {
  const FeedState();
}

class FeedInitial extends FeedState {
  @override
  List<Object> get props => [];
}

class FeedLoaded extends FeedState {
  final FeedPostEntity posts;

  FeedLoaded(this.posts);
  @override
  List<Object> get props => [posts];
}
