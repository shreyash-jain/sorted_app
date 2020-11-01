part of 'plan_bloc.dart';

abstract class PlanEvent extends Equatable {
  const PlanEvent();
}

class LoadPlanPage extends PlanEvent {
  @override
  List<Object> get props => [];
}

class UpdateGoals extends PlanEvent {
  final List<GoalModel> goals;
  UpdateGoals(this.goals);

  @override
  List<Object> get props => [goals];
}
class TestEvent extends PlanEvent {
  

  @override
  List<Object> get props => [];
}

class UpdateTabs extends PlanEvent {
  final List<PlanTabDetails> tabs;
  UpdateTabs(this.tabs);

  @override
  List<Object> get props => [tabs];
}


