part of 'tab_bloc.dart';

abstract class TabEvent extends Equatable {
  const TabEvent();
}

class UpdateTasks extends TabEvent {
  final PlanTabDetails tab;
  UpdateTasks(this.tab);

  @override
  List<Object> get props => [tab];
}
