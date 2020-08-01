import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'events_event.dart';
part 'events_state.dart';
class EventsBloc extends Bloc<EventsEvent, EventsState> {
  EventsBloc() : super(EventsInitial());
  @override
  Stream<EventsState> mapEventToState(
    EventsEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
