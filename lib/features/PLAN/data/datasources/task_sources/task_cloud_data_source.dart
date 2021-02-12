import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:meta/meta.dart';

import 'package:sorted/core/global/database/sqflite_init.dart';
import 'package:sorted/core/global/models/attachment.dart';
import 'package:sorted/core/global/models/image.dart';
import 'package:sorted/core/global/models/link.dart';
import 'package:sorted/core/global/models/log.dart';
import 'package:sorted/core/global/models/review.dart';
import 'package:sorted/core/global/models/tag.dart';
import 'package:sorted/core/global/models/textbox.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/data/models/inspiration.dart';
import 'package:sorted/features/HOME/data/models/placeholder_info.dart';
import 'package:sorted/features/PLAN/data/models/task.dart';
import 'package:sorted/features/PLAN/data/models/task_status.dart';
import 'package:sorted/features/PLAN/data/models/todo.dart';
import 'package:sorted/features/PROFILE/data/models/user_activity.dart';
import 'package:sqflite/sqflite.dart';

abstract class TaskCloud {
  Future<void> addTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteGoal(TaskModel task);
  Future<void> addStatus(TaskStatusModel status);
  Future<void> updateStatus(TaskStatusModel status);
  Future<void> deleteStatus(TaskStatusModel status);

  Future<void> addLinkImageToTask(TaskModel task, ImageModel image, int id);
  Future<void> removeLinkImageFromTask(int id);
  Future<void> addLinkTagToTask(TaskModel task, TagModel tag, int id);
  Future<void> removeLinkTagFromTask(int id);
  Future<void> addLinkLogToTask(TaskModel task, LogModel log, int id);
  Future<void> removeLinkLogFromTask(int id);

  Future<void> addLinkLinkToTask(TaskModel task, LinkModel link, int id);
  Future<void> removeLinkLinkFromTask(int id);
  Future<void> addLinkAttachmentToTask(
      TaskModel task, AttachmentModel attachment, int id);
  Future<void> removeLinkAttachmentFromTask(int id);
  Future<void> addLinkTaskToReview(TaskModel task, ReviewModel review, int id);
  Future<void> removeLinkReviewFromTask(int id);
  Future<void> addLinkTaskToTodo(TaskModel task, TodoModel todo, int id);
  Future<void> removeLinkTodoFromTask(int id);
  Future<void> addLinkTaskToActivity(
      TaskModel task, UserAModel activity, int id);
  Future<void> removeLinkActivityFromTask(int id);
  Future<void> addLinkTaskToStatus(
      TaskModel task, TaskStatusModel status, int id);
  Future<void> removeLinkStatusFromTask(int id);
  Future<void> addLinkDependencyToTask(
      TaskModel dependency, TaskModel task, int id);
  Future<void> removeLinkDependencyFromTask(int id);
}

class TaskCloudDataSourceImpl implements TaskCloud {
  final FirebaseFirestore cloudDb;
  final FirebaseAuth auth;
  final SqlDatabaseService nativeDb;
  Batch batch;

  TaskCloudDataSourceImpl(
      {@required this.cloudDb, @required this.auth, @required this.nativeDb});

