part of 'attachment_bloc.dart';

abstract class AttachmentEvent extends Equatable {
  const AttachmentEvent();
}

class AttachmentPage extends AttachmentEvent {
  final GoalModel thisGoal;
  AttachmentPage(this.thisGoal);
  @override
  List<Object> get props => [thisGoal];
}

class UpdateGoals extends AttachmentEvent {
  final List<GoalModel> goals;
  UpdateGoals(this.goals);

  @override
  List<Object> get props => [goals];
}

class UpdateTaskDeadline extends AttachmentEvent {
  final DateTime newDeadline;
  UpdateTaskDeadline(this.newDeadline);

  @override
  List<Object> get props => [newDeadline];
}

class UpdateTaskPriority extends AttachmentEvent {
  final double newPriority;
  UpdateTaskPriority(this.newPriority);

  @override
  List<Object> get props => [newPriority];
}
class UpdateGoalCover extends AttachmentEvent {
  final String newurl;
  UpdateGoalCover(this.newurl);

  @override
  List<Object> get props => [newurl];
}
class UpdateGoalEmoji extends AttachmentEvent {
  final String emoji;
  UpdateGoalEmoji(this.emoji);

  @override
  List<Object> get props => [emoji];
}

class TestEvent extends AttachmentEvent {
  @override
  List<Object> get props => [];
}

class UpdateTabs extends AttachmentEvent {
  final List<PlanTabDetails> tabs;
  UpdateTabs(this.tabs);

  @override
  List<Object> get props => [tabs];
}
