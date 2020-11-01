part of 'task_page_bloc.dart';

abstract class TaskPageBlocState extends Equatable {
  const TaskPageBlocState();
}

class TaskPageLoading extends TaskPageBlocState {
  @override
  List<Object> get props => [];
}

class TaskPageLoaded extends TaskPageBlocState {
  final TaskModel thisTask;
  final GoalModel thisGoal;
  final List<TagModel> tags;
  final List<AttachmentModel> attachments;
  final List<ImageModel> images;
  final List<TodoModel> todos;
  final List<TodoItemModel> toAddTodosItems;
  final List<ActivityModel> activities;

  TaskPageLoaded({
    this.thisGoal,
    this.activities,
    this.thisTask,
    this.tags,
    this.attachments,
    this.images,
    this.todos,
    this.toAddTodosItems,
  });

  @override
  List<Object> get props =>
      [thisTask, tags, attachments, images, todos, toAddTodosItems, activities];
}

class ImageUploadingState extends TaskPageBlocState {
  final File file;
  final ImageModel image;
  final double progress;

  ImageUploadingState({this.file, this.image, this.progress});

  @override
  List<Object> get props => [image, progress];
}

class TaskPageError extends TaskPageBlocState {
  final String message;

  TaskPageError({this.message});

  @override
  List<Object> get props => [message];
}
