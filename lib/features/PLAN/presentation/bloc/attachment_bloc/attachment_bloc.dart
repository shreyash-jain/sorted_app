import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
part 'attachment_event.dart';
part 'attachment_state.dart';

class AttachmentBloc extends Bloc<AttachmentEvent, AttachmentBlocState> {
  final GoalRepository goalRepository;
  final PlanBloc planBloc;
  final TaskRepository taskRepository;
  AttachmentBloc(this.goalRepository, this.taskRepository, this.planBloc)
      : super(AttachmentLoading());

  @override
  Stream<AttachmentBlocState> mapEventToState(
    AttachmentEvent event,
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
    if (event is AttachmentPage) {
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
      yield AttachmentLoaded(
          thisGoal: event.thisGoal,
          tabs: tabDetails,
          newTask: TaskModel(),
          newEvent: TaskModel(),
          newMilestone: TaskModel());
    } else if (event is UpdateTaskDeadline) {
      print("updateDedaline");
      yield AttachmentLoaded(
        thisGoal: (state as AttachmentLoaded).thisGoal,
        tabs: (state as AttachmentLoaded).tabs,
        newTask: (state as AttachmentLoaded)
            .newTask
            .copyWith(deadLine: event.newDeadline),
        newEvent: (state as AttachmentLoaded).newEvent,
        newMilestone: (state as AttachmentLoaded).newMilestone,
      );
    } else if (event is UpdateTaskPriority) {
      print("UpdateTaskPriority");
      yield AttachmentLoaded(
        thisGoal: (state as AttachmentLoaded).thisGoal,
        tabs: (state as AttachmentLoaded).tabs,
        newTask: (state as AttachmentLoaded)
            .newTask
            .copyWith(priority: event.newPriority),
        newEvent: (state as AttachmentLoaded).newEvent,
        newMilestone: (state as AttachmentLoaded).newMilestone,
      );
    } else if (event is UpdateGoalCover) {
      print("UpdateGoalCover");
      print(state);
      if (state is AttachmentLoaded) {
        print("will update");
        print(state);
        yield AttachmentLoaded(
          thisGoal: (state as AttachmentLoaded)
              .thisGoal
              .copyWith(coverImageId: event.newurl),
          tabs: (state as AttachmentLoaded).tabs,
          newTask: (state as AttachmentLoaded).newTask,
          newEvent: (state as AttachmentLoaded).newEvent,
          newMilestone: (state as AttachmentLoaded).newMilestone,
        );
      }
      await updateGoal((state as AttachmentLoaded)
          .thisGoal
          .copyWith(coverImageId: event.newurl));
    }
    else if (event is UpdateGoalEmoji){
      print("UpdateGoalEmoji");
      print(state);
      if (state is AttachmentLoaded) {
        print("will update");
        print(state);
        yield AttachmentLoaded(
          thisGoal: (state as AttachmentLoaded)
              .thisGoal
              .copyWith(goalImageId: event.emoji),
          tabs: (state as AttachmentLoaded).tabs,
          newTask: (state as AttachmentLoaded).newTask,
          newEvent: (state as AttachmentLoaded).newEvent,
          newMilestone: (state as AttachmentLoaded).newMilestone,
        );
      }
      await updateGoal((state as AttachmentLoaded)
          .thisGoal
          .copyWith(goalImageId: event.emoji));


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
