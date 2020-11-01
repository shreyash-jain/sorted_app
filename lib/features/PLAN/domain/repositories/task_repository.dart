import 'package:dartz/dartz.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/models/tag.dart';
import 'package:sorted/features/PLAN/data/models/goal.dart';
import 'package:sorted/features/PLAN/data/models/task.dart';
import 'package:sorted/features/PLAN/data/models/task_status.dart';

abstract class TaskRepository {
  /// Gets the affirmations from cloud and favourates and also adds to local
  ///
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, List<TaskModel>>> getTasks(GoalModel goal);

  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, List<TaskModel>>> getUpcomingTasks();

  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, List<TaskStatusModel>>> getAllStatus();

  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, List<TaskModel>>> getTasksofStatus(String statusName);

  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, List<TaskModel>>> getTasksofTag(String tagName);

  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, TagModel>> getTagByName(String statusName);

  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, List<TagModel>>> getAllTags();

  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, List<TagModel>>> getTagsOfTask(TaskModel task);

  /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, TaskModel>> addTask({GoalModel goal, TaskModel task});

  /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, void>> updateTask( TaskModel task);

  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, void>> addStatus(TaskStatusModel status);

  Future<Either<Failure, void>> linkStatusAndTask(
      TaskStatusModel status, TaskModel task);

  Future<Either<Failure, void>> linkTagAndTask(
      TagModel tag, TaskModel task, int id);

  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, void>> addTag({TaskModel task, TagModel tag});

  /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, void>> removeTask(GoalModel goal, TaskModel task);
}
