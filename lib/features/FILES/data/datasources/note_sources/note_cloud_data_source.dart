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
import 'package:sorted/features/FILES/data/models/block_calendar.dart';
import 'package:sorted/features/FILES/data/models/block_calendar_event.dart';
import 'package:sorted/features/FILES/data/models/block_column.dart';
import 'package:sorted/features/FILES/data/models/block_form_field.dart';
import 'package:sorted/features/FILES/data/models/block_image.dart';
import 'package:sorted/features/FILES/data/models/block_image_colossal.dart';
import 'package:sorted/features/FILES/data/models/block_info.dart';
import 'package:sorted/features/FILES/data/models/block_sequence.dart';
import 'package:sorted/features/FILES/data/models/block_slider.dart';
import 'package:sorted/features/FILES/data/models/block_table.dart';
import 'package:sorted/features/FILES/data/models/block_table_item.dart';
import 'package:sorted/features/FILES/data/models/block_textbox.dart';
import 'package:sorted/features/FILES/data/models/block_youtube.dart';
import 'package:sorted/features/FILES/data/models/note_model.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/data/models/inspiration.dart';
import 'package:sorted/features/HOME/data/models/placeholder_info.dart';
import 'package:sorted/features/HOME/domain/entities/unsplash_image.dart';
import 'package:sorted/features/PLAN/data/models/goal.dart';
import 'package:sorted/features/PLAN/data/models/task.dart';
import 'package:sorted/features/PLAN/data/models/todo_item.dart';
import 'package:sqflite/sqflite.dart';

abstract class NoteCloud {
  Future<void> addNote(NoteModel note);
  Future<void> updateNote(NoteModel note);
  Future<void> deleteNote(NoteModel note);
  Future<void> addColossal(ColossalBlock colossal);
  Future<void> updateColossal(ColossalBlock colossal);
  Future<void> deleteColossal(ColossalBlock colossal);
  Future<void> addSlider(SliderBlock slider);
  Future<void> updateSlider(SliderBlock slider);
  Future<void> deleteSlider(SliderBlock slider);
  Future<void> addSequence(SequenceBlock sequence);
  Future<void> updateSequence(SequenceBlock sequence);
  Future<void> deleteSequence(SequenceBlock sequence);
  Future<void> addYoutubeVideo(YoutubeBlock sequence);
  Future<void> updateYoutubeVideo(YoutubeBlock sequence);
  Future<void> deleteYoutubeVideo(YoutubeBlock sequence);
  Future<void> addFormField(FormFieldBlock formfield);
  Future<void> updateFormField(FormFieldBlock formfield);
  Future<void> deleteFormField(FormFieldBlock formfield);
  Future<void> addTable(TableBlock table);
  Future<void> updateTable(TableBlock table);
  Future<void> deleteTable(TableBlock table);
  Future<void> addCheckbox(TodoItemModel item);
  Future<void> updateCheckbox(TodoItemModel item);
  Future<void> deleteCheckbox(TodoItemModel item);
  Future<void> addTableColumn(ColumnBlock col);
  Future<void> updateTableColumn(ColumnBlock col);
  Future<void> deleteTableColumn(ColumnBlock col);
  Future<void> addTableItem(TableItemBlock item);
  Future<void> updateTableItem(TableItemBlock item);
  Future<void> deleteTableItem(TableItemBlock item);
  Future<void> addCalendarItem(CalendarBlock item);
  Future<void> updateCalendarItem(CalendarBlock item);
  Future<void> deleteCalendarItem(CalendarBlock item);
  Future<void> addCalendarEvent(CalendarEventBlock item);
  Future<void> updateCalendarEvent(CalendarEventBlock item);
  Future<void> deleteCalendarEvent(CalendarEventBlock item);
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
  Future<void> updateImageBlock(ImageBlock imageblock);
  Future<void> deleteImageBlock(ImageBlock imageblock);
}

