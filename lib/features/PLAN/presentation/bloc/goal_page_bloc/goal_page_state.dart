part of 'goal_page_bloc.dart';

abstract class GoalPageBlocState extends Equatable {
  const GoalPageBlocState();
}

class GoalPageLoading extends GoalPageBlocState {
  @override
  List<Object> get props => [];
}

class GoalPageLoaded extends GoalPageBlocState {
  final GoalModel thisGoal;
  final List<PlanTabDetails> tabs;
  final TaskModel newTask;
  final TaskModel newEvent;
  final TaskModel newMilestone;
  final List<String> tagsToAdd;

  GoalPageLoaded(
      {this.tagsToAdd,
      this.newTask,
      this.newEvent,
      this.newMilestone,
      this.thisGoal,
      this.tabs});

  @override
  List<Object> get props =>
      [thisGoal, tabs, newTask, newEvent, newMilestone, tagsToAdd];
}

class ImageUploadingState extends GoalPageBlocState {
  final File file;
  final ImageModel image;
  final double progress;

  ImageUploadingState({this.file, this.image, this.progress});

  @override
  List<Object> get props => [image, progress];
}

class GoalPageError extends GoalPageBlocState {
  final String message;

  GoalPageError({this.message});

  @override
  List<Object> get props => [message];
}