  @override
  Future<void> addStatus(TaskStatusModel status) async {
    User user = auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(status.getTable())
        .doc(status.id.toString());

    ref
        .set(status.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> addTask(TaskModel task) async {
    User user = auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(task.getTable())
        .doc(task.id.toString());

    ref
        .set(task.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> deleteGoal(TaskModel task) async {
    User user = auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(task.getTable())
        .doc(task.id.toString());

    ref
        .delete()
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> deleteStatus(TaskStatusModel status) async {
    User user = auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(status.getTable())
        .doc(status.id.toString());

    ref
        .delete()
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    User user = auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(task.getTable())
        .doc(task.id.toString());

    ref
        .update(task.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> updateStatus(TaskStatusModel status) async {
    User user = auth.currentUser;
    DocumentReference ref;
    cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(status.getTable())
        .where("id", isEqualTo: status.id)
        .limit(1)
        .get()
        .then((value) {
      ref = value.docs[0].reference;
      ref
          .update(status.toMap())
          .catchError((onError) => {print("nhi chala\n"), print("hello")});
    });
  }

  @override
  Future<void> addLinkAttachmentToTask(
      TaskModel task, AttachmentModel attachment, int id) async {
    User user = auth.currentUser;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(task.getAttachmentTable())
        .doc(id.toString());

    ref.set({
      "id": id,
      "task_id": task.id,
      "attachment_id": attachment.id,
      "savedTs": DateTime.now().millisecondsSinceEpoch
    }).then((value) => print(ref.id));
  }

  @override
  Future<void> addLinkDependencyToTask(
      TaskModel dependency, TaskModel task, int id) async {
    User user = auth.currentUser;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(task.getDependencyTable())
        .doc(id.toString());

    ref.set({
      "id": id,
      "task_id": task.id,
      "dependency_id": dependency.id,
      "savedTs": DateTime.now().millisecondsSinceEpoch
    });
  }

  @override
  Future<void> addLinkImageToTask(
      TaskModel task, ImageModel image, int id) async {
    User user = auth.currentUser;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(task.getImageTable())
        .doc(id.toString());

    ref.set({
      "id": id,
      "task_id": task.id,
      "image_id": image.id,
      "savedTs": DateTime.now().millisecondsSinceEpoch
    });
  }

  @override
  Future<void> addLinkLinkToTask(TaskModel task, LinkModel link, int id) async {
    User user = auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(task.getLinkTable())
        .doc(id.toString());

    ref.set({
      "id": id,
      "task_id": task.id,
      "link_id": link.id,
      "savedTs": DateTime.now().millisecondsSinceEpoch
    });
  }

  @override
  Future<void> addLinkLogToTask(TaskModel task, LogModel log, int id) async {
    User user = auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(task.getLogTable())
        .doc(id.toString());

    ref.set({
      "id": id,
      "task_id": task.id,
      "log_id": log.id,
      "savedTs": DateTime.now().millisecondsSinceEpoch
    });
  }

  @override
  Future<void> addLinkTagToTask(TaskModel task, TagModel tag, int id) async {
    User user = auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(task.getTagTable())
        .doc(id.toString());

    ref.set({
      "id": id,
      "task_id": task.id,
      "tag_id": tag.id,
      "savedTs": DateTime.now().millisecondsSinceEpoch
    });
  }

  @override
  Future<void> addLinkTaskToActivity(
      TaskModel task, UserAModel activity, int id) async {
    User user = auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(task.getActivityTable())
        .doc(id.toString());

    ref.set({
      "id": id,
      "task_id": task.id,
      "activity_id": activity.id,
      "savedTs": DateTime.now().millisecondsSinceEpoch
    }).then((value) => print(ref.id));
  }

  @override
  Future<void> addLinkTaskToReview(
      TaskModel task, ReviewModel review, int id) async {
    User user = auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(task.getReviewTable())
        .doc(id.toString());

    ref.set({
      "id": id,
      "task_id": task.id,
      "review_id": review.id,
      "savedTs": DateTime.now().millisecondsSinceEpoch
    }).then((value) => print(ref.id));
  }

  @override
  Future<void> addLinkTaskToStatus(
      TaskModel task, TaskStatusModel status, int id) async {
    User user = auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(task.getStatusTable())
        .doc(id.toString());

    ref.set({
      "id": id,
      "task_id": task.id,
      "status_id": status.id,
      "savedTs": DateTime.now().millisecondsSinceEpoch
    }).then((value) => print(ref.id));
  }

  @override
  Future<void> addLinkTaskToTodo(TaskModel task, TodoModel todo, int id) async {
    User user = auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(task.getTodoTable())
        .doc(id.toString());

    ref.set({
      "id": id,
      "task_id": task.id,
      "todo_id": todo.id,
      "savedTs": DateTime.now().millisecondsSinceEpoch
    }).then((value) => print(ref.id));
  }

  @override
  Future<void> removeLinkActivityFromTask(int id) async {
    User user = auth.currentUser;
    TaskModel task;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(task.getActivityTable())
        .doc(id.toString());

    ref.delete();
  }

  @override
  Future<void> removeLinkAttachmentFromTask(int id) async {
    User user = auth.currentUser;
    TaskModel task;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(task.getAttachmentTable())
        .doc(id.toString());

    ref.delete();
  }

  @override
  Future<void> removeLinkDependencyFromTask(int id) async {
    User user = auth.currentUser;
    TaskModel task;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(task.getDependencyTable())
        .doc(id.toString());

    ref.delete();
  }

  @override
  Future<void> removeLinkImageFromTask(int id) async {
    User user = auth.currentUser;
    TaskModel task;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(task.getImageTable())
        .doc(id.toString());

    ref.delete();
  }

  @override
  Future<void> removeLinkLinkFromTask(int id) async {
    User user = auth.currentUser;
    TaskModel task;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(task.getLinkTable())
        .doc(id.toString());

    ref.delete();
  }

  @override
  Future<void> removeLinkLogFromTask(int id) async {
    User user = auth.currentUser;
    TaskModel task;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(task.getLogTable())
        .doc(id.toString());

    ref.delete();
  }

  @override
  Future<void> removeLinkReviewFromTask(int id) async {
    User user = auth.currentUser;
    TaskModel task;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(task.getReviewTable())
        .doc(id.toString());

    ref.delete();
  }

  @override
  Future<void> removeLinkStatusFromTask(int id) async {
    User user = auth.currentUser;
    TaskModel task;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(task.getStatusTable())
        .doc(id.toString());

    ref.delete();
  }

  @override
  Future<void> removeLinkTagFromTask(int id) async {
    User user = auth.currentUser;
    TaskModel task;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(task.getTagTable())
        .doc(id.toString());

    ref.delete();
  }

  @override
  Future<void> removeLinkTodoFromTask(int id) async {
    User user = auth.currentUser;
    TaskModel task;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(task.getTodoTable())
        .doc(id.toString());

    ref.delete().then((value) => print(ref.id));
  }

  /// Gets a random inspiration from cloud
  ///
  ///

}
