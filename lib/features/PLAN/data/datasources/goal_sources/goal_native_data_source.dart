import 'dart:math';

import 'package:flutter/material.dart';
import 'package:googleapis/classroom/v1.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/database/sqflite_init.dart';
import 'package:sorted/core/global/models/attachment.dart';
import 'package:sorted/core/global/models/image.dart';
import 'package:sorted/core/global/models/link.dart';
import 'package:sorted/core/global/models/log.dart';
import 'package:sorted/core/global/models/tag.dart';
import 'package:sorted/core/global/models/textbox.dart';

import 'package:sorted/features/HOME/data/models/inspiration.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:sorted/features/HOME/data/models/placeholder_info.dart';
import 'package:sorted/features/HOME/domain/entities/unsplash_image.dart';
import 'package:sorted/features/PLAN/data/models/goal.dart';
import 'package:sorted/features/PLAN/data/models/task.dart';
import 'package:sorted/features/PLAN/data/models/task_status.dart';

abstract class GoalNative {
  Future<void> addGoal(GoalModel goal);
  Future<void> updateGoal(GoalModel goal);
  Future<void> deleteGoal(GoalModel goal);
  Future<void> addLinkImageToGoal(GoalModel goal, ImageModel image, int id);
  Future<int> removeLinkImageFromGoal(GoalModel goal, ImageModel image);
  Future<void> addLinkTagToGoal(GoalModel goal, TagModel tag, int id);
  Future<int> removeLinkTagFromGoal(GoalModel goal, TagModel tag);
  Future<void> addLinkLogToGoal(GoalModel goal, LogModel log, int id);
  Future<int> removeLinkLogFromGoal(GoalModel goal, LogModel log);
  Future<void> addLinkTextboxToGoal(
      GoalModel goal, TextboxModel textbox, int id);
  Future<int> removeLinkTextboxFromGoal(GoalModel goal, TextboxModel textbox);
  Future<void> addLinkLinkToGoal(GoalModel goal, LinkModel link, int id);
  Future<int> removeLinkLinkFromGoal(GoalModel goal, LinkModel link);
  Future<void> addLinkAttachmentToGoal(GoalModel goal, AttachmentModel attachment, int id);
  Future<int> removeLinkAttachmentFromGoal(GoalModel goal, AttachmentModel attachment);
  Future<void> addLinkTaskToGoal(GoalModel goal, TaskModel task, int id);
  Future<int> removeLinkTaskFromGoal(GoalModel goal, TaskModel task);

  Future<GoalModel> getGoalOfTask(TaskModel task);
  Future<List<GoalModel>> getAllGoals();
  Future<List<TaskModel>> getTasksOfGoal(GoalModel goal);
  Future<List<ImageModel>> getImagesOfGoal(GoalModel goal);
  Future<List<LinkModel>> getLinksOfGoal(GoalModel goal);
  Future<List<TagModel>> getTagsOfGoal(GoalModel goal);
  Future<List<TextboxModel>> getTextboxesOfGoal(GoalModel goal);
  Future<List<LogModel>> getLogsOfGoal(GoalModel goal);

  Future<List<TaskModel>> getTasksOfGoalStatus(
      GoalModel goal, TaskStatusModel status);

  Future<List<TaskModel>> getMilestonesOfGoal(GoalModel goal);
  Future<List<TaskModel>> getTasksOfGoalOrderByDeadline(
      GoalModel goal, TagModel tag);

  Future<List<TaskModel>> getTasksOfGoalOfTag(GoalModel goal, TagModel tag);
  Future<List<TaskModel>> getEventsOfGoal(GoalModel goal);
}

class GoalNativeDataSourceImpl implements GoalNative {
  final SqlDatabaseService nativeDb;

  GoalNativeDataSourceImpl({@required this.nativeDb});

  @override
  Future<void> addGoal(GoalModel goal) async {
    final db = await nativeDb.database;
    if ((await db.query(goal.getTable(), where: "id= ?", whereArgs: [goal.id]))
            .length ==
        0)
      await db.insert(goal.getTable(), goal.toMap());
    else
      await db.update(goal.getTable(), goal.toMap(),
          where: "id = ?", whereArgs: [goal.id]);
  }

  @override
  Future<void> addLinkAttachmentToGoal(
      GoalModel goal, AttachmentModel attachment, int id) async {
    final db = await nativeDb.database;
    if ((await db.query(goal.getTableLinkAttachment(),
                where: "goal_id=? and attachment_id=?",
                whereArgs: [goal.id, attachment.id]))
            .length ==
        0)
      await db.insert(goal.getTableLinkAttachment(), {
        "goal_id": goal.id,
        "attachment_id": attachment.id,
        "savedTs": DateTime.now().millisecondsSinceEpoch,
        "id": id
      });
  }

