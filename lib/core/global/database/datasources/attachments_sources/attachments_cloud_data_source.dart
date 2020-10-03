import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:meta/meta.dart';

import 'package:sorted/core/global/database/sqflite_init.dart';
import 'package:sorted/core/global/models/image.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/data/models/inspiration.dart';
import 'package:sorted/features/HOME/data/models/placeholder_info.dart';
import 'package:sorted/features/PLAN/data/models/goal.dart';
import 'package:sqflite/sqflite.dart';

abstract class AttachmentsCloud {
  Future<ImageModel> storeImage(File imageFile, String directory);
 
  Future<void> addLinkImageToGoal(GoalModel goal, ImageModel image);
  void unStoreImage(ImageModel image);
  Future<void> addImage(ImageModel image);
  Future<void> deleteImage(ImageModel image);
  Future<void> addLink(ImageModel image);
  Future<void> deleteLink(ImageModel image);
  Future<void> addLog(ImageModel image);
  Future<void> deleteLog(ImageModel image);
  Future<void> addTag(ImageModel image);
  Future<void> deleteTag(ImageModel image);
  Future<void> addAudio(ImageModel image);
  Future<void> deleteAudio(ImageModel image);  
  Future<void> removeLinkImageFomGoal(GoalModel goal, ImageModel image);
}

class HomeCloudDataSourceImpl implements AttachmentsCloud {
  final Firestore cloudDb;
  final FirebaseAuth auth;
  final SqlDatabaseService nativeDb;
  final StorageReference cloudStorage;
  Batch batch;

  HomeCloudDataSourceImpl(
      {@required this.cloudDb,
      @required this.auth,
      @required this.nativeDb,
      @required this.cloudStorage});

  @override
  Future<ImageModel> storeImage(File imageFile, String directory,
      {String caption = ""}) async {
    DateTime now = DateTime.now();
    ImageModel thisImage = new ImageModel(
        caption: caption,
        id: now.millisecondsSinceEpoch,
        localPath: imageFile.path);

    StorageReference firebaseStorageRef =
        cloudStorage.child('uploads/$directory');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    await taskSnapshot.ref.getDownloadURL().then(
      (value) {
        thisImage.copyWith(url: value, savedTs: DateTime.now());
      },
    );
    return thisImage;
  }

  void unStoreImage(ImageModel image) {
    FirebaseStorage.instance.getReferenceFromUrl(image.url).then((res) {
      res.delete().then((res) {
        print("Deleted!");
      });
    });
  }

  @override
  Future<void> addImage(ImageModel image) async {
    FirebaseUser user = await auth.currentUser();

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection("Images")
        .document(image.id.toString());

    ref.setData(image.toMap()).then((value) => print(ref.documentID));
  }

  @override
  Future<void> deleteImage(ImageModel image) async {
    FirebaseUser user = await auth.currentUser();

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection("Images")
        .document(image.id.toString());

    ref.delete().then((value) => print(ref.documentID));
    return;
  }



  @override
  Future<void> addLinkImageToGoal(GoalModel goal, ImageModel image) async {
    FirebaseUser user = await auth.currentUser();

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection("Goals_Images")
        .document(goal.id.toString() + image.id.toString());

    ref.setData({
      "goal_id": goal.id,
      "image_id": image.id,
      "savedTs": DateTime.now().millisecondsSinceEpoch
    }).then((value) => print(ref.documentID));
  }

  @override
  Future<void> removeLinkImageFomGoal(GoalModel goal, ImageModel image) async {
    FirebaseUser user = await auth.currentUser();

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection("Goals_Images")
        .document(goal.id.toString() + image.id.toString());

    ref.delete().then((value) => print(ref.documentID));
  }

  @override
  Future<void> addAudio(ImageModel image) {
      // TODO: implement addAudio
      throw UnimplementedError();
    }
  
    @override
    Future<void> addLink(ImageModel image) {
      // TODO: implement addLink
      throw UnimplementedError();
    }
  
    @override
    Future<void> addLog(ImageModel image) {
      // TODO: implement addLog
      throw UnimplementedError();
    }
  
    @override
    Future<void> addTag(ImageModel image) {
      // TODO: implement addTag
      throw UnimplementedError();
    }
  
    @override
    Future<void> deleteAudio(ImageModel image) {
      // TODO: implement deleteAudio
      throw UnimplementedError();
    }
  
    @override
    Future<void> deleteLink(ImageModel image) {
      // TODO: implement deleteLink
      throw UnimplementedError();
    }
  
    @override
    Future<void> deleteLog(ImageModel image) {
      // TODO: implement deleteLog
      throw UnimplementedError();
    }
  
    @override
  Future<void> deleteTag(ImageModel image) {
    // TODO: implement deleteTag
    throw UnimplementedError();
  }
}
