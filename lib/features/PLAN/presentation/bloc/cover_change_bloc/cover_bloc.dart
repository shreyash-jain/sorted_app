import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/models/tag.dart';
import 'package:sorted/features/HOME/domain/entities/unsplash_image.dart';
import 'package:sorted/features/PLAN/data/models/goal.dart';
import 'package:sorted/features/PLAN/data/models/task.dart';
import 'package:sorted/features/PLAN/data/models/task_status.dart';
import 'package:sorted/features/PLAN/domain/entities/tab_model.dart';
import 'package:sorted/features/PLAN/domain/repositories/goal_repository.dart';
import 'package:sorted/features/PLAN/domain/repositories/task_repository.dart';
part 'cover_event.dart';
part 'cover_state.dart';

class CoverBloc extends Bloc<CoverEvent, CoverState> {
  final GoalRepository goalRepository;
  final TaskRepository taskRepository;
  CoverBloc(this.goalRepository, this.taskRepository) : super(CoverLoading());
  @override
  Stream<CoverState> mapEventToState(
    CoverEvent event,
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
    if (event is LoadImages) {
      print("hello");
      Failure failure;
      List<String> gradientImages = [];
      List<String> workImages = [];
      List<String> studyImages = [];
      List<String> inspireImages = [];
      var gradientOrFailure = await goalRepository.getGradientUrls();
      gradientOrFailure.fold((l) {
        failure = l;
      }, (r) {
        gradientImages = r;
      });
      if (failure == null)
        yield CoverLoaded(
            inspireUrls: inspireImages,
            gradientUrls: gradientImages,
            workUrls: workImages,
            studyUrls: studyImages);

      var workOrFailure = await goalRepository.getWorkUrls();
      workOrFailure.fold((l) {
        failure = l;
      }, (r) {
        workImages = r;
      });
      if (failure == null)
        yield CoverLoaded(
            inspireUrls: inspireImages,
            gradientUrls: gradientImages,
            workUrls: workImages,
            studyUrls: studyImages);

      var studyOrFailure = await goalRepository.getStudyUrls();
      studyOrFailure.fold((l) {
        failure = l;
      }, (r) {
        studyImages = r;
      });
      if (failure == null)
        yield CoverLoaded(
            inspireUrls: inspireImages,
            gradientUrls: gradientImages,
            workUrls: workImages,
            studyUrls: studyImages);

      var inspireOrFailure = await goalRepository.getInspireUrls();
      inspireOrFailure.fold((l) {
        failure = l;
      }, (r) {
        inspireImages = r;
      });
      if (failure == null)
        yield CoverLoaded(
            inspireUrls: inspireImages,
            gradientUrls: gradientImages,
            workUrls: workImages,
            studyUrls: studyImages);
    } else if (event is StartSearchEvent) {
      yield StartSearchState();
    } else if (event is SearchUnsplash) {
      yield SearchLoading();
      Failure failure;
      List<UnsplashImage> images = [];
      var imagesOrFailure = await goalRepository.getSearchImages(event.search);
      imagesOrFailure.fold((l) {
        failure = l;
      }, (r) {
        images = r;
      });
      if (failure == null) {
        yield SearchLoaded(images: images);
      } else {
        print(failure);
      }
    }
  }
}
