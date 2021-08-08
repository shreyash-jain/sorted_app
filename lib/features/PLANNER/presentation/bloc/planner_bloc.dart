import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'planner_event.dart';
part 'planner_state.dart';
class PlannerBloc extends Bloc<PlannerEvent, PlannerState> {
  PlannerBloc() : super(PlannerInitial());
  @override
  Stream<PlannerState> mapEventToState(
    PlannerEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
