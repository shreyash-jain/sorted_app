part of 'feed_bloc.dart';
abstract class FeedState extends Equatable {
  const FeedState();
}
class FeedInitial extends FeedState {
  @override
  List<Object> get props => [];
}
