part of 'diet_plan_bloc.dart';

abstract class DietPlanState extends Equatable {
  const DietPlanState();
}

class DietPlanInitial extends DietPlanState {
  @override
  List<Object> get props => [];
}

class DietPlanLoaded extends DietPlanState {
  final DietPlanEntitiy planEntitiy;
  DietPlanLoaded(
    this.planEntitiy,
  );

  @override
  List<Object> get props => [planEntitiy];
}

class DietPlanError extends DietPlanState {
  DietPlanError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}

class DietPlanEmpty extends DietPlanState {
  DietPlanEmpty();

  @override
  List<Object> get props => [];
}

class DietPlanListState extends DietPlanState {
  final List<DietPlanModel> workoutPlans;

  DietPlanListState(this.workoutPlans);

  @override
  List<Object> get props => [workoutPlans];
}
