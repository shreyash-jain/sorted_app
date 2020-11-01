import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/models/tag.dart';
import 'package:sorted/features/PLAN/data/models/goal.dart';
import 'package:sorted/features/PLAN/data/models/task.dart';
import 'package:sorted/features/PLAN/data/models/task_status.dart';
import 'package:sorted/features/PLAN/domain/entities/tab_model.dart';
import 'package:sorted/features/PLAN/domain/repositories/goal_repository.dart';
import 'package:sorted/features/PLAN/domain/repositories/task_repository.dart';
part 'plan_event.dart';
part 'plan_state.dart';

class PlanBloc extends Bloc<PlanEvent, PlanState> {
  final GoalRepository goalRepository;
  final TaskRepository taskRepository;
  PlanBloc(this.goalRepository, this.taskRepository) : super(PlanLoading());
  @override
  Stream<PlanState> mapEventToState(
    PlanEvent event,
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
      TaskStatusModel status1 =
          new TaskStatusModel(id: 1, status: "Inprogress", savedTs: now);
      TaskStatusModel status2 =
          new TaskStatusModel(id: 2, status: "Completed", savedTs: now);

      await taskRepository.linkStatusAndTask(status1, task1);
      await taskRepository.linkStatusAndTask(status1, task2);
      await taskRepository.linkStatusAndTask(status2, task3);
    } else if (event is LoadPlanPage) {
      print("hello");
      Failure failure;
      List<GoalModel> goals;
      List<TagModel> tags = [];
      List<TaskModel> upComingTasks = [];
      List<TaskStatusModel> statuses = [];
      List<PlanTabDetails> tabDetails = [];
      var goalOrFailure = await goalRepository.getGoals();
      goalOrFailure.fold((l) {
        failure = l;
      }, (r) {
        goals = r;
        r.forEach((element) {
          print(element.coverImageId);
        });
      });
      print(failure);
      var upComingTasksOrFailure = await taskRepository.getUpcomingTasks();
      upComingTasksOrFailure.fold((l) {
        failure = l;
      }, (r) {
        upComingTasks = r;
      });
      var statusesOrFailure = await taskRepository.getAllStatus();
      statusesOrFailure.fold((l) {
        failure = l;
      }, (r) {
        statuses = r;
        r.forEach((element) {
          if (element.numItems > 0)
            tabDetails.add(PlanTabDetails(
                type: 0,
                tabName: element.status,
                search: element.status,
                imagePath: element.imagePath));
        });
      });
      print(failure);
      var tagsOrFailure = await taskRepository.getAllTags();
      tagsOrFailure.fold((l) {
        failure = l;
        print(failure);
      }, (r) {
        tags = r;
        
        r.forEach((element) {
           if (element.items > 0)
          tabDetails.add(PlanTabDetails(
              type: 1, tabName: "'" + element.tag + "'", search: element.tag));
        });
      });
      if (failure == null)
        yield PlanLoaded(
            goals: goals,
            tabs: tabDetails,
            tags: tags,
            upComingTasks: upComingTasks);
      else {
        print("failed");
      }
    }
  }
}
