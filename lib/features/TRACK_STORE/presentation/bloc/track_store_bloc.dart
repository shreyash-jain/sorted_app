import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'track_store_event.dart';
part 'track_store_state.dart';
class TrackStoreBloc extends Bloc<TrackStoreEvent, TrackStoreState> {
  TrackStoreBloc() : super(TrackStoreInitial());
  @override
  Stream<TrackStoreState> mapEventToState(
    TrackStoreEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
