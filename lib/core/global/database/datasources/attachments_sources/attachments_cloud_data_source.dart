import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;

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
  final FirebaseFirestore cloudDb;
  final FirebaseAuth auth;
  final SqlDatabaseService nativeDb;
  final Reference cloudStorage;
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
    User user = auth.currentUser;

    image = image.copyWith(savedTs: now);
    String storagePath =
        'uploads/${user.uid}/$directory/${p.basename(image.localPath)}';
    image = image.copyWith(storagePath: storagePath);

    Reference firebaseStorageRef = cloudStorage.child(storagePath);
    UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);

    await (await uploadTask).ref.getDownloadURL().then(
      (value) {
        image = image.copyWith(url: value, savedTs: DateTime.now());
      },
    );
    return image;
  }

  void unStoreImage(ImageModel image) {
    FirebaseStorage.instance.refFromURL(image.url).delete().then((res) {
      print("Deleted!");
    });
  }

  @override
  Future<void> addImage(ImageModel image) async {
    User user =  auth.currentUser;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection("Images")
        .doc(image.id.toString());

    ref.set(image.toMap()).then((value) => print(ref.id));
  }

  @override
  Future<void> deleteImage(ImageModel image) async {
    User user =  auth.currentUser;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection("Images")
        .doc(image.id.toString());

    ref.delete().then((value) => print(ref.id));
    return;
  }

  @override
  Future<void> addAttachment(AttachmentModel attachemnt) async {
    User user = auth.currentUser;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(attachemnt.getTable())
        .doc(attachemnt.id.toString());

    ref.set(attachemnt.toMap()).then((value) => print(ref.id));
  }

  @override
  Future<void> addLink(LinkModel link) async {
    User user = auth.currentUser;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection("Links")
        .doc(link.id.toString());

    ref.set(link.toMap()).then((value) => print(ref.id));
  }

  @override
  Future<void> addLog(LogModel log) async {
    User user =  auth.currentUser;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection("Logs")
        .doc(log.id.toString());

    ref.set(log.toMap()).then((value) => print(ref.id));
  }

  @override
  Future<void> addTag(TagModel tag) async {
   User user =  auth.currentUser;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection("Tags")
        .doc(tag.id.toString());

    ref.set(tag.toMap()).then((value) => print(ref.id));
  }

  @override
  Future<void> deleteAttachment(AttachmentModel attachment) async {
    User user =  auth.currentUser;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(attachment.getTable())
        .doc(attachment.id.toString());

    ref.delete().then((value) => print(ref.id));
    return;
  }

  @override
  Future<void> deleteLink(LinkModel link) async {
    User user =  auth.currentUser;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection("Links")
        .doc(link.id.toString());

    ref.delete().then((value) => print(ref.id));
    return;
  }

  @override
  Future<void> deleteLog(LogModel log) async {
    User user =  auth.currentUser;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection("Logs")
        .doc(log.id.toString());

    ref.delete().then((value) => print(ref.id));
    return;
  }

  @override
  Future<void> deleteTag(TagModel tag) async {
    User user =  auth.currentUser;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection("Tags")
        .doc(tag.id.toString());

    ref.delete().then((value) => print(ref.id));
    return;
  }

  @override
  Future<void> updateAttachment(AttachmentModel attachment) async {
    User user =  auth.currentUser;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(attachment.getTable())
        .doc(attachment.id.toString());

    ref.update(attachment.toMap()).then((value) => print(ref.id));
  }

  @override
  Future<void> updateImage(ImageModel image) async {
    User user =  auth.currentUser;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(image.getTable())
        .doc(image.id.toString());

    ref.update(image.toMap()).then((value) => print(ref.id));
  }

  @override
  Future<void> updateLink(LinkModel link) async {
    User user =  auth.currentUser;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(link.getTable())
        .doc(link.id.toString());

    ref.update(link.toMap()).then((value) => print(ref.id));
  }

  @override
  Future<void> updateLog(LogModel log) async {
    User user =  auth.currentUser;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(log.getTable())
        .doc(log.id.toString());

    ref.update(log.toMap()).then((value) => print(ref.id));
  }

  @override
  Future<void> updateTag(TagModel tag) async {
    User user =  auth.currentUser;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(tag.getTable())
        .doc(tag.id.toString());

    ref.update(tag.toMap()).then((value) => print(ref.id));
  }

  @override
  Future<void> addReview(ReviewModel review) async {
    User user =  auth.currentUser;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(review.getString())
        .doc(review.id.toString());

    ref.set(review.toMap()).then((value) => print(ref.id));
  }

  @override
  Future<void> deleteReview(ReviewModel review) async {
    User user =  auth.currentUser;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(review.getString())
        .doc(review.id.toString());

    ref.delete().then((value) => print(ref.id));
  }

  @override
  Future<void> updateReview(ReviewModel review) async {
   User user =  auth.currentUser;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(review.getString())
        .doc(review.id.toString());

    ref.update(review.toMap()).then((value) => print(ref.id));
  }
}
