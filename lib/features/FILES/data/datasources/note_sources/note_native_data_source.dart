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
import 'package:sorted/features/FILES/presentation/image_bloc/image_bloc.dart';

import 'package:sorted/features/HOME/data/models/inspiration.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:sorted/features/HOME/data/models/placeholder_info.dart';
import 'package:sorted/features/HOME/domain/entities/unsplash_image.dart';
import 'package:sorted/features/PLAN/data/models/goal.dart';
import 'package:sorted/features/PLAN/data/models/task.dart';
import 'package:sorted/features/PLAN/data/models/task_status.dart';
import 'package:sorted/features/PLAN/data/models/todo_item.dart';

abstract class NoteNative {
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
  Future<void> addImageBlock(ImageBlock imageblock);
  Future<void> updateImageBlock(ImageBlock imageblock);
  Future<void> deleteImageBlock(ImageBlock imageblock);
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
  Future<List<BlockInfo>> getBlocksOfNote(NoteModel note);
  Future<List<NoteModel>> getAllNotes();
  Future<List<NoteModel>> getNotesOfNotebook(int notebookId);
  Future<TextboxBlock> getTextboxBlock(int id);
  Future<ImageBlock> getImageBlock(int id);
  Future<ColossalBlock> getColossalBlock(int id);
  Future<List<ImageBlock>> getImagesOfColossal(int id);
  Future<SliderBlock> getSliderBlock(int id);
  Future<FormFieldBlock> getFormFieldBlock(int id);
  Future<SequenceBlock> getSequenceBlock(int id);
  Future<TableBlock> getTableBlock(int id);
  Future<CalendarBlock> getCalendarBlock(int id);
  Future<YoutubeBlock> getYoutubeVideoBlock(int id);
  Future<List<ColumnBlock>> getColumnsOfTable(int id);
  Future<List<TableItemBlock>> getItemsOfColumnsOfTable(int id);
  Future<List<CalendarEventBlock>> getCalendarEventBlock(
      int id, DateTime startDay, DateTime endDay);
  Future<List<TagModel>> getTagsOfNote(NoteModel note);
  Future<List<LogModel>> getLogsOfNote(NoteModel note);
}

class NoteNativeDataSourceImpl implements NoteNative {
  final SqlDatabaseService nativeDb;

  NoteNativeDataSourceImpl({@required this.nativeDb});

  @override
  Future<void> addBlockInfo(BlockInfo blockInfo) async {
    final db = await nativeDb.database;
    if ((await db.query(blockInfo.getTable(),
                where: "id= ?", whereArgs: [blockInfo.id]))
            .length ==
        0)
      await db.insert(blockInfo.getTable(), blockInfo.toMap());
    else
      await db.update(blockInfo.getTable(), blockInfo.toMap(),
          where: "id = ?", whereArgs: [blockInfo.id]);
  }

  @override
  Future<void> addLinkBlockToNote(
      NoteModel note, BlockInfo block, int id) async {
    final db = await nativeDb.database;
    if ((await db.query(note.getTableOfBlocks(),
                where: "note_id=? and block_id=?",
                whereArgs: [note.id, block.id]))
            .length ==
        0)
      await db.insert(note.getTableOfBlocks(), {
        "note_id": note.id,
        "block_id": block.id,
        "savedTs": DateTime.now().millisecondsSinceEpoch,
        "id": id
      });
  }

  @override
  Future<void> addLinkLogToNote(NoteModel note, LogModel log, int id) async {
    final db = await nativeDb.database;
    if ((await db.query(note.getTableOfLogs(),
                where: "note_id=? and log_id=?", whereArgs: [note.id, log.id]))
            .length ==
        0)
      await db.insert(note.getTableOfLogs(), {
        "note_id": note.id,
        "log_id": log.id,
        "savedTs": DateTime.now().millisecondsSinceEpoch,
        "id": id
      });
  }

  @override
  Future<void> addLinkTagToNote(NoteModel note, TagModel tag, int id) async {
    final db = await nativeDb.database;
    if ((await db.query(note.getTableOfTags(),
                where: "note_id=? and tag_id=?", whereArgs: [note.id, tag.id]))
            .length ==
        0)
      await db.insert(note.getTableOfTags(), {
        "note_id": note.id,
        "tag_id": tag.id,
        "savedTs": DateTime.now().millisecondsSinceEpoch,
        "id": id
      });
  }

