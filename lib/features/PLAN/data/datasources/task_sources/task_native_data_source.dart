import 'dart:math';

import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/database/sqflite_init.dart';
import 'package:sorted/core/global/models/image.dart';
import 'package:sorted/core/global/database/sqflite_init.dart';
import 'package:sorted/core/global/models/attachment.dart';
import 'package:sorted/core/global/models/image.dart';
import 'package:sorted/core/global/models/link.dart';
import 'package:sorted/core/global/models/log.dart';
import 'package:sorted/core/global/models/review.dart';
import 'package:sorted/core/global/models/tag.dart';
import 'package:sorted/features/PLAN/data/models/goal.dart';

import 'package:sorted/features/PLAN/data/models/task.dart';
import 'package:sorted/features/PLAN/data/models/task_status.dart';
import 'package:sorted/features/PLAN/data/models/todo.dart';
import 'package:sorted/features/PROFILE/data/models/user_activity.dart';

abstract class TaskNative {
  Future<void> addTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteGoal(TaskModel task);
  Future<void> addStatus(TaskStatusModel status);
  Future<void> updateStatus(TaskStatusModel status);
  Future<void> deleteStatus(TaskStatusModel status);

  Future<void> addLinkImageToTask(TaskModel task, ImageModel image, int id);
  Future<int> removeLinkImageFromTask(TaskModel task, ImageModel image);
  Future<void> addLinkTagToTask(TaskModel task, TagModel tag, int id);
  Future<int> removeLinkTagFromTask(TaskModel task, TagModel tag);
  Future<void> addLinkLogToTask(TaskModel task, LogModel log, int id);
  Future<int> removeLinkLogFromTask(TaskModel task, LogModel log);

  Future<void> addLinkLinkToTask(TaskModel task, LinkModel link, int id);
  Future<int> removeLinkLinkFromTask(TaskModel task, LinkModel link);
  Future<void> addLinkAttachmentToTask(
      TaskModel task, AttachmentModel attachment, int id);
  Future<int> removeLinkAttachmentFromTask(
      TaskModel task, AttachmentModel attachment);
  Future<void> addLinkTaskToReview(TaskModel task, ReviewModel review, int id);
  Future<int> removeLinkReviewFromTask(TaskModel task, ReviewModel review);
  Future<void> addLinkTaskToTodo(TaskModel task, TodoModel todo, int id);
  Future<int> removeLinkTodoFromTask(TaskModel task, TodoModel todo);
  Future<void> addLinkTaskToActivity(
      TaskModel task, UserAModel activity, int id);
  Future<int> removeLinkActivityFromTask(TaskModel task, UserAModel activity);
  Future<void> addLinkTaskToStatus(
      TaskModel task, TaskStatusModel status, int id);
  Future<int> removeLinkStatusFromTask(TaskModel task, TaskStatusModel status);
  Future<void> addLinkDependencyToTask(
      TaskModel dependency, TaskModel task, int id);
  Future<int> removeLinkDependencyFromTask(
      TaskModel dependency, TaskModel task);
  Future<void> removeAllStatusFromTask(TaskModel task);

  Future<GoalModel> getGoalOfTask(TaskModel task);
  Future<List<TaskModel>> getDependenciesOfTask(TaskModel task);
  Future<List<ImageModel>> getImagesOfTask(TaskModel task);
  Future<List<LinkModel>> getLinksOfTask(TaskModel task);
  Future<List<LogModel>> getLogsOfTask(TaskModel task);
  Future<List<UserAModel>> getActivitiesOfTask(TaskModel task);
  Future<List<ReviewModel>> getReviewsOfTask(TaskModel task);
  Future<List<TodoModel>> getTodosOfTask(TaskModel task);
  Future<List<TagModel>> getTagsOfTask(TaskModel task);
  Future<TaskStatusModel> getStatusOfTask(TaskModel task);
  Future<ImageModel> getCoverImageOfTask(TaskModel task);
  Future<ImageModel> getMainImageOfTask(TaskModel task);
  Future<List<TaskModel>> getTasksOfStatus(TaskStatusModel status);
  Future<List<TaskModel>> getTasksOfTag(TagModel task);
  Future<List<TaskModel>> getUpcomingTasks();
  Future<TaskStatusModel> getStatusByName(String name);
  Future<TaskStatusModel> getStatusById(int id);

