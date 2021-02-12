import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/database/sqflite_init.dart';
import 'package:sorted/core/global/models/attachment.dart';
import 'package:sorted/core/global/models/image.dart';
import 'package:sorted/core/global/models/link.dart';
import 'package:sorted/core/global/models/log.dart';
import 'package:sorted/core/global/models/tag.dart';
import 'package:sorted/core/global/models/textbox.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/data/models/inspiration.dart';
import 'package:sorted/features/HOME/data/models/placeholder_info.dart';
import 'package:sorted/features/HOME/domain/entities/unsplash_image.dart';
import 'package:sorted/features/PLAN/data/models/goal.dart';
import 'package:sorted/features/PLAN/data/models/task.dart';
import 'package:sqflite/sqflite.dart';

abstract class GoalCloud {
  Future<void> addGoal(GoalModel goal);
  Future<void> updateGoal(GoalModel goal);
  Future<void> deleteGoal(GoalModel goal);
  Future<void> addLinkImageToGoal(GoalModel goal, ImageModel image, int id);
  Future<void> removeLinkImageFromGoal(int id);
  Future<void> addLinkTagToGoal(GoalModel goal, TagModel tag, int id);
  Future<void> removeLinkTagFromGoal(int id);
  Future<void> addLinkLogToGoal(GoalModel goal, LogModel log, int id);
  Future<void> removeLinkLogFromGoal(int id);
  Future<void> addLinkTextboxToGoal(
      GoalModel goal, TextboxModel textbox, int id);
  Future<void> removeLinkTextboxFromGoal(int id);
  Future<void> addLinkLinkToGoal(GoalModel goal, LinkModel link, int id);
  Future<void> removeLinkLinkFromGoal(int id);
  Future<void> addLinkAttachmentToGoal(GoalModel goal, AttachmentModel attachment, int id);
  Future<void> removeLinkAttachmentFromGoal(int id);
  Future<void> addLinkTaskToGoal(GoalModel goal, TaskModel attachment, int id);
  Future<void> removeLinkTaskFromGoal(int id);
  Future<List<String>> getGradientImages();
  Future<List<String>> getWorkImages();
  Future<List<String>> getStudiesImages();
  Future<List<String>> getInspireImages();
  Future<List<UnsplashImage>>getSearchImages(String search);
}

class GoalCloudDataSourceImpl implements GoalCloud {
  final FirebaseFirestore cloudDb;
  final FirebaseAuth auth;
  final SqlDatabaseService nativeDb;
  Batch batch;

  GoalCloudDataSourceImpl(
      {@required this.cloudDb, @required this.auth, @required this.nativeDb});

  /// Gets a random inspiration from cloud
  ///
  ///
  /// @override
  Future<void> addLinkImageToGoal(
      GoalModel goal, ImageModel image, int id) async {
    User user = await auth.currentUser;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection("Goals_Images")
        .doc(id.toString());

    ref.set({
      "id": id,
      "goal_id": goal.id,
      "image_id": image.id,
      "savedTs": DateTime.now().millisecondsSinceEpoch
    }).then((value) => print(ref.id));
  }

  @override
  Future<void> removeLinkImageFromGoal(int id) async {
    User user = await auth.currentUser;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection("Goals_Images")
        .doc(id.toString());

    ref.delete().then((value) => print(ref.id));
  }

