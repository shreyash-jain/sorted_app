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
  final Firestore cloudDb;
  final FirebaseAuth auth;
  final SqlDatabaseService nativeDb;
  Batch batch;

  TaskCloudDataSourceImpl(
      {@required this.cloudDb, @required this.auth, @required this.nativeDb});

  @override
  Future<void> addStatus(TaskStatusModel status) async {
    FirebaseUser user = await auth.currentUser();
    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(status.getTable())
        .document(status.id.toString());

    ref
        .setData(status.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> addTask(TaskModel task) async {
    FirebaseUser user = await auth.currentUser();
    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(task.getTable())
        .document(task.id.toString());

    ref
        .setData(task.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> deleteGoal(TaskModel task) async {
    FirebaseUser user = await auth.currentUser();
    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(task.getTable())
        .document(task.id.toString());

    ref
        .delete()
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> deleteStatus(TaskStatusModel status) async {
    FirebaseUser user = await auth.currentUser();
    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(status.getTable())
        .document(status.id.toString());

    ref
        .delete()
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    FirebaseUser user = await auth.currentUser();
    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(task.getTable())
        .document(task.id.toString());

    ref
        .updateData(task.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> updateStatus(TaskStatusModel status) async {
    FirebaseUser user = await auth.currentUser();
    DocumentReference ref;
    cloudDb
        .collection('users')
        .document(user.uid)
        .collection(status.getTable())
        .where("id", isEqualTo: status.id)
        .limit(1)
        .getDocuments()
        .then((value) {
      ref = value.documents[0].reference;
      ref
          .updateData(status.toMap())
          .catchError((onError) => {print("nhi chala\n"), print("hello")});
    });
  }

  @override
  Future<void> addLinkAttachmentToTask(
      TaskModel task, AttachmentModel attachment, int id) async {
    FirebaseUser user = await auth.currentUser();

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(task.getAttachmentTable())
        .document(id.toString());

    ref.setData({
      "id": id,
      "task_id": task.id,
      "attachment_id": attachment.id,
      "savedTs": DateTime.now().millisecondsSinceEpoch
    }).then((value) => print(ref.documentID));
  }

  @override
  Future<void> addLinkDependencyToTask(
      TaskModel dependency, TaskModel task, int id) async {
    FirebaseUser user = await auth.currentUser();

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(task.getDependencyTable())
        .document(id.toString());

    ref.setData({
      "id": id,
      "task_id": task.id,
      "dependency_id": dependency.id,
      "savedTs": DateTime.now().millisecondsSinceEpoch
    }).then((value) => print(ref.documentID));
  }

  @override
  Future<void> addLinkImageToTask(
      TaskModel task, ImageModel image, int id) async {
    FirebaseUser user = await auth.currentUser();

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(task.getImageTable())
        .document(id.toString());

    ref.setData({
      "id": id,
      "task_id": task.id,
      "image_id": image.id,
      "savedTs": DateTime.now().millisecondsSinceEpoch
    }).then((value) => print(ref.documentID));
  }

  @override
  Future<void> addLinkLinkToTask(TaskModel task, LinkModel link, int id) async {
    FirebaseUser user = await auth.currentUser();
    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(task.getLinkTable())
        .document(id.toString());

    ref.setData({
      "id": id,
      "task_id": task.id,
      "link_id": link.id,
      "savedTs": DateTime.now().millisecondsSinceEpoch
    }).then((value) => print(ref.documentID));
  }

  @override
  Future<void> addLinkLogToTask(TaskModel task, LogModel log, int id) async {
    FirebaseUser user = await auth.currentUser();
    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(task.getLogTable())
        .document(id.toString());

    ref.setData({
      "id": id,
      "task_id": task.id,
      "log_id": log.id,
      "savedTs": DateTime.now().millisecondsSinceEpoch
    }).then((value) => print(ref.documentID));
  }

  @override
  Future<void> addLinkTagToTask(TaskModel task, TagModel tag, int id) async {
    FirebaseUser user = await auth.currentUser();
    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(task.getTagTable())
        .document(id.toString());

    ref.setData({
      "id": id,
      "task_id": task.id,
      "tag_id": tag.id,
      "savedTs": DateTime.now().millisecondsSinceEpoch
    }).then((value) => print(ref.documentID));
  }

  @override
  Future<void> addLinkTaskToActivity(
      TaskModel task, UserAModel activity, int id) async {
    FirebaseUser user = await auth.currentUser();
    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(task.getActivityTable())
        .document(id.toString());

    ref.setData({
      "id": id,
      "task_id": task.id,
      "activity_id": activity.id,
      "savedTs": DateTime.now().millisecondsSinceEpoch
    }).then((value) => print(ref.documentID));
  }

  @override
  Future<void> addLinkTaskToReview(
      TaskModel task, ReviewModel review, int id) async {
    FirebaseUser user = await auth.currentUser();
    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(task.getReviewTable())
        .document(id.toString());

    ref.setData({
      "id": id,
      "task_id": task.id,
      "review_id": review.id,
      "savedTs": DateTime.now().millisecondsSinceEpoch
    }).then((value) => print(ref.documentID));
  }

  @override
  Future<void> addLinkTaskToStatus(
      TaskModel task, TaskStatusModel status, int id) async {
    FirebaseUser user = await auth.currentUser();
    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(task.getStatusTable())
        .document(id.toString());

    ref.setData({
      "id": id,
      "task_id": task.id,
      "status_id": status.id,
      "savedTs": DateTime.now().millisecondsSinceEpoch
    }).then((value) => print(ref.documentID));
  }

  @override
  Future<void> addLinkTaskToTodo(TaskModel task, TodoModel todo, int id) async {
    FirebaseUser user = await auth.currentUser();
    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(task.getTodoTable())
        .document(id.toString());

    ref.setData({
      "id": id,
      "task_id": task.id,
      "todo_id": todo.id,
      "savedTs": DateTime.now().millisecondsSinceEpoch
    }).then((value) => print(ref.documentID));
  }

  @override
  Future<void> removeLinkActivityFromTask(int id) async {
    FirebaseUser user = await auth.currentUser();
    TaskModel task;

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(task.getActivityTable())
        .document(id.toString());

    ref.delete().then((value) => print(ref.documentID));
  }

  @override
  Future<void> removeLinkAttachmentFromTask(int id) async {
    FirebaseUser user = await auth.currentUser();
    TaskModel task;

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(task.getAttachmentTable())
        .document(id.toString());

    ref.delete().then((value) => print(ref.documentID));
  }

  @override
  Future<void> removeLinkDependencyFromTask(int id) async {
    FirebaseUser user = await auth.currentUser();
    TaskModel task;

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(task.getDependencyTable())
        .document(id.toString());

    ref.delete().then((value) => print(ref.documentID));
  }

  @override
  Future<void> removeLinkImageFromTask(int id) async {
    FirebaseUser user = await auth.currentUser();
    TaskModel task;

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(task.getImageTable())
        .document(id.toString());

    ref.delete().then((value) => print(ref.documentID));
  }

  @override
  Future<void> removeLinkLinkFromTask(int id) async {
    FirebaseUser user = await auth.currentUser();
    TaskModel task;

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(task.getLinkTable())
        .document(id.toString());

    ref.delete().then((value) => print(ref.documentID));
  }

  @override
  Future<void> removeLinkLogFromTask(int id) async {
    FirebaseUser user = await auth.currentUser();
    TaskModel task;

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(task.getLogTable())
        .document(id.toString());

    ref.delete().then((value) => print(ref.documentID));
  }

  @override
  Future<void> removeLinkReviewFromTask(int id) async {
    FirebaseUser user = await auth.currentUser();
    TaskModel task;

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(task.getReviewTable())
        .document(id.toString());

    ref.delete().then((value) => print(ref.documentID));
  }

  @override
  Future<void> removeLinkStatusFromTask(int id) async {
    FirebaseUser user = await auth.currentUser();
    TaskModel task;

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(task.getStatusTable())
        .document(id.toString());

    ref.delete().then((value) => print(ref.documentID));
  }

  @override
  Future<void> removeLinkTagFromTask(int id) async {
    FirebaseUser user = await auth.currentUser();
    TaskModel task;

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(task.getTagTable())
        .document(id.toString());

    ref.delete().then((value) => print(ref.documentID));
  }

  @override
  Future<void> removeLinkTodoFromTask(int id) async {
    FirebaseUser user = await auth.currentUser();
    TaskModel task;

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(task.getTodoTable())
        .document(id.toString());

    ref.delete().then((value) => print(ref.documentID));
  }

  /// Gets a random inspiration from cloud
  ///
  ///

}