  Future<List<TaskStatusModel>> getAllStatus();
}

class TaskNativeDataSourceImpl implements TaskNative {
  final SqlDatabaseService nativeDb;

  TaskNativeDataSourceImpl({@required this.nativeDb});

  @override
  Future<void> addLinkAttachmentToTask(
      TaskModel task, AttachmentModel attachment, int id) async {
    final db = await nativeDb.database;
    if ((await db.query(task.getAttachmentTable(),
                where: "task_id=? and attachment_id=?",
                whereArgs: [task.id, attachment.id]))
            .length ==
        0)
      await db.insert(task.getAttachmentTable(), {
        "task_id": task.id,
        "attachment_id": attachment.id,
        "savedTs": DateTime.now().millisecondsSinceEpoch,
        "id": id
      });
  }

  @override
  Future<void> addLinkDependencyToTask(
      TaskModel dependency, TaskModel task, int id) async {
    final db = await nativeDb.database;
    if ((await db.query(task.getDependencyTable(),
                where: "task_id=? and dependency_id=?",
                whereArgs: [task.id, dependency.id]))
            .length ==
        0)
      await db.insert(task.getDependencyTable(), {
        "task_id": task.id,
        "dependency_id": dependency.id,
        "savedTs": DateTime.now().millisecondsSinceEpoch,
        "id": id
      });
  }

  @override
  Future<void> addLinkImageToTask(
      TaskModel task, ImageModel image, int id) async {
    final db = await nativeDb.database;
    if ((await db.query(task.getImageTable(),
                where: "task_id=? and image_id=?",
                whereArgs: [task.id, image.id]))
            .length ==
        0)
      await db.insert(task.getImageTable(), {
        "task_id": task.id,
        "image_id": image.id,
        "savedTs": DateTime.now().millisecondsSinceEpoch,
        "id": id
      });
  }

  @override
  Future<void> addLinkLinkToTask(TaskModel task, LinkModel link, int id) async {
    final db = await nativeDb.database;
    if ((await db.query(task.getLinkTable(),
                where: "task_id=? and link_id=?",
                whereArgs: [task.id, link.id]))
            .length ==
        0)
      await db.insert(task.getLinkTable(), {
        "task_id": task.id,
        "link_id": link.id,
        "savedTs": DateTime.now().millisecondsSinceEpoch,
        "id": id
      });
  }

  @override
  Future<void> addLinkLogToTask(TaskModel task, LogModel log, int id) async {
    DateTime now = DateTime.now();

    final db = await nativeDb.database;
    if ((await db.query(task.getLogTable(),
                where: "task_id=? and log_id=?", whereArgs: [task.id, log.id]))
            .length ==
        0)
      await db.insert(task.getLogTable(), {
        "task_id": task.id,
        "log_id": log.id,
        "savedTs": now.millisecondsSinceEpoch,
        "id": id
      });
  }

  @override
  Future<void> addLinkTagToTask(TaskModel task, TagModel tag, int id) async {
    final db = await nativeDb.database;
    if ((await db.query(task.getTagTable(),
                where: "task_id=? and tag_id=?", whereArgs: [task.id, tag.id]))
            .length ==
        0)
      await db.insert(task.getTagTable(), {
        "task_id": task.id,
        "tag_id": tag.id,
        "savedTs": DateTime.now().millisecondsSinceEpoch,
        "id": id
      });
  }

  @override
  Future<void> addLinkTaskToActivity(
      TaskModel task, UserAModel activity, int id) async {
    final db = await nativeDb.database;
    if ((await db.query(task.getActivityTable(),
                where: "task_id=? and activity_id=?",
                whereArgs: [task.id, activity.id]))
            .length ==
        0)
      await db.insert(task.getActivityTable(), {
        "task_id": task.id,
        "activity_id": activity.id,
        "savedTs": DateTime.now().millisecondsSinceEpoch,
        "id": id
      });
  }

