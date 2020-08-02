import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'trackers_event.dart';
part 'trackers_state.dart';
class TrackersBloc extends Bloc<TrackersEvent, TrackersState> {
  TrackersBloc() : super(TrackersInitial());
  @override
  Stream<TrackersState> mapEventToState(
    TrackersEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
