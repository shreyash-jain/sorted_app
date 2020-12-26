import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:faker/faker.dart';
import 'package:meta/meta.dart';

import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/database/sqflite_init.dart';
import 'package:sorted/core/global/models/attachment.dart';
import 'package:sorted/core/global/models/image.dart';
import 'package:sorted/core/global/models/link.dart';
import 'package:sorted/core/global/models/log.dart';
import 'package:sorted/core/global/models/tag.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/data/models/inspiration.dart';
import 'package:sorted/features/HOME/data/models/placeholder_info.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:sorted/features/HOME/domain/entities/unsplash_image.dart';

abstract class AttachmentsNative {
  Future<ImageModel> addImage(ImageModel image);
  Future<void> deleteImage(ImageModel image);
  Future<LinkModel> addLink(LinkModel link);
  Future<void> deleteLink(LinkModel link);
  Future<LogModel> addLog(LogModel log);
  Future<void> deleteLog(LogModel log);
  Future<TagModel> addTag(TagModel tag);
  Future<TagModel> updateTag(TagModel tag);
  Future<void> deleteTag(TagModel tag);
  Future<AttachmentModel> addAttachment(AttachmentModel attachment);
  Future<void> deleteAttachment(AttachmentModel attachment);
  Future<List<TagModel>> get allTags;
  Future<TagModel> getTagByName(String tagName);
  Future<LinkModel> getLink(int linkId);
}

class AttachmentNativeDataSourceImpl extends Equatable
    implements AttachmentsNative {
  final SqlDatabaseService nativeDb;

  AttachmentNativeDataSourceImpl({@required this.nativeDb});

  @override
  Future<AttachmentModel> addAttachment(AttachmentModel attachment) async {
    final db = await nativeDb.database;
    if ((await db.query(attachment.getTable(),
                where: "id= ?", whereArgs: [attachment.id]))
            .length ==
        0)
      await db.insert(attachment.getTable(), attachment.toMap());
    else
      await db.update(attachment.getTable(), attachment.toMap(),
          where: "id = ?", whereArgs: [attachment.id]);
  }

  @override
  Future<ImageModel> addImage(ImageModel image) async {
    final db = await nativeDb.database;
    if ((await db
                .query(image.getTable(), where: "id= ?", whereArgs: [image.id]))
            .length ==
        0)
      await db.insert(image.getTable(), image.toMap());
    else
      await db.update(image.getTable(), image.toMap(),
          where: "id = ?", whereArgs: [image.id]);
  }

  @override
  Future<LinkModel> addLink(LinkModel link) async {
    final db = await nativeDb.database;
    if ((await db.query(link.getTable(), where: "id= ?", whereArgs: [link.id]))
            .length ==
        0)
      await db.insert(link.getTable(), link.toMap());
    else
      await db.update(link.getTable(), link.toMap(),
          where: "id = ?", whereArgs: [link.id]);
  }

  @override
  Future<LogModel> addLog(LogModel log) async {
    final db = await nativeDb.database;
    if ((await db.query(log.getTable(), where: "id= ?", whereArgs: [log.id]))
            .length ==
        0)
      await db.insert(log.getTable(), log.toMap());
    else
      await db.update(log.getTable(), log.toMap(),
          where: "id = ?", whereArgs: [log.id]);
  }

  @override
  Future<TagModel> addTag(TagModel tag) async {
    final db = await nativeDb.database;
    if ((await db.query(tag.getTable(), where: "id= ?", whereArgs: [tag.id]))
            .length ==
        0)
      await db.insert(tag.getTable(), tag.toMap());
    else
      await db.update(tag.getTable(), tag.toMap(),
          where: "id = ?", whereArgs: [tag.id]);
  }

  @override
  Future<void> deleteAttachment(AttachmentModel attachment) async {
    final db = await nativeDb.database;
    if ((await db.query(attachment.getTable(),
                where: "id=?", whereArgs: [attachment.id]))
            .length >
        0)
      await db.delete(attachment.getTable(),
          where: "id=?", whereArgs: [attachment.id]);
  }

  @override
  Future<void> deleteImage(ImageModel image) async {
    final db = await nativeDb.database;
    if ((await db.query(image.getTable(), where: "id=?", whereArgs: [image.id]))
            .length >
        0)
      await db.delete(image.getTable(), where: "id=?", whereArgs: [image.id]);
  }

  @override
  Future<void> deleteLink(LinkModel link) async {
    final db = await nativeDb.database;
    if ((await db.query(link.getTable(), where: "id=?", whereArgs: [link.id]))
            .length >
        0)
      await db.delete(link.getTable(), where: "id=?", whereArgs: [link.id]);
  }

  @override
  Future<void> deleteLog(LogModel log) async {
    final db = await nativeDb.database;
    if ((await db.query(log.getTable(), where: "id=?", whereArgs: [log.id]))
            .length >
        0) await db.delete(log.getTable(), where: "id=?", whereArgs: [log.id]);
  }

  @override
  Future<void> deleteTag(TagModel tag) async {
    final db = await nativeDb.database;
    if ((await db.query(tag.getTable(), where: "id=?", whereArgs: [tag.id]))
            .length >
        0) await db.delete(tag.getTable(), where: "id=?", whereArgs: [tag.id]);
  }

  @override
  Future<List<TagModel>> get allTags async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;
    TagModel t = new TagModel();

    result = await db.query(t.getTable(), orderBy: "items DESC");

    List<TagModel> tags = result.isNotEmpty
        ? result.map((item) => TagModel.fromMap(item)).toList()
        : [];
    return tags;
  }

  @override
  Future<TagModel> getTagByName(String tagName) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;
    TagModel t = new TagModel();

    result = await db.query(t.getTable(), where: "tag=?", whereArgs: [tagName]);
    List<TagModel> tags = result.isNotEmpty
        ? result.map((item) => TagModel.fromMap(item)).toList()
        : [TagModel(tag: "None")];
    return tags[0];
  }

  @override
  Future<TagModel> updateTag(TagModel tag) async {
    final db = await nativeDb.database;
    if ((await db.query(tag.getTable(), where: "id= ?", whereArgs: [tag.id]))
            .length >
        0) {
      await db.update(tag.getTable(), tag.toMap(),
          where: "id = ?", whereArgs: [tag.id]);
      print("tag Updated");
    }
    return tag;
  }

  @override
  List<Object> get props => [nativeDb];

  @override
  Future<LinkModel> getLink(int linkId) async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;
    LinkModel t = new LinkModel();

    result = await db.query(t.getTable(), where: "id=?", whereArgs: [linkId]);
    List<LinkModel> tags = result.isNotEmpty
        ? result.map((item) => LinkModel.fromMap(item)).toList()
        : [LinkModel(id: 0)];
    return tags[0];
  }
}
