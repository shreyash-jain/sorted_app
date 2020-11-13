import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/models/attachment.dart';
import 'package:sorted/core/global/models/image.dart';
import 'package:sorted/core/global/models/tag.dart';
import 'package:sorted/features/PLAN/data/models/goal.dart';
import 'package:sorted/features/PLAN/data/models/task.dart';
import 'package:sorted/features/PLAN/data/models/task_status.dart';
import 'package:sorted/features/PLAN/data/models/todo.dart';
import 'package:sorted/features/PLAN/data/models/todo_item.dart';
import 'package:sorted/features/PLAN/domain/entities/tab_model.dart';
import 'package:sorted/features/PLAN/domain/repositories/goal_repository.dart';
import 'package:sorted/features/PLAN/domain/repositories/task_repository.dart';
import 'package:sorted/features/PLAN/presentation/bloc/plan_bloc/plan_bloc.dart';
import 'package:sorted/features/PLAN/presentation/widgets/tag_list.dart';
import 'package:sorted/features/PROFILE/data/models/activity.dart';
part 'task_page_event.dart';
part 'task_page_state.dart';

class TaskPageBloc extends Bloc<TaskPageEvent, TaskPageBlocState> {
  final GoalRepository goalRepository;
  final PlanBloc planBloc;
  final TaskRepository taskRepository;
  TaskPageBloc(this.goalRepository, this.taskRepository, this.planBloc)
      : super(TaskPageLoading());

  @override
  Stream<TaskPageBlocState> mapEventToState(
    TaskPageEvent event,
  ) async* {
    if (event is LoadTaskPage) {
      print("LoadTaskPage 33 ");
      yield TaskPageLoading();

      if (event.thisGoal == null) {
        print("LoadTaskPage ########");
        print(event.thisTask.coverImageid);
        yield TaskPageLoaded(
            thisTask: event.thisTask, thisGoal: event.thisGoal);
      }
      List<TagModel> tags = [];
      Failure failure;
      var tagsOrFailure = await taskRepository.getTagsOfTask(event.thisTask);
      tagsOrFailure.fold((l) {
        failure = l;
      }, (r) {
        tags = r;
      });
      if (failure == null) {
        yield TaskPageLoaded(
            thisTask: (state as TaskPageLoaded).thisTask,
            tags: tags,
            thisGoal: (state as TaskPageLoaded).thisGoal);
      }
    } else if (event is UpdateTaskEmoji) {
      print("UpdateTaskEmoji");
      print(state);
      if (state is TaskPageLoaded) {
        print("will update");
        print(state);
        yield TaskPageLoaded(
            thisTask: (state as TaskPageLoaded)
                .thisTask
                .copyWith(taskImageId: event.emoji),
            tags: (state as TaskPageLoaded).tags,
            thisGoal: (state as TaskPageLoaded).thisGoal);
      }
      await updateTask((state as TaskPageLoaded)
          .thisTask
          .copyWith(taskImageId: event.emoji));
    } else if (event is AddTodoItem) {
      DateTime now = DateTime.now();
      List<TodoItemModel> todos = [];
      if ((state as TaskPageLoaded).toAddTodosItems == null ||
          (state as TaskPageLoaded).toAddTodosItems.length == 0) {
        todos = [];
      } else
        todos = (state as TaskPageLoaded).toAddTodosItems;
      TodoItemModel newTodo = TodoItemModel(
          todoItem: event.todoItem,
          description: "",
          id: now.millisecondsSinceEpoch,
          state: 0,
          position: 0,
          savedTs: now);

      todos.add(newTodo);
      yield TaskPageLoaded(
          thisTask: (state as TaskPageLoaded).thisTask,
          tags: (state as TaskPageLoaded).tags,
          toAddTodosItems: todos,
          thisGoal: (state as TaskPageLoaded).thisGoal);
    } else if (event is UpdateTodoItems) {
      yield TaskPageLoaded(
          thisTask: (state as TaskPageLoaded).thisTask,
          tags: (state as TaskPageLoaded).tags,
          toAddTodosItems: event.todos,
          thisGoal: (state as TaskPageLoaded).thisGoal);
    }
  }

  Future<void> updateTask(TaskModel task) async {
    await taskRepository.updateTask(task);
  }

  @override
  Future<void> close() {
    print(" update plan");
    planBloc.add(LoadPlanPage());
    return super.close();
  }
}