  @override
  Future<void> addLinkTaskToReview(
      TaskModel task, ReviewModel review, int id) async {
    final db = await nativeDb.database;
    if ((await db.query(task.getReviewTable(),
                where: "task_id=? and review_id=?",
                whereArgs: [task.id, review.id]))
            .length ==
        0)
      await db.insert(task.getReviewTable(), {
        "task_id": task.id,
        "review_id": review.id,
        "savedTs": DateTime.now().millisecondsSinceEpoch,
        "id": id
      });
  }

  @override
  Future<void> addLinkTaskToStatus(
      TaskModel task, TaskStatusModel status, int id) async {
    final db = await nativeDb.database;
    if ((await db.query(task.getStatusTable(),
                where: "task_id=? and status_id=?",
                whereArgs: [task.id, status.id]))
            .length ==
        0)
      await db.insert(task.getStatusTable(), {
        "task_id": task.id,
        "status_id": status.id,
        "savedTs": DateTime.now().millisecondsSinceEpoch,
        "id": id
      });
  }

  @override
  Future<void> addLinkTaskToTodo(TaskModel task, TodoModel todo, int id) async {
    final db = await nativeDb.database;
    if ((await db.query(task.getTodoTable(),
                where: "task_id=? and todo_id=?",
                whereArgs: [task.id, todo.id]))
            .length ==
        0)
      await db.insert(task.getTodoTable(), {
        "task_id": task.id,
        "todo_id": todo.id,
        "savedTs": DateTime.now().millisecondsSinceEpoch,
        "id": id
      });
  }

  @override
  Future<void> addStatus(TaskStatusModel status) async {
    DateTime now = DateTime.now();
    status = status.copyWith(savedTs: now);
    final db = await nativeDb.database;
    if ((await db.query(status.getTable(),
                where: "id= ?", whereArgs: [status.id]))
            .length ==
        0)
      await db.insert(status.getTable(), status.toMap());
    else
      await db.update(status.getTable(), status.toMap(),
          where: "id = ?", whereArgs: [status.id]);
  }

  @override
  Future<void> addTask(TaskModel task) async {
    DateTime now = DateTime.now();
    task = task.copyWith(savedTs: now);
    final db = await nativeDb.database;
    if ((await db.query(task.getTable(), where: "id= ?", whereArgs: [task.id]))
            .length ==
        0)
      await db.insert(task.getTable(), task.toMap());
    else
      await db.update(task.getTable(), task.toMap(),
          where: "id = ?", whereArgs: [task.id]);
  }

  @override
  Future<void> deleteGoal(TaskModel task) async {
    final db = await nativeDb.database;
    if ((await db.query(task.getTable(), where: "id=?", whereArgs: [task.id]))
            .length >
        0) db.delete(task.getTable(), where: "id=?", whereArgs: [task.id]);
  }

  @override
  Future<void> deleteStatus(TaskStatusModel status) async {
    final db = await nativeDb.database;
    if ((await db.query(status.getTable(),
                where: "id=?", whereArgs: [status.id]))
            .length >
        0) db.delete(status.getTable(), where: "id=?", whereArgs: [status.id]);
  }

  @override
  Future<List<UserAModel>> getActivitiesOfTask(TaskModel task) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;

    result = await db.rawQuery(
        "SELECT t.* FROM User_Activity t INNER JOIN ${task.getActivityTable()} gt ON gt.activity_id = t.id WHERE task_id=${task.id}");

