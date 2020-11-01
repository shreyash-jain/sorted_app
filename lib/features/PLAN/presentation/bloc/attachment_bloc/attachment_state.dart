part of 'attachment_bloc.dart';

abstract class AttachmentBlocState extends Equatable {
  const AttachmentBlocState();
}

class AttachmentLoading extends AttachmentBlocState {
  @override
  List<Object> get props => [];
}

class AttachmentLoaded extends AttachmentBlocState {
  final GoalModel thisGoal;
  final List<PlanTabDetails> tabs;
  final TaskModel newTask;
  final TaskModel newEvent;
  final TaskModel newMilestone;

  AttachmentLoaded(
      {this.newTask,
      this.newEvent,
      this.newMilestone,
      this.thisGoal,
      this.tabs});

  @override
  List<Object> get props => [thisGoal, tabs, newTask, newEvent, newMilestone];
}

class AttachmentError extends AttachmentBlocState {
  final String message;

  AttachmentError({this.message});

  @override
  List<Object> get props => [message];
}
