part of 'feed_bloc.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();
}

class GetUserFeed extends FeedEvent {
  @override
  List<Object> get props => [];
}