  @override
  Future<void> addNote(NoteModel note) async {
    final db = await nativeDb.database;
    if ((await db.query(note.getTable(), where: "id= ?", whereArgs: [note.id]))
            .length ==
        0)
      await db.insert(note.getTable(), note.toMap());
    else
      await db.update(note.getTable(), note.toMap(),
          where: "id = ?", whereArgs: [note.id]);
  }

  @override
  Future<void> addTextboxBlock(TextboxBlock textbox) async {
    final db = await nativeDb.database;
    if ((await db.query(textbox.getTable(),
                where: "id= ?", whereArgs: [textbox.id]))
            .length ==
        0)
      await db.insert(textbox.getTable(), textbox.toMap());
    else
      await db.update(textbox.getTable(), textbox.toMap(),
          where: "id = ?", whereArgs: [textbox.id]);
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
  Future<List<NoteModel>> getAllNotes() async {
    final db = await nativeDb.database;
    NoteModel note = new NoteModel();
    List<Map<String, dynamic>> result;

    result = await db.query(note.getTable(), orderBy: "savedTs DESC");
    List<NoteModel> items = result.isNotEmpty
        ? result.map((item) => NoteModel.fromMap(item)).toList()
        : [];
    return items;
  }

  @override
  Future<List<BlockInfo>> getBlocksOfNote(NoteModel note) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;

    result = await db.rawQuery(
        "SELECT t.* FROM BlockInfo t INNER JOIN ${note.getTableOfBlocks()} gt ON gt.block_id = t.id WHERE note_id=${note.id} ORDER BY position ASC");
    print(result.length.toString() + "  blocks.......");
    List<BlockInfo> items = result.isNotEmpty
        ? result.map((item) => BlockInfo.fromMap(item)).toList()
        : [];
    return items;
  }

  @override
  Future<List<LogModel>> getLogsOfNote(NoteModel note) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;

    result = await db.rawQuery(
        "SELECT t.* FROM Logs t INNER JOIN ${note.getTableOfLogs()} gt ON gt.log_id = t.id WHERE note_id=${note.id}");

