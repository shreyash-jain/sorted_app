part of 'tab_bloc.dart';

abstract class TabState extends Equatable {
  const TabState();
}

class TabLoading extends TabState {
  @override
  List<Object> get props => [];
}

class TabLoaded extends TabState {
  final PlanTabDetails tab;
  final List<TaskModel> tasks;
  TabLoaded({this.tab, this.tasks});
  @override
  List<Object> get props => [tab, tasks];
}
