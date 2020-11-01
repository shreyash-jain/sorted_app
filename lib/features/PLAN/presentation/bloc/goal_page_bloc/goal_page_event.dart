part of 'goal_page_bloc.dart';

abstract class GoalPageEvent extends Equatable {
  const GoalPageEvent();
}

class LoadGoalPage extends GoalPageEvent {
  final GoalModel thisGoal;
  LoadGoalPage(this.thisGoal);
  @override
  List<Object> get props => [thisGoal];
}

class UpdateGoals extends GoalPageEvent {
  final List<GoalModel> goals;
  UpdateGoals(this.goals);

  @override
  List<Object> get props => [goals];
} 

class UpdateTagsToAdd extends GoalPageEvent{
final List<String> tags;
  UpdateTagsToAdd(this.tags);

  @override
  List<Object> get props => [tags];

}

class UpdateTaskDeadline extends GoalPageEvent {
  final DateTime newDeadline;
  UpdateTaskDeadline(this.newDeadline);

  @override
  List<Object> get props => [newDeadline];
}

class UpdateTaskPriority extends GoalPageEvent {
  final double newPriority;
  UpdateTaskPriority(this.newPriority);

  @override
  List<Object> get props => [newPriority];
}
class UpdateTaskName extends GoalPageEvent {
  final String name;
  UpdateTaskName(this.name);

  @override
  List<Object> get props => [name];
}

class UpdateGoalCover extends GoalPageEvent {
  final String newurl;
  UpdateGoalCover(this.newurl);

  @override
  List<Object> get props => [newurl];
}

class UpdateGoalEmoji extends GoalPageEvent {
  final String emoji;
  UpdateGoalEmoji(this.emoji);

  @override
  List<Object> get props => [emoji];
}



class TestEvent extends GoalPageEvent {
  @override
  List<Object> get props => [];
}

class AddImageAttachment extends GoalPageEvent {
  final String attachmentName;

  AddImageAttachment(this.attachmentName);
  @override
  List<Object> get props => [attachmentName];
}

class AddNewTask extends GoalPageEvent {
  final TaskModel newTask;

  AddNewTask(this.newTask);
  @override
  List<Object> get props => [newTask];
}

class UpdateTabs extends GoalPageEvent {
  final List<PlanTabDetails> tabs;
  UpdateTabs(this.tabs);

  @override
  List<Object> get props => [tabs];
}
