import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'timelines_event.dart';
part 'timelines_state.dart';
class TimelinesBloc extends Bloc<TimelinesEvent, TimelinesState> {
  TimelinesBloc() : super(TimelinesInitial());
  @override
  Stream<TimelinesState> mapEventToState(
    TimelinesEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
