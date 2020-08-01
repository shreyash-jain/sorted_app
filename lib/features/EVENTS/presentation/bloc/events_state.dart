part of 'events_bloc.dart';
abstract class EventsState extends Equatable {
  const EventsState();
}
class EventsInitial extends EventsState {
  @override
  List<Object> get props => [];
}
