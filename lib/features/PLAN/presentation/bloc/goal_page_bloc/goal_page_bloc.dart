import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/models/image.dart';
import 'package:sorted/core/global/models/tag.dart';
import 'package:sorted/features/PLAN/data/models/goal.dart';
import 'package:sorted/features/PLAN/data/models/task.dart';
import 'package:sorted/features/PLAN/data/models/task_status.dart';
import 'package:sorted/features/PLAN/domain/entities/tab_model.dart';
import 'package:sorted/features/PLAN/domain/repositories/goal_repository.dart';
import 'package:sorted/features/PLAN/domain/repositories/task_repository.dart';
import 'package:sorted/features/PLAN/presentation/bloc/plan_bloc/plan_bloc.dart';
part 'goal_page_event.dart';
part 'goal_page_state.dart';

class GoalPageBloc extends Bloc<GoalPageEvent, GoalPageBlocState> {
  final GoalRepository goalRepository;
  final PlanBloc planBloc;
  final TaskRepository taskRepository;
  GoalPageBloc(this.goalRepository, this.taskRepository, this.planBloc)
      : super(GoalPageLoading());

  @override
  Stream<GoalPageBlocState> mapEventToState(
    GoalPageEvent event,
  ) async* {
    if (event is TestEvent) {
      print("Reached Tester");
      DateTime now = DateTime.now();
      GoalModel goal1 = GoalModel.getRandom(now.millisecondsSinceEpoch);
      GoalModel goal2 = GoalModel.getRandom(now.millisecondsSinceEpoch + 1);

      await goalRepository.addGoal(goal1);
      await goalRepository.addGoal(goal2);

      TaskModel task1 = TaskModel.getRandom(now.millisecondsSinceEpoch);
      TaskModel task2 = TaskModel.getRandom(now.millisecondsSinceEpoch + 1);
      TaskModel task3 = TaskModel.getRandom(now.millisecondsSinceEpoch + 2);

      await taskRepository.addTask(goal: goal1, task: task1);
      await taskRepository.addTask(goal: goal1, task: task2);
      await taskRepository.addTask(goal: goal1, task: task3);
      TaskStatusModel status1 = new TaskStatusModel(
          id: now.millisecondsSinceEpoch, status: "Inprogress", savedTs: now);
      TaskStatusModel status2 = new TaskStatusModel(
          id: now.millisecondsSinceEpoch + 1,
          status: "Completed",
          savedTs: now);

      await taskRepository.addStatus(status1);
      await taskRepository.addStatus(status2);

      await taskRepository.linkStatusAndTask(status1, task1);
      await taskRepository.linkStatusAndTask(status1, task2);
      await taskRepository.linkStatusAndTask(status2, task3);
    }
    if (event is LoadGoalPage) {
      print("hello");
      Failure failure;

      List<TagModel> tags = [];
      List<TaskStatusModel> statuses = [];
      List<PlanTabDetails> tabDetails = [];

      var statusesOrFailure = await taskRepository.getAllStatus();
      statusesOrFailure.fold((l) {
        failure = l;
      }, (r) {
        statuses = r;
        r.forEach((element) {
          tabDetails.add(PlanTabDetails(
              type: 2, tabName: element.status, search: element.status));
        });
      });
      var tagsOrFailure = await taskRepository.getAllTags();
      tagsOrFailure.fold((l) {
        failure = l;
      }, (r) {
        tags = r;
        r.forEach((element) {
          tabDetails.add(PlanTabDetails(
              type: 3, tabName: element.tag, search: element.tag));
        });
      });
      yield GoalPageLoaded(
          thisGoal: event.thisGoal,
          tabs: tabDetails,
          tagsToAdd: [],
          newTask: TaskModel(),
          newEvent: TaskModel(),
          newMilestone: TaskModel());
    } else if (event is UpdateTaskDeadline) {
      print("updateDedaline");

      yield GoalPageLoaded(
        thisGoal: (state as GoalPageLoaded).thisGoal,
        tabs: (state as GoalPageLoaded).tabs,
        tagsToAdd: (state as GoalPageLoaded).tagsToAdd,
        newTask: (state as GoalPageLoaded)
            .newTask
            .copyWith(deadLine: event.newDeadline),
        newEvent: (state as GoalPageLoaded).newEvent,
        newMilestone: (state as GoalPageLoaded).newMilestone,
      );
    } else if (event is UpdateTaskPriority) {
      print("UpdateTaskPriority");
      yield GoalPageLoaded(
        thisGoal: (state as GoalPageLoaded).thisGoal,
        tabs: (state as GoalPageLoaded).tabs,
        newTask: (state as GoalPageLoaded)
            .newTask
            .copyWith(priority: event.newPriority),
        tagsToAdd: (state as GoalPageLoaded).tagsToAdd,
        newEvent: (state as GoalPageLoaded).newEvent,
        newMilestone: (state as GoalPageLoaded).newMilestone,
      );
    } else if (event is UpdateGoalCover) {
      print("UpdateGoalCover");
      print(state);
      if (state is GoalPageLoaded) {
        print("will update");
        print(state);
        yield GoalPageLoaded(
          thisGoal: (state as GoalPageLoaded)
              .thisGoal
              .copyWith(coverImageId: event.newurl),
          tabs: (state as GoalPageLoaded).tabs,
          newTask: (state as GoalPageLoaded).newTask,
          newEvent: (state as GoalPageLoaded).newEvent,
          tagsToAdd: (state as GoalPageLoaded).tagsToAdd,
          newMilestone: (state as GoalPageLoaded).newMilestone,
        );
      }
      await updateGoal((state as GoalPageLoaded)
          .thisGoal
          .copyWith(coverImageId: event.newurl));
    } else if (event is UpdateGoalEmoji) {
      print("UpdateGoalEmoji");
      print(state);
      if (state is GoalPageLoaded) {
        print("will update");
        print(state);
        yield GoalPageLoaded(
            thisGoal: (state as GoalPageLoaded)
                .thisGoal
                .copyWith(goalImageId: event.emoji),
            tabs: (state as GoalPageLoaded).tabs,
            newTask: (state as GoalPageLoaded).newTask,
            newEvent: (state as GoalPageLoaded).newEvent,
            newMilestone: (state as GoalPageLoaded).newMilestone,
            tagsToAdd: (state as GoalPageLoaded).tagsToAdd);
      }
      await updateGoal((state as GoalPageLoaded)
          .thisGoal
          .copyWith(goalImageId: event.emoji));
    } else if (event is AddImageAttachment) {
      GoalPageLoaded prev_state = (state as GoalPageLoaded);

      File result;
      Failure failure;
      print(event.attachmentName);
      result = await FilePicker.getFile(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        print(result.path);
        print(result.uri);
        print(p.basename(result.path));
      }
      DateTime now = DateTime.now();

      ImageModel newImage = new ImageModel(
          caption: "${event.attachmentName}",
          id: now.millisecondsSinceEpoch,
          localPath: (result.path),
          savedTs: now,
          position: 0);
      print("before");
      yield ImageUploadingState(file: result, image: newImage, progress: 0);
      var imageOrFailure = await goalRepository.storeImage(newImage, result);
      imageOrFailure.fold((l) {
        failure = l;
      }, (r) {
        newImage = r;
      });
      yield prev_state;
    } else if (event is UpdateTaskName) {
      print("UpdateTaskName");
      yield GoalPageLoaded(
          thisGoal: (state as GoalPageLoaded).thisGoal,
          tabs: (state as GoalPageLoaded).tabs,
          newTask:
              (state as GoalPageLoaded).newTask.copyWith(title: event.name),
          newEvent: (state as GoalPageLoaded).newEvent,
          newMilestone: (state as GoalPageLoaded).newMilestone,
          tagsToAdd: (state as GoalPageLoaded).tagsToAdd);
    } else if (event is AddNewTask) {
      DateTime now = DateTime.now();
      taskRepository
          .addTask(
              task: event.newTask.copyWith(id: now.millisecondsSinceEpoch),
              goal: (state as GoalPageLoaded).thisGoal)
          .then((value) {
        TaskModel task = TaskModel();
        value.fold((l) => null, (r) {
          task = r;
        });
        if (value.isRight()) {
          int i = -1;
          (state as GoalPageLoaded).tagsToAdd.forEach((element) async {
            i++;
            var errorOrTag = await taskRepository.getTagByName(element);
            errorOrTag.fold((l) => null, (r) {
              if (r.tag != "None") {
                taskRepository.linkTagAndTask(
                    r, task, now.millisecondsSinceEpoch + i);
              } else {
                TagModel newTag = new TagModel(
                  tag: element,
                  items: 0,
                  color: Colors
                      .primaries[element.hashCode % (Colors.primaries.length)]
                      .toString(),
                  id: now.millisecondsSinceEpoch + i,
                  savedTs: now,
                );
                taskRepository.addTag(tag: newTag, task: task).then((value) {
                  taskRepository.linkTagAndTask(
                      newTag, task, now.millisecondsSinceEpoch + i);
                });
              }
            });
          });
        }
      });

      print("end add task");
    } else if (event is UpdateTagsToAdd) {
      List<String> tagToAdd = [];
      event.tags.forEach((element) {
        tagToAdd.add(element.substring(1).toLowerCase());
      });
      yield GoalPageLoaded(
          thisGoal: (state as GoalPageLoaded).thisGoal,
          tabs: (state as GoalPageLoaded).tabs,
          newTask: (state as GoalPageLoaded).newTask,
          newEvent: (state as GoalPageLoaded).newEvent,
          newMilestone: (state as GoalPageLoaded).newMilestone,
          tagsToAdd: tagToAdd);
    }
  }

  Future<void> updateGoal(GoalModel goal) async {
    await goalRepository.updateGoal(goal);
  }

  @override
  Future<void> close() {
    print(" update plan");
    planBloc.add(LoadPlanPage());
    return super.close();
  }
}
