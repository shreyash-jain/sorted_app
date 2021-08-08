part of 'workout_plan_bloc.dart';

abstract class WorkoutPlanEvent extends Equatable {
  const WorkoutPlanEvent();
}

class LoadWorkoutList extends WorkoutPlanEvent {
  final int type;
  final ClassModel classroom;
  final ClientConsultationModel client;

  LoadWorkoutList(this.type, {this.classroom, this.client});

  @override
  List<Object> get props => [client, type, classroom];
}

class LoadWorkoutPlan extends WorkoutPlanEvent {
  final WorkoutPlanModel plan;

  LoadWorkoutPlan(this.plan);
  @override
  List<Object> get props => [plan];
}

class LoadWorkoutEntity extends WorkoutPlanEvent {
  final WorkoutPlanEntitiy plan;

  LoadWorkoutEntity(this.plan);
  @override
  List<Object> get props => [plan];
}
class LoadCurrentWorkoutPlan extends WorkoutPlanEvent {
  final int type;
  final ClassModel classroom;
  final ClientConsultationModel client;

  LoadCurrentWorkoutPlan(this.type, {this.classroom, this.client});
  @override
  List<Object> get props => [type, classroom, client];
}

class LoadWorkoutBoard extends WorkoutPlanEvent {
  final WorkoutPlanEntitiy workoutPlan;
  final ClassModel classroom;

  LoadWorkoutBoard(this.workoutPlan, this.classroom);
  @override
  List<Object> get props => [workoutPlan];
}

class SaveClassWorkoutPlan extends WorkoutPlanEvent {
  final LinkedHashMap<int, List<ActivityItem>> activityBoardInfo;
  final String boardname;
  final WorkoutPlanEntitiy workoutPlan;
  final ClassModel classroom;
  final Function(WorkoutPlanModel) onSaveActivity;

  SaveClassWorkoutPlan(this.activityBoardInfo, this.boardname, this.workoutPlan,
      this.classroom, this.onSaveActivity);

  @override
  List<Object> get props =>
      [activityBoardInfo, boardname, workoutPlan, onSaveActivity, classroom];
}

class AddActivityAtDay extends WorkoutPlanEvent {
  final LinkedHashMap<int, List<ActivityItem>> activityBoardInfo;
  final int day;
  final WorkoutModel workout;

  AddActivityAtDay(this.activityBoardInfo, this.workout, this.day);

  @override
  List<Object> get props => [activityBoardInfo, workout, day];
}
