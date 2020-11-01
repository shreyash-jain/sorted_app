part of 'plan_bloc.dart';

abstract class PlanState extends Equatable {
  const PlanState();
}

class PlanLoading extends PlanState {
  @override
  List<Object> get props => [];
}

class PlanLoaded extends PlanState {
  final List<GoalModel> goals;
  final List<TaskModel> upComingTasks;
  final List<TagModel> tags;
  final List<PlanTabDetails> tabs;
  PlanLoaded({this.upComingTasks, this.tags, this.goals, this.tabs});

  @override
  List<Object> get props => [goals, tabs, upComingTasks, tags];
}

class Error extends PlanState {
  final String message;

  Error({this.message});

  @override
  List<Object> get props => [message];
}
