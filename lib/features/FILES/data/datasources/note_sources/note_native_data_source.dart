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
import 'package:sorted/features/FILES/data/models/block_image.dart';
import 'package:sorted/features/FILES/data/models/block_info.dart';
import 'package:sorted/features/FILES/data/models/block_textbox.dart';
import 'package:sorted/features/FILES/data/models/note_model.dart';

import 'package:sorted/features/HOME/data/models/inspiration.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:sorted/features/HOME/data/models/placeholder_info.dart';
import 'package:sorted/features/HOME/domain/entities/unsplash_image.dart';
import 'package:sorted/features/PLAN/data/models/goal.dart';
import 'package:sorted/features/PLAN/data/models/task.dart';
import 'package:sorted/features/PLAN/data/models/task_status.dart';

abstract class NoteNative {
  Future<void> addNote(NoteModel note);
  Future<void> updateNote(NoteModel note);
  Future<void> deleteNote(NoteModel note);
  Future<void> addTextboxBlock(TextboxBlock textbox);
  Future<void> addImageBlock(ImageBlock imageblock);
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
  Future<TextboxBlock> getTextboxBlock(int id);
  Future<ImageBlock> getImageBlock(int id);
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
        "SELECT t.* FROM BlockInfo t INNER JOIN ${note.getTableOfBlocks()} gt ON gt.block_id = t.id WHERE note_id=${note.id}");
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
}