class NoteCloudDataSourceImpl implements NoteCloud {
  final FirebaseFirestore cloudDb;
  final FirebaseAuth auth;
  final SqlDatabaseService nativeDb;
  Batch batch;

  NoteCloudDataSourceImpl(
      {@required this.cloudDb, @required this.auth, @required this.nativeDb});

  @override
  Future<void> addBlockInfo(BlockInfo blockInfo) async {
    User user = auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(blockInfo.getTable())
        .doc(blockInfo.id.toString());

    ref
        .set(blockInfo.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> addLinkBlockToNote(
      NoteModel note, BlockInfo block, int id) async {
    User user =  auth.currentUser;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(note.getTableOfBlocks())
        .doc(id.toString());

    ref.set({
      "id": id,
      "note_id": note.id,
      "block_id": block.id,
      "savedTs": DateTime.now().millisecondsSinceEpoch
    }).then((value) => print(ref.id));
  }

  @override
  Future<void> addLinkLogToNote(NoteModel note, LogModel log, int id) async {
    User user = auth.currentUser;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(note.getTableOfLogs())
        .doc(id.toString());

    ref.set({
      "id": id,
      "note_id": note.id,
      "log_id": log.id,
      "savedTs": DateTime.now().millisecondsSinceEpoch
    }).then((value) => print(ref.id));
  }

  @override
  Future<void> addLinkTagToNote(NoteModel note, TagModel tag, int id) async {
    User user = auth.currentUser;

    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(note.getTableOfTags())
        .doc(id.toString());

    ref.set({
      "id": id,
      "note_id": note.id,
      "tag_id": tag.id,
      "savedTs": DateTime.now().millisecondsSinceEpoch
    }).then((value) => print(ref.id));
  }

  @override
  Future<void> addNote(NoteModel note) async {
    User user = auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(note.getTable())
        .doc(note.id.toString());

    ref
        .set(note.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> addTextboxBlock(TextboxBlock textbox) async {
    User user = auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(textbox.getTable())
        .doc(textbox.id.toString());

    ref
        .set(textbox.toMap())
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
    User user = auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(blockInfo.getTable())
        .doc(blockInfo.id.toString());

    ref
        .update(blockInfo.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> updateNote(NoteModel note) async {
    User user = auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(note.getTable())
        .doc(note.id.toString());

    ref
        .update(note.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> updateTextboxBlock(TextboxBlock textbox) async {
    User user =  auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(textbox.getTable())
        .doc(textbox.id.toString());

    ref
        .update(textbox.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> addImageBlock(ImageBlock imageblock) async {
    User user = auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(imageblock.getTable())
        .doc(imageblock.id.toString());

    ref
        .set(imageblock.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> addCalendarEvent(CalendarEventBlock item) async {
   User user =  auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(item.getTable())
        .doc(item.id.toString());

    ref
        .set(item.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> addCalendarItem(CalendarBlock item) async {
  User user =  auth.currentUser;
    print("adding calendar here");
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(item.getTable())
        .doc(item.id.toString());

    ref
        .set(item.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> addCheckbox(TodoItemModel item) async {
    User user =  auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(item.getTable())
        .doc(item.id.toString());

    ref
        .set(item.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> addColossal(ColossalBlock item) async {
    User user =  auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(item.getTable())
        .doc(item.id.toString());

    ref
        .set(item.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> addFormField(FormFieldBlock item) async {
    User user =  auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(item.getTable())
        .doc(item.id.toString());

    ref
        .set(item.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> addSequence(SequenceBlock item) async {
    User user =  auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(item.getTable())
        .doc(item.id.toString());

    ref
        .set(item.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> addSlider(SliderBlock item) async {
    User user =  auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(item.getTable())
        .doc(item.id.toString());

    ref
        .set(item.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> addTable(TableBlock item) async {
    User user =  auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(item.getTable())
        .doc(item.id.toString());

    ref
        .set(item.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> addTableColumn(ColumnBlock item) async {
    User user =  auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(item.getTable())
        .doc(item.id.toString());

    ref
        .set(item.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> addTableItem(TableItemBlock item) async {
    User user = await auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(item.getTable())
        .doc(item.id.toString());

    ref
        .set(item.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> addYoutubeVideo(YoutubeBlock item) async {
   User user = await auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(item.getTable())
        .doc(item.id.toString());

    ref
        .set(item.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> deleteCalendarEvent(CalendarEventBlock item) {
    // TODO: implement deleteCalendarEvent
    throw UnimplementedError();
  }

  @override
  Future<void> deleteCalendarItem(CalendarBlock item) {
    // TODO: implement deleteCalendarItem
    throw UnimplementedError();
  }

  @override
  Future<void> deleteCheckbox(TodoItemModel item) {
    // TODO: implement deleteCheckbox
    throw UnimplementedError();
  }

  @override
  Future<void> deleteColossal(ColossalBlock colossal) {
    // TODO: implement deleteColossal
    throw UnimplementedError();
  }

  @override
  Future<void> deleteFormField(FormFieldBlock formfield) {
    // TODO: implement deleteFormField
    throw UnimplementedError();
  }

  @override
  Future<void> deleteSequence(SequenceBlock sequence) {
    // TODO: implement deleteSequence
    throw UnimplementedError();
  }

  @override
  Future<void> deleteSlider(SliderBlock slider) {
    // TODO: implement deleteSlider
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTable(TableBlock table) {
    // TODO: implement deleteTable
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTableColumn(ColumnBlock col) {
    // TODO: implement deleteTableColumn
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTableItem(TableItemBlock item) {
    // TODO: implement deleteTableItem
    throw UnimplementedError();
  }

  @override
  Future<void> deleteYoutubeVideo(YoutubeBlock sequence) {
    // TODO: implement deleteYoutubeVideo

    throw UnimplementedError();
  }

  @override
  Future<void> updateCalendarEvent(CalendarEventBlock item) async {
    User user =  auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(item.getTable())
        .doc(item.id.toString());

    ref
        .update(item.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> updateCalendarItem(CalendarBlock item) async {
    User user = await auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(item.getTable())
        .doc(item.id.toString());

    ref
        .update(item.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> updateCheckbox(TodoItemModel item) async {
    User user =  auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(item.getTable())
        .doc(item.id.toString());

    ref
        .update(item.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> updateColossal(ColossalBlock item) async {
   User user =  auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(item.getTable())
        .doc(item.id.toString());

    ref
        .update(item.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> updateFormField(FormFieldBlock item) async {
    User user =  auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(item.getTable())
        .doc(item.id.toString());

    ref
        .update(item.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> updateSequence(SequenceBlock item) async {
    User user = await auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(item.getTable())
        .doc(item.id.toString());

    ref
        .update(item.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> updateSlider(SliderBlock item) async {
   User user =  auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(item.getTable())
        .doc(item.id.toString());

    ref
        .update(item.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> updateTable(TableBlock item) async {
    User user =  auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(item.getTable())
        .doc(item.id.toString());

    ref
        .update(item.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> updateTableColumn(ColumnBlock item) async {
    User user =  auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(item.getTable())
        .doc(item.id.toString());

    ref
        .update(item.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> updateTableItem(TableItemBlock item) async {
   User user = await auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(item.getTable())
        .doc(item.id.toString());

    ref
        .update(item.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> updateYoutubeVideo(YoutubeBlock item) async {
    User user =  auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(item.getTable())
        .doc(item.id.toString());

    ref
        .update(item.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> deleteImageBlock(ImageBlock item) async {
    User user =  auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(item.getTable())
        .doc(item.id.toString());

    ref
        .update(item.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }

  @override
  Future<void> updateImageBlock(ImageBlock item) async {
    User user =  auth.currentUser;
    DocumentReference ref = cloudDb
        .collection('users')
        .doc(user.uid)
        .collection(item.getTable())
        .doc(item.id.toString());

    ref
        .update(item.toMap())
        .catchError((onError) => {print("nhi chala\n"), print("hello")});
  }
}
