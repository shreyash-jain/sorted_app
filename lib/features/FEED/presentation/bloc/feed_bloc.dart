import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'feed_event.dart';
part 'feed_state.dart';
class FeedBloc extends Bloc<FeedEvent, FeedState> {
  FeedBloc() : super(FeedInitial());
  @override
  Stream<FeedState> mapEventToState(
    FeedEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