  @override
  Future<void> addLinkImageToGoal(
      GoalModel goal, ImageModel image, int id) async {
    final db = await nativeDb.database;
    if ((await db.query(goal.getTableLinkImages(),
                where: "goal_id=? and image_id=?",
                whereArgs: [goal.id, image.id]))
            .length ==
        0)
      await db.insert(goal.getTableLinkImages(), {
        "goal_id": goal.id,
        "image_id": image.id,
        "savedTs": DateTime.now().millisecondsSinceEpoch,
        "id": id
      });
  }

  @override
  Future<void> addLinkLinkToGoal(GoalModel goal, LinkModel link, int id) async {
    final db = await nativeDb.database;
    if ((await db.query(goal.getTableLinkLinks(),
                where: "goal_id=? and link_id=?",
                whereArgs: [goal.id, link.id]))
            .length ==
        0)
      await db.insert(goal.getTableLinkImages(), {
        "goal_id": goal.id,
        "link_id": link.id,
        "savedTs": DateTime.now().millisecondsSinceEpoch,
        "id": id
      });
  }

  @override
  Future<void> addLinkLogToGoal(GoalModel goal, LogModel log, int id) async {
    final db = await nativeDb.database;
    if ((await db.query(goal.getTableLinkLogs(),
                where: "goal_id=? and log_id=?", whereArgs: [goal.id, log.id]))
            .length ==
        0)
      await db.insert(goal.getTableLinkLogs(), {
        "goal_id": goal.id,
        "log_id": log.id,
        "savedTs": DateTime.now().millisecondsSinceEpoch,
        "id": id
      });
  }

  @override
  Future<void> addLinkTagToGoal(GoalModel goal, TagModel tag, int id) async {
    final db = await nativeDb.database;
    if ((await db.query(goal.getTableLinkTags(),
                where: "goal_id=? and tag_id=?", whereArgs: [goal.id, tag.id]))
            .length ==
        0)
      await db.insert(goal.getTableLinkTags(), {
        "goal_id": goal.id,
        "tag_id": tag.id,
        "savedTs": DateTime.now().millisecondsSinceEpoch,
        "id": id
      });
  }

  @override
  Future<void> addLinkTaskToGoal(GoalModel goal, TaskModel task, int id) async {
    final db = await nativeDb.database;
    if ((await db.query(goal.getTableLinkTasks(),
                where: "goal_id=? and task_id=?",
                whereArgs: [goal.id, task.id]))
            .length ==
        0)
      await db.insert(goal.getTableLinkTasks(), {
        "goal_id": goal.id,
        "task_id": task.id,
        "savedTs": DateTime.now().millisecondsSinceEpoch,
        "id": id
      });
  }

  @override
  Future<void> addLinkTextboxToGoal(
      GoalModel goal, TextboxModel textbox, int id) async {
    final db = await nativeDb.database;
    if ((await db.query(goal.getTableLinktextbox(),
                where: "goal_id=? and textbox_id=?",
                whereArgs: [goal.id, textbox.id]))
            .length ==
        0)
      await db.insert(goal.getTableLinktextbox(), {
        "goal_id": goal.id,
        "textbox_id": textbox.id,
        "savedTs": DateTime.now().millisecondsSinceEpoch,
        "id": id
      });
  }

  @override
  Future<void> deleteGoal(GoalModel goal) async {
    final db = await nativeDb.database;
    if ((await db.query(goal.getTable(), where: "id=?", whereArgs: [goal.id]))
            .length >
        0) db.delete(goal.getTable(), where: "id=?", whereArgs: [goal.id]);
  }

  @override
  Future<List<TaskModel>> getTasksOfGoalStatus(
      GoalModel goal, TaskStatusModel status) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;

    result = await db.rawQuery(
        "SELECT t.* FROM Tasks t INNER JOIN Goals_Tasks gt ON gt.task_id = t.id INNER JOIN Tasks_Status ts ON ts.task_id = t.id WHERE status_id=${status.id} and goal_id=${goal.id} and type=0");