    List<UserAModel> items = result.isNotEmpty
        ? result.map((item) => UserAModel.fromMap(item)).toList()
        : [];
    return items;
  }

  @override
  Future<ImageModel> getCoverImageOfTask(TaskModel task) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;

    result =
        await db.query("Images", where: "id=?", whereArgs: [task.coverImageid]);
    List<ImageModel> items = result.isNotEmpty
        ? result.map((item) => ImageModel.fromMap(item)).toList()
        : [];
    return items[0];
  }

  @override
  Future<List<TaskModel>> getDependenciesOfTask(TaskModel task) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;

    result = await db.rawQuery(
        "SELECT t.* FROM Tasks t INNER JOIN ${task.getDependencyTable()} gt ON gt.dependency_id = t.id WHERE task_id=${task.id}");

    List<TaskModel> items = result.isNotEmpty
        ? result.map((item) => TaskModel.fromMap(item)).toList()
        : [];
    return items;
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
  Future<List<ImageModel>> getImagesOfTask(TaskModel task) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;

    result = await db.rawQuery(
        "SELECT t.* FROM Images t INNER JOIN ${task.getImageTable()} gt ON gt.image_id = t.id WHERE task_id=${task.id}");

    List<ImageModel> items = result.isNotEmpty
        ? result.map((item) => ImageModel.fromMap(item)).toList()
        : [];
    return items;
  }

  @override
  Future<List<LinkModel>> getLinksOfTask(TaskModel task) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;

    result = await db.rawQuery(
        "SELECT t.* FROM Links t INNER JOIN ${task.getLinkTable()} gt ON gt.link_id = t.id WHERE task_id=${task.id}");

    List<LinkModel> items = result.isNotEmpty
        ? result.map((item) => LinkModel.fromMap(item)).toList()
        : [];
    return items;
  }

  @override
  Future<List<LogModel>> getLogsOfTask(TaskModel task) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;

    result = await db.rawQuery(
        "SELECT t.* FROM Logs t INNER JOIN ${task.getLogTable()} gt ON gt.log_id = t.id WHERE task_id=${task.id}");

    List<LogModel> items = result.isNotEmpty
        ? result.map((item) => LogModel.fromMap(item)).toList()
        : [];
    return items;
  }

  @override
  Future<ImageModel> getMainImageOfTask(TaskModel task) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;

    result =
        await db.query("Images", where: "id=?", whereArgs: [task.taskImageId]);
    List<ImageModel> items = result.isNotEmpty
        ? result.map((item) => ImageModel.fromMap(item)).toList()
        : [];
    return items[0];
  }

  @override
  Future<List<ReviewModel>> getReviewsOfTask(TaskModel task) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;

    result = await db.rawQuery(
        "SELECT t.* FROM Reviews t INNER JOIN ${task.getReviewTable()} gt ON gt.review_id = t.id WHERE task_id=${task.id}");

    List<ReviewModel> items = result.isNotEmpty
        ? result.map((item) => ReviewModel.fromMap(item)).toList()
        : [];
    return items;
  }

  @override
  Future<TaskStatusModel> getStatusOfTask(TaskModel task) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;

    result = await db.rawQuery(
        "SELECT t.* FROM TaskStatus t INNER JOIN ${task.getStatusTable()} gt ON gt.status_id = t.id WHERE task_id=${task.id}");

    List<TaskStatusModel> items = result.isNotEmpty
        ? result.map((item) => TaskStatusModel.fromMap(item)).toList()
        : [];
    return items[0];
  }

  @override
  Future<List<TodoModel>> getTodosOfTask(TaskModel task) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;

    result = await db.rawQuery(
        "SELECT t.* FROM Todos t INNER JOIN ${task.getTodoTable()} gt ON gt.todo_id = t.id WHERE task_id=${task.id}");

    List<TodoModel> items = result.isNotEmpty
        ? result.map((item) => TodoModel.fromMap(item)).toList()
        : [];
    return items;
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    final db = await nativeDb.database;
    print(task.taskImageId);
    if ((await db.query(task.getTable(), where: "id= ?", whereArgs: [task.id]))
            .length >
        0)
      await db.update(task.getTable(), task.toMap(),
          where: "id = ?", whereArgs: [task.id]);
    print("updated");
    return;
  }

  @override
  Future<void> updateStatus(TaskStatusModel status) async {
    final db = await nativeDb.database;
    if ((await db.query(status.getTable(),
                where: "id= ?", whereArgs: [status.id]))
            .length >
        0)
      await db.update(status.getTable(), status.toMap(),
          where: "id = ?", whereArgs: [status.id]);
  }

  @override
  Future<int> removeLinkActivityFromTask(
      TaskModel task, UserAModel activity) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result = await db.query(task.getActivityTable(),
        where: "task_id=? and activity_id=?",
        whereArgs: [task.id, activity.id],
        columns: ['id']);
    int id = 0;
    if (result.length > 0) {
      id = result[0]['id'];
      db.delete(task.getActivityTable(),
          where: "task_id=? and activity_id=?",
          whereArgs: [task.id, activity.id]);
    }
    return id;
  }

  @override
  Future<int> removeLinkAttachmentFromTask(
      TaskModel task, AttachmentModel attachment) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result = await db.query(
        task.getAttachmentTable(),
        where: "task_id=? and attachment_id=?",
        whereArgs: [task.id, attachment.id],
        columns: ['id']);
    int id = 0;
    if (result.length > 0) {
      id = result[0]['id'];
      db.delete(task.getAttachmentTable(),
          where: "task_id=? and attachment_id=?",
          whereArgs: [task.id, attachment.id]);
    }
    return id;
  }

  @override
  Future<int> removeLinkDependencyFromTask(
      TaskModel dependency, TaskModel task) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result = await db.query(
        task.getDependencyTable(),
        where: "task_id=? and dependency_id=?",
        whereArgs: [task.id, dependency.id],
        columns: ['id']);
    int id = 0;
    if (result.length > 0) {
      id = result[0]['id'];
      db.delete(task.getDependencyTable(),
          where: "task_id=? and dependency_id=?",
          whereArgs: [task.id, dependency.id]);
    }
    return id;
  }

  @override
  Future<int> removeLinkImageFromTask(TaskModel task, ImageModel image) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result = await db.query(task.getImageTable(),
        where: "task_id=? and image_id=?",
        whereArgs: [task.id, image.id],
        columns: ['id']);
    int id = 0;
    if (result.length > 0) {
      id = result[0]['id'];
      db.delete(task.getImageTable(),
          where: "task_id=? and image_id=?", whereArgs: [task.id, image.id]);
    }
    return id;
  }

  @override
  Future<int> removeLinkLinkFromTask(TaskModel task, LinkModel link) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result = await db.query(task.getLinkTable(),
        where: "task_id=? and link_id=?",
        whereArgs: [task.id, link.id],
        columns: ['id']);
    int id = 0;
    if (result.length > 0) {
      id = result[0]['id'];
      db.delete(task.getLinkTable(),
          where: "task_id=? and link_id=?", whereArgs: [task.id, link.id]);
    }
    return id;
  }

  @override
  Future<int> removeLinkLogFromTask(TaskModel task, LogModel log) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result = await db.query(task.getLogTable(),
        where: "task_id=? and log_id=?",
        whereArgs: [task.id, log.id],
        columns: ['id']);
    int id = 0;
    if (result.length > 0) {
      id = result[0]['id'];
      db.delete(task.getLogTable(),
          where: "task_id=? and log_id=?", whereArgs: [task.id, log.id]);
    }
    return id;
  }

  @override
  Future<int> removeLinkReviewFromTask(
      TaskModel task, ReviewModel review) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result = await db.query(task.getReviewTable(),
        where: "task_id=? and review_id=?",
        whereArgs: [task.id, review.id],
        columns: ['id']);
    int id = 0;
    if (result.length > 0) {
      id = result[0]['id'];
      db.delete(task.getReviewTable(),
          where: "task_id=? and review_id=?", whereArgs: [task.id, review.id]);
    }
    return id;
  }

  @override
  Future<int> removeLinkStatusFromTask(
      TaskModel task, TaskStatusModel status) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result = await db.query(task.getStatusTable(),
        where: "task_id=? and status_id=?",
        whereArgs: [task.id, status.id],
        columns: ['id']);
    int id = 0;
    if (result.length > 0) {
      id = result[0]['id'];
      db.delete(task.getStatusTable(),
          where: "task_id=? and status_id=?", whereArgs: [task.id, status.id]);
    }
    return id;
  }

  @override
  Future<int> removeLinkTagFromTask(TaskModel task, TagModel tag) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result = await db.query(task.getTagTable(),
        where: "task_id=? and tag_id=?",
        whereArgs: [task.id, tag.id],
        columns: ['id']);
    int id = 0;
    if (result.length > 0) {
      id = result[0]['id'];
      db.delete(task.getTagTable(),
          where: "task_id=? and tag_id=?", whereArgs: [task.id, tag.id]);
    }
    return id;
  }

  @override
  Future<int> removeLinkTodoFromTask(TaskModel task, TodoModel todo) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result = await db.query(task.getTodoTable(),
        where: "task_id=? and todo_id=?",
        whereArgs: [task.id, todo.id],
        columns: ['id']);
    int id = 0;
    if (result.length > 0) {
      id = result[0]['id'];
      db.delete(task.getTodoTable(),
          where: "task_id=? and todo_id=?", whereArgs: [task.id, todo.id]);
    }
    return id;
  }

  @override
  Future<List<TaskStatusModel>> getAllStatus() async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;

    result = await db.query("TaskStatus");
    List<TaskStatusModel> items = result.isNotEmpty
        ? result.map((item) => TaskStatusModel.fromMap(item)).toList()
        : [];
    return items;
  }

  @override
  Future<void> removeAllStatusFromTask(TaskModel task) async {
    final db = await nativeDb.database;
    db.delete(task.getStatusTable(), where: "task_id=?", whereArgs: [task.id]);
  }

  @override
  Future<TaskStatusModel> getStatusByName(String name) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;
    TaskStatusModel t = new TaskStatusModel();

    result = await db.query(t.getTable(), where: "status=?", whereArgs: [name]);
    List<TaskStatusModel> status = result.isNotEmpty
        ? result.map((item) => TaskStatusModel.fromMap(item)).toList()
        : [TaskStatusModel(status: "None")];
    return status[0];
  }

  @override
  Future<List<TaskModel>> getTasksOfStatus(TaskStatusModel status) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;
    TaskStatusModel t = new TaskStatusModel();
    TaskModel task = new TaskModel();
    result = await db.query(task.getTable(),
        where: "linkedStatus=?",
        whereArgs: [status.id],
        orderBy: "savedTs DESC");

    // result = await db.rawQuery(
    //     "SELECT t.* FROM Tasks t INNER JOIN ${task.getStatusTable()} gt ON gt.task_id = t.id WHERE status_id=${status.id}");

    List<TaskModel> items = result.isNotEmpty
        ? result.map((item) => TaskModel.fromMap(item)).toList()
        : [];
    return items;
  }

  @override
  Future<List<TaskModel>> getTasksOfTag(TagModel tag) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;
    TaskStatusModel t = new TaskStatusModel();
    TaskModel task = new TaskModel();

    result = await db.rawQuery(
        "SELECT t.* FROM Tasks t INNER JOIN ${task.getTagTable()} gt ON gt.task_id = t.id WHERE tag_id=${tag.id}");

    List<TaskModel> items = result.isNotEmpty
        ? result.map((item) => TaskModel.fromMap(item)).toList()
        : [];
    return items;
  }

  @override
  Future<TaskStatusModel> getStatusById(int id) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;
    TaskStatusModel t = new TaskStatusModel();

    result = await db.query(t.getTable(), where: "id=?", whereArgs: [id]);
    List<TaskStatusModel> status = result.isNotEmpty
        ? result.map((item) => TaskStatusModel.fromMap(item)).toList()
        : [TaskStatusModel(status: "None")];
    return status[0];
  }

  @override
  Future<List<TaskModel>> getUpcomingTasks() async {
    final db = await nativeDb.database;
    DateTime now = DateTime.now().subtract(Duration(days: 1));
    DateTime nextFiveDays = now.add(Duration(days: 5));
    List<Map<String, dynamic>> result;
    TaskStatusModel t = new TaskStatusModel();
    TaskModel task = new TaskModel();
    result = await db.query(task.getTable(),
        where: "deadLine > ? and deadline < ? ",
        whereArgs: [
          now.millisecondsSinceEpoch,
          nextFiveDays.millisecondsSinceEpoch
        ],
        limit: 10,
        orderBy: "deadline ASC");

    // result = await db.rawQuery(
    //     "SELECT t.* FROM Tasks t INNER JOIN ${task.getStatusTable()} gt ON gt.task_id = t.id WHERE status_id=${status.id}");

    List<TaskModel> items = result.isNotEmpty
        ? result.map((item) => TaskModel.fromMap(item)).toList()
        : [];
    return items;
  }

  @override
  Future<List<TagModel>> getTagsOfTask(TaskModel task) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;

    result = await db.rawQuery(
        "SELECT t.* FROM Tags t INNER JOIN ${task.getTagTable()} gt ON gt.tag_id = t.id WHERE task_id=${task.id}");

    List<TagModel> items = result.isNotEmpty
        ? result.map((item) => TagModel.fromMap(item)).toList()
        : [];
    return items;
  }
}
