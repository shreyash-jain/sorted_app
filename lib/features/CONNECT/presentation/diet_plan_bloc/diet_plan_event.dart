part of 'diet_plan_bloc.dart';

abstract class DietPlanEvent extends Equatable {
  const DietPlanEvent();
}

class LoadCurrentDietPlan extends DietPlanEvent {
  final ClientConsultationModel consultation;

  LoadCurrentDietPlan(this.consultation);
  @override
  List<Object> get props => [consultation];
}

class LoadDietBoard extends DietPlanEvent {
  final List<DayDiet> dayDiets;

  LoadDietBoard(this.dayDiets);
  @override
  List<Object> get props => [];
}

class LoadDietPlan extends DietPlanEvent {
  final DietPlanModel plan;

  LoadDietPlan(this.plan);
  @override
  List<Object> get props => [plan];
}

class LoadConsultationDietplanList extends DietPlanEvent {
  final ClientConsultationModel consultation;

  LoadConsultationDietplanList(this.consultation);

  @override
  List<Object> get props => [consultation];
}

class GetRecommendedDietPlan extends DietPlanEvent {
  @override
  List<Object> get props => [];
}
