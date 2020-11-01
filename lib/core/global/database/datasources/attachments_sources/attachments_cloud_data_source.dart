import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:meta/meta.dart';

import 'package:sorted/core/global/database/sqflite_init.dart';
import 'package:sorted/core/global/models/attachment.dart';
import 'package:sorted/core/global/models/image.dart';
import 'package:sorted/core/global/models/link.dart';
import 'package:sorted/core/global/models/log.dart';
import 'package:sorted/core/global/models/review.dart';
import 'package:sorted/core/global/models/tag.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/data/models/inspiration.dart';
import 'package:sorted/features/HOME/data/models/placeholder_info.dart';
import 'package:sorted/features/PLAN/data/models/goal.dart';
import 'package:sqflite/sqflite.dart';

abstract class AttachmentsCloud {
  Future<ImageModel> storeImage(
      File imageFile, String directory, ImageModel image);

  void unStoreImage(ImageModel image);
  Future<void> addImage(ImageModel image);
  Future<void> updateImage(ImageModel image);
  Future<void> deleteImage(ImageModel image);
  Future<void> addLink(LinkModel link);
  Future<void> updateLink(LinkModel link);
  Future<void> deleteLink(LinkModel log);
  Future<void> addLog(LogModel log);
  Future<void> updateLog(LogModel log);
  Future<void> deleteLog(LogModel image);
  Future<void> addTag(TagModel tag);
  Future<void> updateTag(TagModel tag);
  Future<void> deleteTag(TagModel tag);
  Future<void> addAttachment(AttachmentModel attachment);
  Future<void> updateAttachment(AttachmentModel attachment);
  Future<void> deleteAttachment(AttachmentModel attachment);
  Future<void> addReview(ReviewModel review);
  Future<void> updateReview(ReviewModel review);
  Future<void> deleteReview(ReviewModel review);
}

class AttachmentCloudDataSourceImpl implements AttachmentsCloud {
  final Firestore cloudDb;
  final FirebaseAuth auth;
  final SqlDatabaseService nativeDb;
  final StorageReference cloudStorage;
  Batch batch;

  AttachmentCloudDataSourceImpl(
      {@required this.cloudDb,
      @required this.auth,
      @required this.nativeDb,
      @required this.cloudStorage});

  @override
  Future<ImageModel> storeImage(
      File imageFile, String directory, ImageModel image) async {
    DateTime now = DateTime.now();
    FirebaseUser user = await auth.currentUser();
    image = image.copyWith(savedTs: now);

    StorageReference firebaseStorageRef =
        cloudStorage.child('uploads/${user.uid}/$directory/${image.localPath}');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    await taskSnapshot.ref.getDownloadURL().then(
      (value) {
        image = image.copyWith(url: value, savedTs: DateTime.now());
      },
    );
    return image;
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
  Future<void> addAttachment(AttachmentModel attachemnt) async {
    FirebaseUser user = await auth.currentUser();

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(attachemnt.getTable())
        .document(attachemnt.id.toString());

    ref.setData(attachemnt.toMap()).then((value) => print(ref.documentID));
  }

  @override
  Future<void> addLink(LinkModel link) async {
    FirebaseUser user = await auth.currentUser();

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection("Links")
        .document(link.id.toString());

    ref.setData(link.toMap()).then((value) => print(ref.documentID));
  }

  @override
  Future<void> addLog(LogModel log) async {
    FirebaseUser user = await auth.currentUser();

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection("Logs")
        .document(log.id.toString());

    ref.setData(log.toMap()).then((value) => print(ref.documentID));
  }

  @override
  Future<void> addTag(TagModel tag) async {
    FirebaseUser user = await auth.currentUser();

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection("Tags")
        .document(tag.id.toString());

    ref.setData(tag.toMap()).then((value) => print(ref.documentID));
  }

  @override
  Future<void> deleteAttachment(AttachmentModel attachment) async {
    FirebaseUser user = await auth.currentUser();

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(attachment.getTable())
        .document(attachment.id.toString());

    ref.delete().then((value) => print(ref.documentID));
    return;
  }

  @override
  Future<void> deleteLink(LinkModel link) async {
    FirebaseUser user = await auth.currentUser();

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection("Links")
        .document(link.id.toString());

    ref.delete().then((value) => print(ref.documentID));
    return;
  }

  @override
  Future<void> deleteLog(LogModel log) async {
    FirebaseUser user = await auth.currentUser();

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection("Logs")
        .document(log.id.toString());

    ref.delete().then((value) => print(ref.documentID));
    return;
  }

  @override
  Future<void> deleteTag(TagModel tag) async {
    FirebaseUser user = await auth.currentUser();

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection("Tags")
        .document(tag.id.toString());

    ref.delete().then((value) => print(ref.documentID));
    return;
  }

  @override
  Future<void> updateAttachment(AttachmentModel attachment) async {
    FirebaseUser user = await auth.currentUser();

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(attachment.getTable())
        .document(attachment.id.toString());

    ref.updateData(attachment.toMap()).then((value) => print(ref.documentID));
  }

  @override
  Future<void> updateImage(ImageModel image) async {
    FirebaseUser user = await auth.currentUser();

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(image.getTable())
        .document(image.id.toString());

    ref.updateData(image.toMap()).then((value) => print(ref.documentID));
  }

  @override
  Future<void> updateLink(LinkModel link) async {
    FirebaseUser user = await auth.currentUser();

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(link.getTable())
        .document(link.id.toString());

    ref.updateData(link.toMap()).then((value) => print(ref.documentID));
  }

  @override
  Future<void> updateLog(LogModel log) async {
    FirebaseUser user = await auth.currentUser();

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(log.getTable())
        .document(log.id.toString());

    ref.updateData(log.toMap()).then((value) => print(ref.documentID));
  }

  @override
  Future<void> updateTag(TagModel tag) async {
    FirebaseUser user = await auth.currentUser();

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(tag.getTable())
        .document(tag.id.toString());

    ref.updateData(tag.toMap()).then((value) => print(ref.documentID));
  }

  @override
  Future<void> addReview(ReviewModel review) async {
    FirebaseUser user = await auth.currentUser();

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(review.getString())
        .document(review.id.toString());

    ref.setData(review.toMap()).then((value) => print(ref.documentID));
  }

  @override
  Future<void> deleteReview(ReviewModel review) async {
    FirebaseUser user = await auth.currentUser();

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(review.getString())
        .document(review.id.toString());

    ref.delete().then((value) => print(ref.documentID));
  }

  @override
  Future<void> updateReview(ReviewModel review) async {
    FirebaseUser user = await auth.currentUser();

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(review.getString())
        .document(review.id.toString());

    ref.updateData(review.toMap()).then((value) => print(ref.documentID));
  }
}
