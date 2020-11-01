import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:dartz/dartz_streaming.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/database/datasources/attachments_sources/attachments_cloud_data_source.dart';
import 'package:sorted/core/global/database/datasources/attachments_sources/attachments_native_data_source.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/models/log.dart';
import 'package:sorted/core/global/models/tag.dart';
import 'package:sorted/core/network/network_info.dart';
import 'package:sorted/features/HOME/data/datasources/home_cloud_data_source.dart';
import 'package:sorted/features/HOME/data/datasources/home_native_data_source.dart';
import 'package:sorted/features/HOME/data/datasources/home_remote_api_data_source.dart';
import 'package:sorted/features/HOME/data/datasources/home_shared_pref_data_source.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/data/models/inspiration.dart';
import 'package:sorted/features/HOME/data/models/placeholder_info.dart' as ph;
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:sorted/features/HOME/domain/entities/display_thumbnail.dart';
import 'package:sorted/features/HOME/domain/entities/unsplash_image.dart';
import 'package:sorted/features/HOME/domain/repositories/home_repository.dart';
import 'package:sorted/features/PLAN/data/datasources/goal_sources/goal_cloud_data_source.dart';
import 'package:sorted/features/PLAN/data/datasources/goal_sources/goal_native_data_source.dart';
import 'package:sorted/features/PLAN/data/datasources/task_sources/task_cloud_data_source.dart';
import 'package:sorted/features/PLAN/data/datasources/task_sources/task_native_data_source.dart';
import 'package:sorted/features/PLAN/data/datasources/task_sources/task_shared_pref_data_source.dart';
import 'package:sorted/features/PLAN/data/models/goal.dart';
import 'package:sorted/features/PLAN/data/models/task.dart';
import 'package:sorted/features/PLAN/data/models/task_status.dart';
import 'package:sorted/features/PLAN/domain/repositories/goal_repository.dart';
import 'package:sorted/features/PLAN/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskCloud remoteTaskDataSource;
  final TaskNative nativeTaskDataSource;
  final TaskSharedPref sharedPrefTask;
  final NetworkInfo networkInfo;
  final GoalCloud remoteGoalDataSource;
  final GoalNative nativeGoalDataSource;
  final AttachmentsCloud remoteAttachmentDataSource;
  final AttachmentsNative nativeAttachmentDataSource;

  final _random = new Random();

  TaskRepositoryImpl(
      {@required this.remoteTaskDataSource,
      @required this.nativeTaskDataSource,
      @required this.networkInfo,
      @required this.sharedPrefTask,
      @required this.remoteAttachmentDataSource,
      @required this.nativeAttachmentDataSource,
      @required this.nativeGoalDataSource,
      @required this.remoteGoalDataSource});

  @override
  Future<Either<Failure, TaskModel>> addTask(
      {GoalModel goal, TaskModel task}) async {
    DateTime now = DateTime.now();
    task = task.copyWith(startDate: now);
    task = task.copyWith(linkedStatus: 3);
    task = task.copyWith(linkedLogs: task.linkedLogs + 1);
    try {
      await nativeTaskDataSource.addTask(task);

      LogModel taskLog = LogModel(
          id: now.millisecondsSinceEpoch,
          level: 0,
          connectedId: task.id,
          savedTs: now,
          message: "Started this task",
          date: now,
          type: 1,
          path: task.taskImageId);
      nativeAttachmentDataSource.addLog(taskLog).then((value) {
        remoteAttachmentDataSource.addLog(taskLog);
        nativeTaskDataSource
            .addLinkLogToTask(task, taskLog, now.millisecondsSinceEpoch)
            .then((value) {
          remoteTaskDataSource.addLinkLogToTask(
              task, taskLog, now.millisecondsSinceEpoch);

          //Todo: add status of task to inprogress with fixed id for now done with status id:1
        });
        nativeTaskDataSource.getStatusById(task.linkedStatus).then((value) {
          TaskStatusModel updatedStatus =
              value.copyWith(numItems: value.numItems + 1);
          nativeTaskDataSource.updateStatus(updatedStatus).then((value) {
            remoteTaskDataSource.updateStatus(updatedStatus);
          });
        });
      });

      try {
        remoteTaskDataSource.addTask(task);
      } on Exception {
        return Left(ServerFailure());
      }
      if (goal != null) {
        try {
          goal = goal.copyWith(linkedLogs: goal.linkedLogs + 1);
          goal = goal.copyWith(linkedTasks: goal.linkedTasks + 1);
          nativeGoalDataSource.updateGoal(goal).then((value) {
            remoteGoalDataSource.updateGoal(goal);
          });
          await nativeGoalDataSource.addLinkTaskToGoal(
              goal, task, now.millisecondsSinceEpoch);

          LogModel goalLog = LogModel(
              id: now.millisecondsSinceEpoch + 1,
              level: 0,
              connectedId: goal.id,
              message: "Added task ${task.title}",
              savedTs: now,
              date: now,
              type: 0,
              path: goal.goalImageId);
          nativeAttachmentDataSource.addLog(goalLog).then((value) {
            remoteAttachmentDataSource.addLog(goalLog);
            nativeGoalDataSource
                .addLinkLogToGoal(goal, taskLog, now.millisecondsSinceEpoch + 1)
                .then((value) {
              remoteGoalDataSource.addLinkLogToGoal(
                  goal, taskLog, now.millisecondsSinceEpoch);
            });
          });
          try {
            remoteGoalDataSource.addLinkTaskToGoal(
                goal, task, now.millisecondsSinceEpoch);
          } on Exception {
            return Left(ServerFailure());
          }
        } on Exception {
          return Left(NativeDatabaseException());
        }
      }
    } on Exception {
      return Left(NativeDatabaseException());
    }

    return Right(task);
  }

  @override
  Future<Either<Failure, List<TaskModel>>> getTasks(GoalModel goal) async {
    try {
      return Right(await nativeGoalDataSource.getTasksOfGoal(goal));
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, void>> removeTask(GoalModel goal, TaskModel task) {
    // TODO: implement removeTask
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> addStatus(TaskStatusModel status) async {
    try {
      await nativeTaskDataSource.addStatus(status);
      try {
        remoteTaskDataSource.addStatus(status);
        return Right(null);
      } on Exception {
        return Left(ServerFailure());
      }
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, void>> addTag({TaskModel task, TagModel tag}) async {
    try {
      await nativeAttachmentDataSource.addTag(tag);
      try {
        remoteAttachmentDataSource.addTag(tag);
      } on Exception {
        return Left(ServerFailure());
      }
      return Right(null);
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, void>> linkStatusAndTask(
      TaskStatusModel status, TaskModel task) async {
    DateTime now = DateTime.now();
    try {
      await nativeTaskDataSource.removeAllStatusFromTask(task);
      await nativeTaskDataSource.addLinkTaskToStatus(
          task, status, now.millisecondsSinceEpoch);
      try {
        remoteTaskDataSource.addLinkTaskToStatus(
            task, status, now.millisecondsSinceEpoch);
      } on Exception {
        return Left(ServerFailure());
      }
      return Right(null);
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, List<TaskStatusModel>>> getAllStatus() async {
    try {
      return Right(await nativeTaskDataSource.getAllStatus());
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, List<TagModel>>> getAllTags() async {
    try {
      return Right(await nativeAttachmentDataSource.allTags);
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, List<TaskModel>>> getTasksofStatus(
      String statusName) async {
    TaskStatusModel status;
    List<TaskModel> tasks;
    Failure failure;
    try {
      status = await nativeTaskDataSource.getStatusByName(statusName);
      try {
        tasks = await nativeTaskDataSource.getTasksOfStatus(status);
        return Right(tasks);
      } on Exception {
        Left(NativeDatabaseException());
      }
    } on Exception {
      Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, List<TaskModel>>> getTasksofTag(String tagName) async {
    TagModel tag;
    List<TaskModel> tasks;
    Failure failure;
    try {
      tag = await nativeAttachmentDataSource.getTagByName(tagName);
      try {
        tasks = await nativeTaskDataSource.getTasksOfTag(tag);
        return Right(tasks);
      } on Exception {
        Left(NativeDatabaseException());
      }
    } on Exception {
      Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, TagModel>> getTagByName(String statusName) async {
    TagModel tag;
    List<TaskModel> tasks;
    Failure failure;
    try {
      tag = await nativeAttachmentDataSource.getTagByName(statusName);
      return Right(tag);
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, void>> linkTagAndTask(
      TagModel tag, TaskModel task, int id) async {
    DateTime now = DateTime.now();
    try {
      await nativeTaskDataSource.addLinkTagToTask(task, tag, id);
      nativeTaskDataSource
          .updateTask(task.copyWith(linkedTags: task.linkedTags + 1))
          .then((value) {
        remoteTaskDataSource
            .updateTask(task.copyWith(linkedTags: task.linkedTags + 1));
      });
      nativeAttachmentDataSource
          .updateTag(tag.copyWith(items: tag.items + 1))
          .then((value) {
        remoteAttachmentDataSource
            .updateTag(tag.copyWith(items: tag.items + 1));
      });
      try {
        remoteTaskDataSource.addLinkTagToTask(task, tag, id);
      } on Exception {
        return Left(ServerFailure());
      }
      return Right(null);
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, List<TaskModel>>> getUpcomingTasks() async {
    List<TaskModel> tasks = [];
    Failure failure;
    try {
      tasks = await nativeTaskDataSource.getUpcomingTasks();
      return Right(tasks);
    } on Exception {
      Left(NativeDatabaseException());
    }
    return Right(tasks);
  }

  @override
  Future<Either<Failure, List<TagModel>>> getTagsOfTask(TaskModel task) async {
    List<TagModel> tags = [];
    Failure failure;
    try {
      tags = await nativeTaskDataSource.getTagsOfTask(task);
      return Right(tags);
    } on Exception {
      Left(NativeDatabaseException());
    }
    return Right(tags);
  }

  @override
  Future<Either<Failure, void>> updateTask(TaskModel task) async {
    print("here");
    try {
      nativeTaskDataSource.updateTask(task).then((value) {
        remoteTaskDataSource.updateTask(task);
      });

      return Right(null);
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }
}
