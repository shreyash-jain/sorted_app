part of 'workout_plan_bloc.dart';

abstract class WorkoutPlanState extends Equatable {
  const WorkoutPlanState();
}

class WorkoutPlanInitial extends WorkoutPlanState {
  @override
  List<Object> get props => [];
}

class WorkoutPlanListState extends WorkoutPlanState {
  final List<WorkoutPlanModel> workoutPlans;

  WorkoutPlanListState(this.workoutPlans);

  @override
  List<Object> get props => [workoutPlans];
}

class WorkoutPlanLoaded extends WorkoutPlanState {
  WorkoutPlanLoaded(
      {this.workoutEntity});
  final WorkoutPlanEntitiy workoutEntity;
  @override
  List<Object> get props =>
      [workoutEntity];
}

class WorkoutBoardLoaded extends WorkoutPlanState {
  WorkoutBoardLoaded(this.activityBoardInfo);
  final LinkedHashMap<int, List<ActivityItem>> activityBoardInfo;

  @override
  List<Object> get props => [activityBoardInfo];
}

class WorkoutPlanError extends WorkoutPlanState {
  WorkoutPlanError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}


class WorkoutPlanEmpty extends WorkoutPlanState {
  WorkoutPlanEmpty();
  

  @override
  List<Object> get props => [];
}