  @override
  Future<void> addGoal(GoalModel goal) async {
     User user =  auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(goal.getTable())
        .doc(goal.id.toString());

    ref
        .set(goal.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> addLinkAttachmentToGoal(
      GoalModel goal, AttachmentModel attachment, int id) async {
     User user =  auth.currentUser;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(goal.getTableLinkAttachment())
        .doc(id.toString());

    ref.set({
      "id": id,
      "goal_id": goal.id,
      "attachment_id": attachment.id,
      "savedTs": DateTime.now().millisecondsSinceEpoch
    }).then((value) => print(ref.id));
  }

  @override
  Future<void> addLinkLinkToGoal(GoalModel goal, LinkModel link, int id) async {
     User user =  auth.currentUser;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(goal.getTableLinkLinks())
        .doc(id.toString());

    ref.set({
      "id": id,
      "goal_id": goal.id,
      "link_id": link.id,
      "savedTs": DateTime.now().millisecondsSinceEpoch
    }).then((value) => print(ref.id));
  }

  @override
  Future<void> addLinkLogToGoal(GoalModel goal, LogModel log, int id) async {
     User user =  auth.currentUser;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(goal.getTableLinkLogs())
        .doc(id.toString());

    ref.set({
      "id": id,
      "goal_id": goal.id,
      "log_id": log.id,
      "savedTs": DateTime.now().millisecondsSinceEpoch
    }).then((value) => print(ref.id));
  }

  @override
  Future<void> addLinkTagToGoal(GoalModel goal, TagModel tag, int id) async {
     User user =  auth.currentUser;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(goal.getTableLinkTags())
        .doc(id.toString());

    ref.set({
      "id": id,
      "goal_id": goal.id,
      "tag_id": tag.id,
      "savedTs": DateTime.now().millisecondsSinceEpoch
    }).then((value) => print(ref.id));
  }

  @override
  Future<void> addLinkTextboxToGoal(
      GoalModel goal, TextboxModel textbox, int id) async {
    User user =  auth.currentUser;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(goal.getTableLinktextbox())
        .doc(id.toString());

    ref.set({
      "id": id,
      "goal_id": goal.id,
      "textbox_id": textbox.id,
      "savedTs": DateTime.now().millisecondsSinceEpoch
    }).then((value) => print(ref.id));
  }

  @override
  Future<void> deleteGoal(GoalModel goal) async {
    User user =  auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(goal.getTable())
        .doc(goal.id.toString());

    ref
        .delete()
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> removeLinkAttachmentFromGoal(int id) async {
     User user =  auth.currentUser;
    GoalModel goal;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(goal.getTableLinkAttachment())
        .doc(id.toString());

    ref.delete().then((value) => print(ref.id));
  }

  @override
  Future<void> removeLinkLinkFromGoal(int id) async {
     User user =  auth.currentUser;
    GoalModel goal;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(goal.getTableLinkLinks())
        .doc(id.toString());

    ref.delete().then((value) => print(ref.id));
  }

  @override
  Future<void> removeLinkLogFromGoal(int id) async {
    User user =  auth.currentUser;
    GoalModel goal;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(goal.getTableLinkLogs())
        .doc(id.toString());

    ref.delete().then((value) => print(ref.id));
  }

  @override
  Future<void> removeLinkTagFromGoal(int id) async {
     User user =  auth.currentUser;
    GoalModel goal;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(goal.getTableLinkTags())
        .doc(id.toString());

    ref.delete().then((value) => print(ref.id));
  }

  @override
  Future<void> removeLinkTextboxFromGoal(int id) async {
     User user =  auth.currentUser;
    GoalModel goal;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(goal.getTableLinktextbox())
        .doc(id.toString());

    ref.delete().then((value) => print(ref.id));
  }

  @override
  Future<void> updateGoal(GoalModel goal) async {
     User user =  auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(goal.getTable())
        .doc(goal.id.toString());

    ref
        .update(goal.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> addLinkTaskToGoal(GoalModel goal, TaskModel task, int id) async {
     User user =  auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(goal.getTableLinkTasks())
        .doc(id.toString());

    ref.set({
      "id": id,
      "goal_id": goal.id,
      "task_id": task.id,
      "savedTs": DateTime.now().millisecondsSinceEpoch
    }).then((value) => print(ref.id));
  }

  @override
  Future<void> removeLinkTaskFromGoal(int id) async {
    User user =  auth.currentUser;
    GoalModel goal;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(goal.getTableLinkTasks())
        .doc(id.toString());

    ref.delete().then((value) => print(ref.id));
  }

  @override
  Future<List<String>> getGradientImages() async {
    QuerySnapshot snapShot = await cloudDb
        .collection('cover_images')
        .doc('gradients')
        .collection('urls')
        .get();
    if (snapShot != null && snapShot.docs.length != 0) {
      final List<DocumentSnapshot> documents = snapShot.docs;
      return documents.map<String>((e) => e['url']).toList();
    }
    return Future.value([]);
  }

  @override
  Future<List<String>> getStudiesImages() async {
    QuerySnapshot snapShot = await cloudDb
        .collection('cover_images')
        .doc('study')
        .collection('urls')
        .get();
    if (snapShot != null && snapShot.docs.length != 0) {
      final List<DocumentSnapshot> documents = snapShot.docs;
      return documents.map<String>((e) => e['url']).toList();
    }
    return Future.value([]);
  }

  @override
  Future<List<String>> getWorkImages() async {
    QuerySnapshot snapShot = await cloudDb
        .collection('cover_images')
        .doc('work')
        .collection('urls')
        .get();
    if (snapShot != null && snapShot.docs.length != 0) {
      final List<DocumentSnapshot> documents = snapShot.docs;
      return documents.map<String>((e) => e['url']).toList();
    }
    return Future.value([]);
  }

  @override
  Future<List<String>> getInspireImages() async {
    QuerySnapshot snapShot = await cloudDb
        .collection('cover_images')
        .doc('inspire')
        .collection('urls')
        .get();
    if (snapShot != null && snapShot.docs.length != 0) {
      final List<DocumentSnapshot> documents = snapShot.docs;
      return documents.map<String>((e) => e['url']).toList();
    }
    return Future.value([]);
  }

  @override
  Future<List<UnsplashImage>> getSearchImages(String search) async {
    List<UnsplashImage> images = [];
    var _parsedResponse;
    print("HomeRemoteApiDataSourceImpl #######");
    String INSPIRATION_PHOTO_ENDPOINT =
    'https://api.unsplash.com//search/photos?per_page=30&query=$search&orientation=landscape&';


    http.Response response = await http.get(INSPIRATION_PHOTO_ENDPOINT+
        'client_id=${UnsplashApi.kAccessKey}');
    print(response.body);
    if (response.statusCode == 200) {
      print("response successful #######");
      print(response.body);

      _parsedResponse = json.decode(response.body);
      Iterable i = _parsedResponse['results'];
      images = i.map((model) => UnsplashImage.fromJson(model)).toList();
     
    }
    return images;

    
  }
}
