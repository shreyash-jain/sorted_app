import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/features/FEED/data/models/feed_model.dart';
import 'package:sorted/features/FEED/domain/entities/feed_post_entity.dart';
import 'package:sorted/features/HOME/domain/repositories/home_repository.dart';
part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final HomeRepository repository;
  FeedBloc(this.repository) : super(FeedInitial());
  @override
  Stream<FeedState> mapEventToState(
    FeedEvent event,
  ) async* {
    if (event is GetUserFeed) {
      Failure failure;
      FeedPostEntity feed;

      var feedResult = await repository.getFeed(20, null);

      feedResult.fold((l) => failure = l, (r) => feed = r);
      if (failure == null) {
        yield FeedLoaded(feed);
      }
    }
  }
}