    List<TaskModel> tasks = result.isNotEmpty
        ? result.map((item) => TaskModel.fromMap(item)).toList()
        : [];
    return tasks;
  }

  @override
  Future<List<TaskModel>> getEventsOfGoal(GoalModel goal) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;

    result = await db.rawQuery(
        "SELECT t.* FROM Tasks t INNER JOIN Goals_Tasks gt ON gt.task_id = t.id WHERE type=1 and goal_id=${goal.id}");

    List<TaskModel> tasks = result.isNotEmpty
        ? result.map((item) => TaskModel.fromMap(item)).toList()
        : [];
    return tasks;
  }

  @override
  Future<GoalModel> getGoalOfTask(TaskModel task) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;

    result = await db.rawQuery(
        "SELECT t.* FROM Goals t INNER JOIN Goals_Tasks gt ON gt.goal_id = t.id WHERE task_id=${task.id}");

    List<GoalModel> goals = result.isNotEmpty
        ? result.map((item) => GoalModel.fromMap(item)).toList()
        : [];
    return goals[0];
  }

  @override
  Future<List<ImageModel>> getImagesOfGoal(GoalModel goal) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;

    result = await db.rawQuery(
        "SELECT t.* FROM Images t INNER JOIN ${goal.getTableLinkImages()} gt ON gt.image_id = t.id WHERE goal_id=${goal.id}");

    List<ImageModel> images = result.isNotEmpty
        ? result.map((item) => ImageModel.fromMap(item)).toList()
        : [];
    return images;
  }

  @override
  Future<List<LinkModel>> getLinksOfGoal(GoalModel goal) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;

    result = await db.rawQuery(
        "SELECT t.* FROM Links t INNER JOIN ${goal.getTableLinkLinks()} gt ON gt.link_id = t.id WHERE goal_id=${goal.id}");

    List<LinkModel> items = result.isNotEmpty
        ? result.map((item) => LinkModel.fromMap(item)).toList()
        : [];
    return items;
  }

  @override
  Future<List<TaskModel>> getMilestonesOfGoal(GoalModel goal) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;

    result = await db.rawQuery(
        "SELECT t.* FROM Tasks t INNER JOIN Goals_Tasks gt ON gt.task_id = t.id WHERE type=2 and goal_id=${goal.id}");

    List<TaskModel> tasks = result.isNotEmpty
        ? result.map((item) => TaskModel.fromMap(item)).toList()
        : [];
    return tasks;
  }

  @override
  Future<List<TagModel>> getTagsOfGoal(GoalModel goal) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;

    result = await db.rawQuery(
        "SELECT t.* FROM Tags t INNER JOIN ${goal.getTableLinkTags()} gt ON gt.tag_id = t.id WHERE goal_id=${goal.id}");

    List<TagModel> items = result.isNotEmpty
        ? result.map((item) => TagModel.fromMap(item)).toList()
        : [];
    return items;
  }

  @override
  Future<List<TaskModel>> getTasksOfGoal(GoalModel goal) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;

    result = await db.rawQuery(
        "SELECT t.* FROM Tasks t INNER JOIN Goals_Tasks gt ON gt.task_id = t.id WHERE type=0 and goal_id=${goal.id}");

    List<TaskModel> tasks = result.isNotEmpty
        ? result.map((item) => TaskModel.fromMap(item)).toList()
        : [];
    return tasks;
  }

  @override
  Future<List<TaskModel>> getTasksOfGoalOrderByDeadline(
      GoalModel goal, TagModel tag) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;
    int now = DateTime.now().millisecondsSinceEpoch;

    result = await db.rawQuery(
        "SELECT t.* FROM Tasks t INNER JOIN Goals_Tasks gt ON gt.task_id = t.id WHERE type=0 and goal_id=${goal.id} and deadLine>$now ORDER BY deadLine ASC");

    List<TaskModel> tasks = result.isNotEmpty
        ? result.map((item) => TaskModel.fromMap(item)).toList()
        : [];
    return tasks;
  }

  @override
  Future<List<TaskModel>> getTasksOfGoalOfTag(
      GoalModel goal, TagModel tag) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;

    result = await db.rawQuery(
        "SELECT t.* FROM Tasks t INNER JOIN Goals_Tasks gt ON gt.task_id = t.id INNER JOIN Tasks_Tags ts ON ts.task_id = t.id WHERE tag_id=${tag.id} and goal_id=${goal.id}");

    List<TaskModel> tasks = result.isNotEmpty
        ? result.map((item) => TaskModel.fromMap(item)).toList()
        : [];
    return tasks;
  }

  @override
  Future<List<TextboxModel>> getTextboxesOfGoal(GoalModel goal) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;

    result = await db.rawQuery(
        "SELECT t.* FROM Textboxes t INNER JOIN ${goal.getTableLinktextbox()} gt ON gt.textbox_id = t.id WHERE goal_id=${goal.id}");

    List<TextboxModel> items = result.isNotEmpty
        ? result.map((item) => TextboxModel.fromMap(item)).toList()
        : [];
    return items;
  }

  @override
  Future<void> updateGoal(GoalModel goal) async {
    final db = await nativeDb.database;
    if ((await db.query(goal.getTable(), where: "id= ?", whereArgs: [goal.id]))
            .length >
        0) {
      await db.update(goal.getTable(), goal.toMap(),
          where: "id = ?", whereArgs: [goal.id]);
      print("goal Updated");
    }
  }

  @override
  Future<int> removeLinkAttachmentFromGoal(GoalModel goal, AttachmentModel attachment) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result = await db.query(
        goal.getTableLinkAttachment(),
        columns: ['id'],
        where: "goal_id = ? and attachment_id=?",
        whereArgs: [goal.id, attachment.id]);
    int id = 0;
    if (result.length > 0) {
      id = result[0]['id'];
      db.delete(goal.getTableLinkAttachment(),
          where: "goal_id=? and attachment_id=?", whereArgs: [goal.id, attachment.id]);
    }
    return id;
  }

  @override
  Future<int> removeLinkLinkFromGoal(GoalModel goal, LinkModel link) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result = await db.query(goal.getTableLinkLinks(),
        where: "goal_id=? and link_id=?",
        columns: ['id'],
        whereArgs: [goal.id, link.id]);
    int id = 0;
    if (result.length > 0) {
      id = result[0]['id'];
      db.delete(goal.getTableLinkLinks(),
          where: "goal_id=? and link_id=?", whereArgs: [goal.id, link.id]);
    }
    return id;
  }

  @override
  Future<int> removeLinkLogFromGoal(GoalModel goal, LogModel log) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result = await db.query(goal.getTableLinkLogs(),
        where: "goal_id=? and log_id=?",
        columns: ['id'],
        whereArgs: [goal.id, log.id]);
    int id = 0;
    if (result.length > 0) {
      id = result[0]['id'];
      db.delete(goal.getTableLinkLogs(),
          where: "goal_id=? and log_id=?", whereArgs: [goal.id, log.id]);
    }
    return id;
  }

  @override
  Future<int> removeLinkTagFromGoal(GoalModel goal, TagModel tag) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result = await db.query(goal.getTableLinkTags(),
        columns: ['id'],
        where: "goal_id=? and tag_id=?",
        whereArgs: [goal.id, tag.id]);
    int id = 0;
    if (result.length > 0) {
      id = result[0]['id'];
      db.delete(goal.getTableLinkTags(),
          where: "goal_id=? and tag_id=?", whereArgs: [goal.id, tag.id]);
    }
    return id;
  }

  @override
  Future<int> removeLinkTaskFromGoal(GoalModel goal, TaskModel task) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result = await db.query(goal.getTableLinkTasks(),
        where: "goal_id=? and task_id=?",
        whereArgs: [goal.id, task.id],
        columns: ['id']);
    int id = 0;
    if (result.length > 0) {
      id = result[0]['id'];
      db.delete(goal.getTableLinkTasks(),
          where: "goal_id=? and task_id=?", whereArgs: [goal.id, task.id]);
    }
    return id;
  }

  @override
  Future<int> removeLinkTextboxFromGoal(
      GoalModel goal, TextboxModel textbox) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result = await db.query(
        goal.getTableLinktextbox(),
        where: "goal_id=? and textbox_id=?",
        whereArgs: [goal.id, textbox.id],
        columns: ['id']);
    int id = 0;
    if (result.length > 0) {
      id = result[0]['id'];
      db.delete(goal.getTableLinktextbox(),
          where: "goal_id=? and textbox_id=?",
          whereArgs: [goal.id, textbox.id]);
    }
    return id;
  }

  @override
  Future<int> removeLinkImageFromGoal(GoalModel goal, ImageModel image) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result = await db.query(
        goal.getTableLinkImages(),
        where: "goal_id=? and image_id=?",
        whereArgs: [goal.id, image.id],
        columns: ['id']);
    int id = 0;
    if (result.length > 0) {
      id = result[0]['id'];
      db.delete(goal.getTableLinkImages(),
          where: "goal_id=? and image_id=?", whereArgs: [goal.id, image.id]);
    }
    return id;
  }

  @override
  Future<List<LogModel>> getLogsOfGoal(GoalModel goal) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;

    result = await db.rawQuery(
        "SELECT t.* FROM Tags t INNER JOIN ${goal.getTableLinkLogs()} gt ON gt.log_id = t.id WHERE goal_id=${goal.id}");

    List<LogModel> items = result.isNotEmpty
        ? result.map((item) => LogModel.fromMap(item)).toList()
        : [];
    return items;
  }

  @override
  Future<List<GoalModel>> getAllGoals() async {
    final db = await nativeDb.database;
    GoalModel goal = new GoalModel();
    List<Map<String, dynamic>> result;

    result = await db.query(goal.getTable(), orderBy: "savedTs DESC");
    List<GoalModel> items = result.isNotEmpty
        ? result.map((item) => GoalModel.fromMap(item)).toList()
        : [];
    return items;
  }
}
