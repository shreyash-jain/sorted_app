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
import 'package:sorted/features/FILES/data/models/block_image.dart';
import 'package:sorted/features/FILES/data/models/block_info.dart';
import 'package:sorted/features/FILES/data/models/block_textbox.dart';
import 'package:sorted/features/FILES/data/models/note_model.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/data/models/inspiration.dart';
import 'package:sorted/features/HOME/data/models/placeholder_info.dart';
import 'package:sorted/features/HOME/domain/entities/unsplash_image.dart';
import 'package:sorted/features/PLAN/data/models/goal.dart';
import 'package:sorted/features/PLAN/data/models/task.dart';
import 'package:sqflite/sqflite.dart';

abstract class NoteCloud {
  Future<void> addNote(NoteModel note);
  Future<void> updateNote(NoteModel note);
  Future<void> deleteNote(NoteModel note);
  Future<void> addTextboxBlock(TextboxBlock textbox);
  Future<void> updateTextboxBlock(TextboxBlock textbox);
  Future<void> deleteTextboxBlock(TextboxBlock textbox);
  Future<void> addBlockInfo(BlockInfo blockInfo);
  Future<void> updateBlockInfo(BlockInfo blockInfo);
  Future<void> deleteBlockInfo(BlockInfo blockInfo);
  Future<void> addLinkBlockToNote(NoteModel note, BlockInfo block, int id);
  Future<int> removeLinkBlockFromNote(NoteModel note, BlockInfo block);
  Future<void> addLinkTagToNote(NoteModel note, TagModel tag, int id);
  Future<int> removeLinkTagFromNote(NoteModel note, TagModel tag);
  Future<void> addLinkLogToNote(NoteModel goal, LogModel log, int id);
  Future<int> removeLinkLogFromNote(NoteModel goal, LogModel log);
  Future<void> addImageBlock(ImageBlock imageblock);
}

class NoteCloudDataSourceImpl implements NoteCloud {
  final Firestore cloudDb;
  final FirebaseAuth auth;
  final SqlDatabaseService nativeDb;
  Batch batch;

  NoteCloudDataSourceImpl(
      {@required this.cloudDb, @required this.auth, @required this.nativeDb});

  @override
  Future<void> addBlockInfo(BlockInfo blockInfo) async {
    FirebaseUser user = await auth.currentUser();
    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(blockInfo.getTable())
        .document(blockInfo.id.toString());

    ref
        .setData(blockInfo.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> addLinkBlockToNote(
      NoteModel note, BlockInfo block, int id) async {
    FirebaseUser user = await auth.currentUser();

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(note.getTableOfBlocks())
        .document(id.toString());

    ref.setData({
      "id": id,
      "note_id": note.id,
      "block_id": block.id,
      "savedTs": DateTime.now().millisecondsSinceEpoch
    }).then((value) => print(ref.documentID));
  }

  @override
  Future<void> addLinkLogToNote(NoteModel note, LogModel log, int id) async {
    FirebaseUser user = await auth.currentUser();

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(note.getTableOfLogs())
        .document(id.toString());

    ref.setData({
      "id": id,
      "note_id": note.id,
      "log_id": log.id,
      "savedTs": DateTime.now().millisecondsSinceEpoch
    }).then((value) => print(ref.documentID));
  }

  @override
  Future<void> addLinkTagToNote(NoteModel note, TagModel tag, int id) async {
    FirebaseUser user = await auth.currentUser();

    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(note.getTableOfTags())
        .document(id.toString());

    ref.setData({
      "id": id,
      "note_id": note.id,
      "tag_id": tag.id,
      "savedTs": DateTime.now().millisecondsSinceEpoch
    }).then((value) => print(ref.documentID));
  }

  @override
  Future<void> addNote(NoteModel note) async {
    FirebaseUser user = await auth.currentUser();
    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(note.getTable())
        .document(note.id.toString());

    ref
        .setData(note.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> addTextboxBlock(TextboxBlock textbox) async {
    FirebaseUser user = await auth.currentUser();
    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(textbox.getTable())
        .document(textbox.id.toString());

    ref
        .setData(textbox.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> deleteBlockInfo(BlockInfo blockInfo) {
    // TODO: implement deleteBlockInfo
    throw UnimplementedError();
  }

  @override
  Future<void> deleteNote(NoteModel note) {
    // TODO: implement deleteNote
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTextboxBlock(TextboxBlock textbox) {
    // TODO: implement deleteTextboxBlock
    throw UnimplementedError();
  }

  @override
  Future<int> removeLinkBlockFromNote(NoteModel note, BlockInfo block) {
    // TODO: implement removeLinkBlockFromNote
    throw UnimplementedError();
  }

  @override
  Future<int> removeLinkLogFromNote(NoteModel goal, LogModel log) {
    // TODO: implement removeLinkLogFromNote
    throw UnimplementedError();
  }

  @override
  Future<int> removeLinkTagFromNote(NoteModel note, TagModel tag) {
    // TODO: implement removeLinkTagFromNote
    throw UnimplementedError();
  }

  @override
  Future<void> updateBlockInfo(BlockInfo blockInfo) async {
    FirebaseUser user = await auth.currentUser();
    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(blockInfo.getTable())
        .document(blockInfo.id.toString());

    ref
        .updateData(blockInfo.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> updateNote(NoteModel note) async {
    FirebaseUser user = await auth.currentUser();
    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(note.getTable())
        .document(note.id.toString());

    ref
        .updateData(note.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> updateTextboxBlock(TextboxBlock textbox) async {
    FirebaseUser user = await auth.currentUser();
    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(textbox.getTable())
        .document(textbox.id.toString());

    ref
        .updateData(textbox.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> addImageBlock(ImageBlock imageblock) async {
     FirebaseUser user = await auth.currentUser();
    DocumentReference ref = cloudDb
        .collection('users')
        .document(user.uid)
        .collection(imageblock.getTable())
        .document(imageblock.id.toString());

    ref
        .setData(imageblock.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }
}
