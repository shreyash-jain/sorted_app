part of 'task_page_bloc.dart';

abstract class TaskPageEvent extends Equatable {
  const TaskPageEvent();
}

class UpdateTaskEmoji extends TaskPageEvent {
  final String emoji;
  UpdateTaskEmoji(this.emoji);

  @override
  List<Object> get props => [emoji];
}

class AddTodoItem extends TaskPageEvent {
  final String todoItem;
  AddTodoItem(this.todoItem);

  @override
  List<Object> get props => [todoItem];
}

class LoadTaskPage extends TaskPageEvent {
  final GoalModel thisGoal;
  final TaskModel thisTask;
  LoadTaskPage(this.thisTask, {this.thisGoal});
  @override
  List<Object> get props => [thisGoal, thisTask];
}