    List<LogModel> items = result.isNotEmpty
        ? result.map((item) => LogModel.fromMap(item)).toList()
        : [];
    return items;
  }

  @override
  Future<List<TagModel>> getTagsOfNote(NoteModel note) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;

    result = await db.rawQuery(
        "SELECT t.* FROM Tags t INNER JOIN ${note.getTableOfTags()} gt ON gt.tag_id = t.id WHERE note_id=${note.id}");

    List<TagModel> items = result.isNotEmpty
        ? result.map((item) => TagModel.fromMap(item)).toList()
        : [];
    return items;
  }

  @override
  Future<TextboxBlock> getTextboxBlock(int id) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;
    TextboxBlock t = new TextboxBlock();
    DateTime d = DateTime.now();

    result = await db.query(t.getTable(), where: "id=?", whereArgs: [id]);
    List<TextboxBlock> block = result.isNotEmpty
        ? result.map((item) => TextboxBlock.fromMap(item)).toList()
        : [TextboxBlock.startTextbox(d.millisecondsSinceEpoch, "Note block")];
    return block[0];
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
    final db = await nativeDb.database;
    if ((await db.query(blockInfo.getTable(),
                where: "id= ?", whereArgs: [blockInfo.id]))
            .length >
        0) {
      await db.update(blockInfo.getTable(), blockInfo.toMap(),
          where: "id = ?", whereArgs: [blockInfo.id]);
      print("updateBlockInfo Updated");
    }
  }

  @override
  Future<void> updateNote(NoteModel note) async {
    print("reena  " + note.toString());
    final db = await nativeDb.database;
    if ((await db.query(note.getTable(), where: "id= ?", whereArgs: [note.id]))
            .length >
        0) {
      await db.update(note.getTable(), note.toMap(),
          where: "id = ?", whereArgs: [note.id]);
      print("note Updated");
    }
  }

  @override
  Future<void> updateTextboxBlock(TextboxBlock textbox) async {
    final db = await nativeDb.database;
    if ((await db.query(textbox.getTable(),
                where: "id= ?", whereArgs: [textbox.id]))
            .length >
        0) {
      await db.update(textbox.getTable(), textbox.toMap(),
          where: "id = ?", whereArgs: [textbox.id]);
      print("textbox Updated");
    }
  }

  @override
  Future<ImageBlock> getImageBlock(int id) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;
    ImageBlock t = new ImageBlock();
    DateTime d = DateTime.now();

    result = await db.query(t.getTable(), where: "id=?", whereArgs: [id]);
    List<ImageBlock> block = result.isNotEmpty
        ? result.map((item) => ImageBlock.fromMap(item)).toList()
        : [
            ImageBlock(
                id: d.millisecondsSinceEpoch,
                url: "https://picsum.photos/800/500")
          ];
    return block[0];
  }

  @override
  Future<void> addImageBlock(ImageBlock imageblock) async {
    final db = await nativeDb.database;
    print("shreyash " + imageblock.url);
    if ((await db.query(imageblock.getTable(),
                where: "id= ?", whereArgs: [imageblock.id]))
            .length ==
        0) {
      print("shreyash " + "inserted");
      await db.insert(imageblock.getTable(), imageblock.toMap());
      print("shreyash " + "inserted");
    } else {
      print("shreyash else " + imageblock.url);
      await db.update(imageblock.getTable(), imageblock.toMap(),
          where: "id = ?", whereArgs: [imageblock.id]);
    }
  }

  @override
  Future<void> addCalendarEvent(CalendarEventBlock item) async {
    final db = await nativeDb.database;
    if ((await db.query(item.getTable(), where: "id= ?", whereArgs: [item.id]))
            .length ==
        0)
      await db.insert(item.getTable(), item.toMap());
    else
      await db.update(item.getTable(), item.toMap(),
          where: "id = ?", whereArgs: [item.id]);
  }

  @override
  Future<void> addCalendarItem(CalendarBlock item) async {
    final db = await nativeDb.database;
    if ((await db.query(item.getTable(), where: "id= ?", whereArgs: [item.id]))
            .length ==
        0)
      await db.insert(item.getTable(), item.toMap());
    else
      await db.update(item.getTable(), item.toMap(),
          where: "id = ?", whereArgs: [item.id]);
  }

  @override
  Future<void> addCheckbox(TodoItemModel item) async {
    final db = await nativeDb.database;
    if ((await db.query(item.getTable(), where: "id= ?", whereArgs: [item.id]))
            .length ==
        0)
      await db.insert(item.getTable(), item.toMap());
    else
      await db.update(item.getTable(), item.toMap(),
          where: "id = ?", whereArgs: [item.id]);
  }

  @override
  Future<void> addColossal(ColossalBlock colossal) async {
    final db = await nativeDb.database;
    if ((await db.query(colossal.getTable(),
                where: "id= ?", whereArgs: [colossal.id]))
            .length ==
        0)
      await db.insert(colossal.getTable(), colossal.toMap());
    else
      await db.update(colossal.getTable(), colossal.toMap(),
          where: "id = ?", whereArgs: [colossal.id]);
  }

  @override
  Future<void> addFormField(FormFieldBlock formfield) async {
    final db = await nativeDb.database;
    if ((await db.query(formfield.getTable(),
                where: "id= ?", whereArgs: [formfield.id]))
            .length ==
        0)
      await db.insert(formfield.getTable(), formfield.toMap());
    else
      await db.update(formfield.getTable(), formfield.toMap(),
          where: "id = ?", whereArgs: [formfield.id]);
  }

  @override
  Future<void> addSequence(SequenceBlock sequence) async {
    final db = await nativeDb.database;
    if ((await db.query(sequence.getTable(),
                where: "id= ?", whereArgs: [sequence.id]))
            .length ==
        0)
      await db.insert(sequence.getTable(), sequence.toMap());
    else
      await db.update(sequence.getTable(), sequence.toMap(),
          where: "id = ?", whereArgs: [sequence.id]);
  }

  @override
  Future<void> addSlider(SliderBlock slider) async {
    final db = await nativeDb.database;
    if ((await db.query(slider.getTable(),
                where: "id= ?", whereArgs: [slider.id]))
            .length ==
        0)
      await db.insert(slider.getTable(), slider.toMap());
    else
      await db.update(slider.getTable(), slider.toMap(),
          where: "id = ?", whereArgs: [slider.id]);
  }

  @override
  Future<void> addTable(TableBlock table) async {
    final db = await nativeDb.database;
    if ((await db
                .query(table.getTable(), where: "id= ?", whereArgs: [table.id]))
            .length ==
        0)
      await db.insert(table.getTable(), table.toMap());
    else
      await db.update(table.getTable(), table.toMap(),
          where: "id = ?", whereArgs: [table.id]);
  }

  @override
  Future<void> addTableColumn(ColumnBlock col) async {
    final db = await nativeDb.database;
    if ((await db.query(col.getTable(), where: "id= ?", whereArgs: [col.id]))
            .length ==
        0)
      await db.insert(col.getTable(), col.toMap());
    else
      await db.update(col.getTable(), col.toMap(),
          where: "id = ?", whereArgs: [col.id]);
  }

  @override
  Future<void> addTableItem(TableItemBlock item) async {
    final db = await nativeDb.database;
    if ((await db.query(item.getTable(), where: "id= ?", whereArgs: [item.id]))
            .length ==
        0)
      await db.insert(item.getTable(), item.toMap());
    else
      await db.update(item.getTable(), item.toMap(),
          where: "id = ?", whereArgs: [item.id]);
  }

  @override
  Future<void> addYoutubeVideo(YoutubeBlock item) async {
    final db = await nativeDb.database;
    if ((await db.query(item.getTable(), where: "id= ?", whereArgs: [item.id]))
            .length ==
        0)
      await db.insert(item.getTable(), item.toMap());
    else
      await db.update(item.getTable(), item.toMap(),
          where: "id = ?", whereArgs: [item.id]);
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
  Future<CalendarBlock> getCalendarBlock(int id) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;
    CalendarBlock t = new CalendarBlock();
    DateTime d = DateTime.now();

    result = await db.query(t.getTable(), where: "id=?", whereArgs: [id]);
    List<CalendarBlock> block = result.isNotEmpty
        ? result.map((item) => CalendarBlock.fromMap(item)).toList()
        : [
            CalendarBlock(
              id: d.millisecondsSinceEpoch,
            )
          ];
    return block[0];
  }

  @override
  Future<List<CalendarEventBlock>> getCalendarEventBlock(
      int id, DateTime startDay, DateTime endDay) async {
    final db = await nativeDb.database;
    print("shreyash");
    print(startDay.millisecondsSinceEpoch);
    print(endDay.millisecondsSinceEpoch);
    List<Map<String, dynamic>> result;
    CalendarEventBlock t = new CalendarEventBlock();
    DateTime d = DateTime.now();

    result = await db.query(t.getTable(),
        where: "calId=? and date>=? and date<=?",
        whereArgs: [
          id,
          startDay.millisecondsSinceEpoch,
          endDay.millisecondsSinceEpoch
        ]);
    List<CalendarEventBlock> block = result.isNotEmpty
        ? result.map((item) => CalendarEventBlock.fromMap(item)).toList()
        : [];
    return block;
  }

  @override
  Future<ColossalBlock> getColossalBlock(int id) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;
    ColossalBlock t = new ColossalBlock();
    DateTime d = DateTime.now();

    result = await db.query(t.getTable(), where: "id=?", whereArgs: [id]);
    List<ColossalBlock> block = result.isNotEmpty
        ? result.map((item) => ColossalBlock.fromMap(item)).toList()
        : [
            ColossalBlock(
              id: d.millisecondsSinceEpoch,
            )
          ];
    return block[0];
  }

  @override
  Future<List<ColumnBlock>> getColumnsOfTable(int id) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;
    ColumnBlock t = new ColumnBlock();
    DateTime d = DateTime.now();

    result = await db.query(t.getTable(), where: "tableId=?", whereArgs: [id]);
    List<ColumnBlock> block = result.isNotEmpty
        ? result.map((item) => ColumnBlock.fromMap(item)).toList()
        : [
            ColumnBlock(
              id: d.millisecondsSinceEpoch,
            )
          ];
    return block;
  }

  @override
  Future<FormFieldBlock> getFormFieldBlock(int id) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;
    FormFieldBlock t = new FormFieldBlock();
    DateTime d = DateTime.now();

    result = await db.query(t.getTable(), where: "id=?", whereArgs: [id]);
    List<FormFieldBlock> block = result.isNotEmpty
        ? result.map((item) => FormFieldBlock.fromMap(item)).toList()
        : [
            FormFieldBlock(
              id: d.millisecondsSinceEpoch,
            )
          ];
    return block[0];
  }

  @override
  Future<List<ImageBlock>> getImagesOfColossal(int id) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;
    ImageBlock t = new ImageBlock();
    DateTime d = DateTime.now();

    result =
        await db.query(t.getTable(), where: "colossalId=?", whereArgs: [id]);
    List<ImageBlock> block = result.isNotEmpty
        ? result.map((item) => ImageBlock.fromMap(item)).toList()
        : [];
    return block;
  }

  @override
  Future<List<TableItemBlock>> getItemsOfColumnsOfTable(int id) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;
    TableItemBlock t = new TableItemBlock();
    DateTime d = DateTime.now();

    result = await db.query(t.getTable(), where: "colId=?", whereArgs: [id]);
    List<TableItemBlock> block = result.isNotEmpty
        ? result.map((item) => TableItemBlock.fromMap(item)).toList()
        : [
            TableItemBlock(
              id: d.millisecondsSinceEpoch,
            )
          ];
    return block;
  }

  @override
  Future<SequenceBlock> getSequenceBlock(int id) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;
    SequenceBlock t = new SequenceBlock();
    DateTime d = DateTime.now();

    result = await db.query(t.getTable(), where: "id=?", whereArgs: [id]);
    List<SequenceBlock> block = result.isNotEmpty
        ? result.map((item) => SequenceBlock.fromMap(item)).toList()
        : [
            SequenceBlock(
              id: d.millisecondsSinceEpoch,
            )
          ];
    return block[0];
  }

  @override
  Future<SliderBlock> getSliderBlock(int id) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;
    SliderBlock t = new SliderBlock();
    DateTime d = DateTime.now();

    result = await db.query(t.getTable(), where: "id=?", whereArgs: [id]);
    List<SliderBlock> block = result.isNotEmpty
        ? result.map((item) => SliderBlock.fromMap(item)).toList()
        : [
            SliderBlock(
              id: d.millisecondsSinceEpoch,
            )
          ];
    return block[0];
  }

  @override
  Future<TableBlock> getTableBlock(int id) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;
    TableBlock t = new TableBlock();
    DateTime d = DateTime.now();

    result = await db.query(t.getTable(), where: "id=?", whereArgs: [id]);
    List<TableBlock> block = result.isNotEmpty
        ? result.map((item) => TableBlock.fromMap(item)).toList()
        : [
            TableBlock(
              id: d.millisecondsSinceEpoch,
            )
          ];
    return block[0];
  }

  @override
  Future<YoutubeBlock> getYoutubeVideoBlock(int id) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;
    YoutubeBlock t = new YoutubeBlock();
    DateTime d = DateTime.now();

    result = await db.query(t.getTable(), where: "id=?", whereArgs: [id]);
    List<YoutubeBlock> block = result.isNotEmpty
        ? result.map((item) => YoutubeBlock.fromMap(item)).toList()
        : [
            YoutubeBlock(
              id: d.millisecondsSinceEpoch,
            )
          ];
    return block[0];
  }

  @override
  Future<void> updateCalendarEvent(CalendarEventBlock item) async {
    final db = await nativeDb.database;
    if ((await db.query(item.getTable(), where: "id= ?", whereArgs: [item.id]))
            .length >
        0) {
      await db.update(item.getTable(), item.toMap(),
          where: "id = ?", whereArgs: [item.id]);
      print("note Updated");
    }
  }

  @override
  Future<void> updateCalendarItem(CalendarBlock item) async {
    final db = await nativeDb.database;
    if ((await db.query(item.getTable(), where: "id= ?", whereArgs: [item.id]))
            .length >
        0) {
      await db.update(item.getTable(), item.toMap(),
          where: "id = ?", whereArgs: [item.id]);
      print("note Updated");
    }
  }

  @override
  Future<void> updateCheckbox(TodoItemModel item) async {
    final db = await nativeDb.database;
    if ((await db.query(item.getTable(), where: "id= ?", whereArgs: [item.id]))
            .length >
        0) {
      await db.update(item.getTable(), item.toMap(),
          where: "id = ?", whereArgs: [item.id]);
      print("note Updated");
    }
  }

  @override
  Future<void> updateColossal(ColossalBlock item) async {
    final db = await nativeDb.database;
    if ((await db.query(item.getTable(), where: "id= ?", whereArgs: [item.id]))
            .length >
        0) {
      await db.update(item.getTable(), item.toMap(),
          where: "id = ?", whereArgs: [item.id]);
      print("note Updated");
    }
  }

  @override
  Future<void> updateFormField(FormFieldBlock item) async {
    final db = await nativeDb.database;
    if ((await db.query(item.getTable(), where: "id= ?", whereArgs: [item.id]))
            .length >
        0) {
      await db.update(item.getTable(), item.toMap(),
          where: "id = ?", whereArgs: [item.id]);
      print("note Updated");
    }
  }

  @override
  Future<void> updateSequence(SequenceBlock item) async {
    final db = await nativeDb.database;
    if ((await db.query(item.getTable(), where: "id= ?", whereArgs: [item.id]))
            .length >
        0) {
      await db.update(item.getTable(), item.toMap(),
          where: "id = ?", whereArgs: [item.id]);
      print("note Updated");
    }
  }

  @override
  Future<void> updateSlider(SliderBlock item) async {
    final db = await nativeDb.database;
    if ((await db.query(item.getTable(), where: "id= ?", whereArgs: [item.id]))
            .length >
        0) {
      await db.update(item.getTable(), item.toMap(),
          where: "id = ?", whereArgs: [item.id]);
      print("note Updated");
    }
  }

  @override
  Future<void> updateTable(TableBlock item) async {
    final db = await nativeDb.database;
    if ((await db.query(item.getTable(), where: "id= ?", whereArgs: [item.id]))
            .length >
        0) {
      await db.update(item.getTable(), item.toMap(),
          where: "id = ?", whereArgs: [item.id]);
      print("note Updated");
    }
  }

  @override
  Future<void> updateTableColumn(ColumnBlock item) async {
    final db = await nativeDb.database;
    print(item.toString() + "  helo");
    print(item.tableId.toString() + "  helo");
    if ((await db.query(item.getTable(), where: "id = ?", whereArgs: [item.id]))
            .length >
        0) {
      print(item.toString() + "  helo");
      await db.update(item.getTable(), item.toMap(),
          where: "id = ?", whereArgs: [item.id]);
      print("ColumnBlock Updated");
    }
  }

  @override
  Future<void> updateTableItem(TableItemBlock item) async {
    final db = await nativeDb.database;
    if ((await db.query(item.getTable(), where: "id= ?", whereArgs: [item.id]))
            .length >
        0) {
      await db.update(item.getTable(), item.toMap(),
          where: "id = ?", whereArgs: [item.id]);
      print("note Updated");
    }
  }

  @override
  Future<void> updateYoutubeVideo(YoutubeBlock item) async {
    final db = await nativeDb.database;
    if ((await db.query(item.getTable(), where: "id= ?", whereArgs: [item.id]))
            .length >
        0) {
      await db.update(item.getTable(), item.toMap(),
          where: "id = ?", whereArgs: [item.id]);
      print("note Updated");
    }
  }

  @override
  Future<void> deleteImageBlock(ImageBlock imageblock) {
    // TODO: implement deleteImageBlock
    throw UnimplementedError();
  }

  @override
  Future<void> updateImageBlock(ImageBlock item) async {
    final db = await nativeDb.database;
    if ((await db.query(item.getTable(), where: "id= ?", whereArgs: [item.id]))
            .length >
        0) {
      await db.update(item.getTable(), item.toMap(),
          where: "id = ?", whereArgs: [item.id]);
      print("ImageBlock Updated");
    }
  }

  @override
  Future<List<NoteModel>> getNotesOfNotebook(int notebookId) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;
    NoteModel t = new NoteModel();
    DateTime d = DateTime.now();

    result = await db
        .query(t.getTable(), where: "notebookId=?", whereArgs: [notebookId]);
    List<NoteModel> items = result.isNotEmpty
        ? result.map((item) => NoteModel.fromMap(item)).toList()
        : [];
    return items;
  }
}
