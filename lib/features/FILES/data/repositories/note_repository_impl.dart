import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:dartz/dartz_streaming.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/database/datasources/attachments_sources/attachments_cloud_data_source.dart';
import 'package:sorted/core/global/database/datasources/attachments_sources/attachments_native_data_source.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/models/image.dart';
import 'package:sorted/core/global/models/link.dart';
import 'package:sorted/core/global/models/log.dart';
import 'package:sorted/core/network/network_info.dart';
import 'package:sorted/features/FILES/data/datasources/note_sources/note_cloud_data_source.dart';
import 'package:sorted/features/FILES/data/datasources/note_sources/note_native_data_source.dart';
import 'package:sorted/features/FILES/data/datasources/note_sources/note_shared_pref_data_source.dart';
import 'package:sorted/features/FILES/data/models/block_form_field.dart';
import 'package:sorted/features/FILES/data/models/block_column.dart';
import 'package:sorted/features/FILES/data/models/block_calendar_event.dart';
import 'package:sorted/features/FILES/data/models/block_calendar.dart';
import 'package:sorted/features/FILES/data/models/block_image.dart';
import 'package:sorted/features/FILES/data/models/block_youtube.dart';
import 'package:sorted/features/FILES/data/models/block_table_item.dart';
import 'package:sorted/features/FILES/data/models/block_table.dart';
import 'package:sorted/features/FILES/data/models/block_slider.dart';
import 'package:sorted/features/FILES/data/models/block_sequence.dart';
import 'package:sorted/features/FILES/data/models/block_image_colossal.dart';
import 'package:sorted/features/FILES/data/models/note_model.dart';
import 'package:sorted/features/FILES/data/models/block_textbox.dart';
import 'package:sorted/features/FILES/data/models/block_info.dart';
import 'package:sorted/features/FILES/domain/repositories/note_repository.dart';
import 'package:sorted/features/FILES/presentation/widgets/todo_item_menu.dart';

import 'package:sorted/features/HOME/data/datasources/home_cloud_data_source.dart';
import 'package:sorted/features/HOME/data/datasources/home_native_data_source.dart';
import 'package:sorted/features/HOME/data/datasources/home_remote_api_data_source.dart';
import 'package:sorted/features/HOME/data/datasources/home_shared_pref_data_source.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/data/models/inspiration.dart';
import 'package:sorted/features/HOME/data/models/placeholder_info.dart' as ph;
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:sorted/features/HOME/domain/entities/display_thumbnail.dart';
import 'package:sorted/features/HOME/domain/entities/unsplash_image.dart';
import 'package:sorted/features/HOME/domain/repositories/home_repository.dart';
import 'package:sorted/features/PLAN/data/datasources/goal_sources/goal_cloud_data_source.dart';
import 'package:sorted/features/PLAN/data/datasources/goal_sources/goal_native_data_source.dart';
import 'package:sorted/features/PLAN/data/datasources/goal_sources/goal_shared_pref_data_source.dart';
import 'package:sorted/features/PLAN/data/datasources/task_sources/task_cloud_data_source.dart';
import 'package:sorted/features/PLAN/data/datasources/task_sources/task_native_data_source.dart';
import 'package:sorted/features/PLAN/data/models/goal.dart';
import 'package:sorted/features/PLAN/data/models/task_status.dart';
import 'package:sorted/features/PLAN/data/models/todo_item.dart';
import 'package:sorted/features/PLAN/domain/repositories/goal_repository.dart';
import 'package:zefyr/zefyr.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteCloud remoteNoteDataSource;
  final NoteNative nativeNoteDataSource;
  final NoteSharedPref sharedPrefNote;
  final NetworkInfo networkInfo;
  final AttachmentsCloud remoteAttachmentDataSource;
  final AttachmentsNative nativeAttachmentDataSource;

  final _random = new Random();

  NoteRepositoryImpl(
      {@required this.remoteNoteDataSource,
      @required this.nativeNoteDataSource,
      @required this.networkInfo,
      @required this.sharedPrefNote,
      @required this.remoteAttachmentDataSource,
      @required this.nativeAttachmentDataSource});

  @override
  Future<Either<Failure, void>> removeGoal(GoalModel goal) {
    // TODO: implement removeGoal
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, ImageModel>> storeImage(
      ImageModel image, File file) async {
    try {
      return Right(
          await remoteAttachmentDataSource.storeImage(file, "images", image));
    } catch (e) {
      print("error 2 " + e.toString());
      print("error 2");
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, BlockInfo>> addBlockInfo(BlockInfo block) async {
    DateTime now = DateTime.now();
    try {
      await nativeNoteDataSource.addBlockInfo(block);

      try {
        remoteNoteDataSource.addBlockInfo(block);
      } on Exception {
        return Left(ServerFailure());
      }
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, NoteModel>> addNote(NoteModel note) async {
    DateTime now = DateTime.now();
    note = note.copyWith(startDate: now.millisecondsSinceEpoch);

    note = note.copyWith(numLogs: note.numLogs + 1);
    try {
      await nativeNoteDataSource.addNote(note);

      LogModel noteLog = LogModel(
          id: now.millisecondsSinceEpoch,
          level: 0,
          connectedId: note.id,
          savedTs: now,
          message: "Created this note",
          date: now,
          type: 2,
          path: note.noteEmoji);
      nativeAttachmentDataSource.addLog(noteLog).then((value) {
        remoteAttachmentDataSource.addLog(noteLog);
        nativeNoteDataSource
            .addLinkLogToNote(note, noteLog, now.millisecondsSinceEpoch)
            .then((value) {
          remoteNoteDataSource.addLinkLogToNote(
              note, noteLog, now.millisecondsSinceEpoch);
        });
      });

      try {
        remoteNoteDataSource.addNote(note);
      } on Exception {
        return Left(ServerFailure());
      }
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, TextboxBlock>> addTextbox(TextboxBlock textbox) async {
    DateTime now = DateTime.now();
    try {
      await nativeNoteDataSource.addTextboxBlock(textbox);

      try {
        remoteNoteDataSource.addTextboxBlock(textbox);
      } on Exception {
        return Left(ServerFailure());
      }
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, List<BlockInfo>>> getBlocksOfNote(
      NoteModel note) async {
    List<BlockInfo> blocks = [];
    Failure failure;
    try {
      blocks = await nativeNoteDataSource.getBlocksOfNote(note);
      return Right(blocks);
    } on Exception {
      Left(NativeDatabaseException());
    }
    return Right(blocks);
  }

  @override
  Future<Either<Failure, List<NoteModel>>> getNotes() async {
    Failure failure;
    try {
      return (Right(await nativeNoteDataSource.getAllNotes()));
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, TextboxBlock>> getTextboxOfId(int id) async {
    try {
      return (Right(await nativeNoteDataSource.getTextboxBlock(id)));
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, void>> removeNote(NoteModel note) {
    // TODO: implement removeNote
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, BlockInfo>> updateBlockInfo(BlockInfo block) async {
    try {
      await nativeNoteDataSource.updateBlockInfo(block);
      try {
        remoteNoteDataSource.updateBlockInfo(block);
        return Right(block);
      } on Exception {
        return Left(ServerFailure());
      }
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, NoteModel>> updateNote(NoteModel note) async {
    try {
      await nativeNoteDataSource.updateNote(note);
      try {
        remoteNoteDataSource.updateNote(note);
        return Right(note);
      } on Exception {
        return Left(ServerFailure());
      }
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, TextboxBlock>> updateTextbox(
      TextboxBlock textbox) async {
    try {
      await nativeNoteDataSource.updateTextboxBlock(textbox);
      try {
        remoteNoteDataSource.updateTextboxBlock(textbox);
        return Right(textbox);
      } on Exception {
        return Left(ServerFailure());
      }
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, void>> linkNoteAndBlock(
      NoteModel note, BlockInfo block, int id) async {
    DateTime now = DateTime.now();
    try {
      note = note.copyWith(numLogs: note.numLogs + 1);
      note = note.copyWith(numBlocks: note.numBlocks + 1);
      nativeNoteDataSource.updateNote(note).then((value) {
        remoteNoteDataSource.updateNote(note);
      });
      await nativeNoteDataSource.addLinkBlockToNote(
          note, block, now.millisecondsSinceEpoch);

      LogModel noteLog = LogModel(
          id: now.millisecondsSinceEpoch + 1,
          level: 1,
          connectedId: note.id,
          message: "Added block ${block.type}",
          savedTs: now,
          date: now,
          type: 2,
          path: note.noteEmoji);
      nativeAttachmentDataSource.addLog(noteLog).then((value) {
        remoteAttachmentDataSource.addLog(noteLog);
        nativeNoteDataSource
            .addLinkLogToNote(note, noteLog, now.millisecondsSinceEpoch + 1)
            .then((value) {
          remoteNoteDataSource.addLinkLogToNote(
              note, noteLog, now.millisecondsSinceEpoch + 1);
        });
      });
      try {
        remoteNoteDataSource.addLinkBlockToNote(
            note, block, now.millisecondsSinceEpoch);
      } on Exception {
        return Left(ServerFailure());
      }
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, ImageBlock>> getImageOfId(int id) async {
    try {
      return (Right(await nativeNoteDataSource.getImageBlock(id)));
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, void>> addImageBlock(ImageBlock imagebox) async {
    DateTime now = DateTime.now();
    print("shreyash " + imagebox.id.toString());
    try {
      await nativeNoteDataSource.addImageBlock(imagebox);

      try {
        remoteNoteDataSource.addImageBlock(imagebox);
      } on Exception {
        print("Left(ServerFailure())");
        return Left(ServerFailure());
      }
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, void>> addCalendarBlock(CalendarBlock item) async {
    DateTime now = DateTime.now();
    print("adding calendar");
    item = item.copyWith(savedTs: now.millisecondsSinceEpoch);

    try {
      await nativeNoteDataSource.addCalendarItem(item);

      try {
        remoteNoteDataSource.addCalendarItem(item);
      } on Exception {
        print("Left(ServerFailure())");
        return Left(ServerFailure());
      }
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, void>> addCalendarEventBlock(
      CalendarEventBlock item) async {
    DateTime now = DateTime.now();
    item = item.copyWith(savedTs: now.millisecondsSinceEpoch);

    try {
      await nativeNoteDataSource.addCalendarEvent(item);

      try {
        remoteNoteDataSource.addCalendarEvent(item);
      } on Exception {
        print("Left(ServerFailure())");
        return Left(ServerFailure());
      }
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, void>> addCheckboxBlock(TodoItemModel item) async {
    DateTime now = DateTime.now();
    item = item.copyWith(savedTs: now);

    try {
      await nativeNoteDataSource.addCheckbox(item);

      try {
        remoteNoteDataSource.addCheckbox(item);
      } on Exception {
        print("Left(ServerFailure())");
        return Left(ServerFailure());
      }
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, void>> addFormFieldBlock(FormFieldBlock item) async {
    DateTime now = DateTime.now();
    print("shreyash " + item.id.toString());
    item = item.copyWith(savedTs: now.millisecondsSinceEpoch);
    try {
      await nativeNoteDataSource.addFormField(item);

      try {
        remoteNoteDataSource.addFormField(item);
      } on Exception {
        print("Left(ServerFailure())");
        return Left(ServerFailure());
      }
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, void>> addImagesInColossal(
      ColossalBlock colossal, List<ImageBlock> images) async {
    try {
      await nativeNoteDataSource.addColossal(colossal);
      images.forEach((element) async {
        await nativeNoteDataSource.addImageBlock(element);
      });
      try {
        remoteNoteDataSource.addColossal(colossal);
        images.forEach((element) async {
          remoteNoteDataSource.addImageBlock(element);
        });
      } on Exception {
        return Left(ServerFailure());
      }
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, void>> addSequenceBlock(SequenceBlock item) async {
    DateTime now = DateTime.now();
    item = item.copyWith(savedTs: now.millisecondsSinceEpoch);

    try {
      await nativeNoteDataSource.addSequence(item);

      try {
        remoteNoteDataSource.addSequence(item);
      } on Exception {
        print("Left(ServerFailure())");
        return Left(ServerFailure());
      }
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, void>> addSliderBlock(SliderBlock item) async {
    DateTime now = DateTime.now();
    item = item.copyWith(savedTs: now.millisecondsSinceEpoch);

    try {
      await nativeNoteDataSource.addSlider(item);

      try {
        remoteNoteDataSource.addSlider(item);
      } on Exception {
        print("Left(ServerFailure())");
        return Left(ServerFailure());
      }
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, void>> addTableBlock(TableBlock item) async {
    DateTime now = DateTime.now();
    item = item.copyWith(savedTs: now.millisecondsSinceEpoch);

    try {
      await nativeNoteDataSource.addTable(item);

      try {
        remoteNoteDataSource.addTable(item);
      } on Exception {
        print("Left(ServerFailure())");
        return Left(ServerFailure());
      }
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, void>> addTableColumn(ColumnBlock item) async {
    DateTime now = DateTime.now();
    item = item.copyWith(savedTs: now.millisecondsSinceEpoch);

    try {
      await nativeNoteDataSource.addTableColumn(item);

      try {
        remoteNoteDataSource.addTableColumn(item);
      } on Exception {
        print("Left(ServerFailure())");
        return Left(ServerFailure());
      }
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, void>> addTableColumnItem(TableItemBlock item) async {
    DateTime now = DateTime.now();
    item = item.copyWith(savedTs: now.millisecondsSinceEpoch);

    try {
      await nativeNoteDataSource.addTableItem(item);

      try {
        remoteNoteDataSource.addTableItem(item);
      } on Exception {
        print("Left(ServerFailure())");
        return Left(ServerFailure());
      }
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, void>> addYoutubeBlock(YoutubeBlock item) async {
    DateTime now = DateTime.now();
    item = item.copyWith(savedTs: now.millisecondsSinceEpoch);

    try {
      await nativeNoteDataSource.addYoutubeVideo(item);

      try {
        remoteNoteDataSource.addYoutubeVideo(item);
      } on Exception {
        print("Left(ServerFailure())");
        return Left(ServerFailure());
      }
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, CalendarBlock>> getCalendarBlock(int item) async {
    try {
      return (Right(await nativeNoteDataSource.getCalendarBlock(item)));
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, List<CalendarEventBlock>>> getCalendarEventsBlock(
      int item, DateTime startDay, DateTime endDay) async {
    try {
      return (Right(await nativeNoteDataSource.getCalendarEventBlock(
          item, startDay, endDay)));
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, TodoItemModel>> getCheckBox(int checkboxId) {
    // TODO: implement getCheckBox
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, ColossalBlock>> getColossal(int colossalId) async {
    try {
      return (Right(await nativeNoteDataSource.getColossalBlock(colossalId)));
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, FormFieldBlock>> getFormField(int formfieldId) async {
    try {
      return (Right(await nativeNoteDataSource.getFormFieldBlock(formfieldId)));
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, List<ImageBlock>>> getImagesInColossal(
      int colossalId) async {
    try {
      return (Right(
          await nativeNoteDataSource.getImagesOfColossal(colossalId)));
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, SequenceBlock>> getSequence(int item) async {
    try {
      return (Right(await nativeNoteDataSource.getSequenceBlock(item)));
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, SliderBlock>> getSlider(int item) async {
    try {
      return (Right(await nativeNoteDataSource.getSliderBlock(item)));
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, TableBlock>> getTableBlock(int item) async {
    try {
      return (Right(await nativeNoteDataSource.getTableBlock(item)));
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, List<ColumnBlock>>> getTableColumnsBlock(
      int tableId) async {
    try {
      return (Right(await nativeNoteDataSource.getColumnsOfTable(tableId)));
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, List<TableItemBlock>>> getTableColumnsItems(
      int colId) async {
    try {
      return (Right(
          await nativeNoteDataSource.getItemsOfColumnsOfTable(colId)));
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  @override
  Future<Either<Failure, void>> updateImageBlock(ImageBlock item) async {
    try {
      await nativeNoteDataSource.updateImageBlock(item);

      try {
        remoteNoteDataSource.updateImageBlock(item);
      } on Exception {
        return Left(ServerFailure());
      }
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, void>> addLinkBlock(LinkModel item) async {
    DateTime now = DateTime.now();
    item = item.copyWith(savedTs: now);

    try {
      await nativeAttachmentDataSource.addLink(item);

      try {
        remoteAttachmentDataSource.addLink(item);
      } on Exception {
        print("Left(ServerFailure())");
        return Left(ServerFailure());
      }
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, LinkModel>> getLink(int link) async {
    try {
      return (Right(await nativeAttachmentDataSource.getLink(link)));
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, void>> updateFormField(FormFieldBlock item) async {
    try {
      await nativeNoteDataSource.updateFormField(item);

      try {
        remoteNoteDataSource.updateFormField(item);
      } on Exception {
        print("Left(ServerFailure())");
        return Left(ServerFailure());
      }
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, void>> updateCalendarBlock(CalendarBlock item) {
    // TODO: implement updateCalendarBlock
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> updateCalendarEventBlock(
      CalendarEventBlock item) {
    // TODO: implement updateCalendarEventBlock
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> updateCheckboxBlock(TodoItemModel item) {
    // TODO: implement updateCheckboxBlock
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> updateFormFieldBlock(FormFieldBlock item) {
    // TODO: implement updateFormFieldBlock
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> updateLinkBlock(LinkModel link) {
    // TODO: implement updateLinkBlock
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> updateSequenceBlock(SequenceBlock item) async {
    item = item.copyWith(savedTs: DateTime.now().millisecondsSinceEpoch);
    try {
      await nativeNoteDataSource.updateSequence(item);

      try {
        remoteNoteDataSource.updateSequence(item);
      } on Exception {
        print("Left(ServerFailure())");
        return Left(ServerFailure());
      }
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, void>> updateSliderBlock(SliderBlock item) async {
    item = item.copyWith(savedTs: DateTime.now().millisecondsSinceEpoch);
    try {
      await nativeNoteDataSource.updateSlider(item);

      try {
        remoteNoteDataSource.updateSlider(item);
      } on Exception {
        print("Left(ServerFailure())");
        return Left(ServerFailure());
      }
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, void>> updateTableBlock(TableBlock item) async {
    item = item.copyWith(savedTs: DateTime.now().millisecondsSinceEpoch);
    print(item.toString() + "heelo");

    try {
      await nativeNoteDataSource.updateTable(item);

      try {
        remoteNoteDataSource.updateTable(item);
      } on Exception {
        print("Left(ServerFailure())");
        return Left(ServerFailure());
      }
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, void>> updateTableColumn(ColumnBlock item) async {
    item = item.copyWith(savedTs: DateTime.now().millisecondsSinceEpoch);
    print(item.toString() + "heelo");
    print(item.tableId.toString() + "heelo");
    try {
      await nativeNoteDataSource.updateTableColumn(item);

      try {
        remoteNoteDataSource.updateTableColumn(item);
      } on Exception {
        print("Left(ServerFailure())");
        return Left(ServerFailure());
      }
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, void>> updateTableColumnItem(
      TableItemBlock item) async {
    item = item.copyWith(savedTs: DateTime.now().millisecondsSinceEpoch);
    print(item.toString() + "heelo");

    try {
      await nativeNoteDataSource.updateTableItem(item);

      try {
        remoteNoteDataSource.updateTableItem(item);
      } on Exception {
        print("Left(ServerFailure())");
        return Left(ServerFailure());
      }
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, void>> updateYoutubeBlock(YoutubeBlock item) async {
    item = item.copyWith(savedTs: DateTime.now().millisecondsSinceEpoch);
    print(item.toString() + "heelo");

    try {
      await nativeNoteDataSource.updateYoutubeVideo(item);

      try {
        remoteNoteDataSource.updateYoutubeVideo(item);
      } on Exception {
        print("Left(ServerFailure())");
        return Left(ServerFailure());
      }
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, YoutubeBlock>> getYoutube(int id) async {
    try {
      return (Right(await nativeNoteDataSource.getYoutubeVideoBlock(id)));
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, List<NoteModel>>> getNotesOfNotebook(
      int notebookId) async {
    try {
      return (Right(await nativeNoteDataSource.getNotesOfNotebook(notebookId)));
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  NotusDocument _loadDocument(String text) {
    return NotusDocument.fromJson(jsonDecode(text));
  }

  @override
  Future<Either<Failure, String>> getTextOfNote(
      NoteModel note, List<BlockInfo> blocks) async {
    try {
      for (int i = 0; i < blocks.length; i++) {
        if (blocks[i].type == 0) {
          String text = _loadDocument(
                  (await nativeNoteDataSource.getTextboxBlock(blocks[i].itemId))
                      .text)
              .toPlainText();
          return (Right(text));
        }
      }
      return (Right(""));
    } on Exception {
      return (Right(""));
    }
  }

  @override
  Future<Either<Failure, String>> getImageUrlOfNote(
      NoteModel note, List<BlockInfo> blocks) async {
    try {
      for (int i = 0; i < blocks.length; i++) {
        if (blocks[i].type == 2) {
          String url =
              (await nativeNoteDataSource.getImageBlock(blocks[i].itemId)).url;

          return (Right(url));
        }

        if (blocks[i].type == 5) {
          List<ImageBlock> images =
              await nativeNoteDataSource.getImagesOfColossal(blocks[i].itemId);
          if (images.length > 0) return (Right(images[0].url));
        }
      }
      return (Right(""));
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, bool>> getIfNoteHasList(
      NoteModel note, List<BlockInfo> blocks) async {
    try {
      for (int i = 0; i < blocks.length; i++) {
        if (blocks[i].type == 3) {
          return (Right(true));
        }
      }
      return (Right(false));
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, bool>> getIfNoteHasCalendar(
      NoteModel note, List<BlockInfo> blocks) async {
    try {
      for (int i = 0; i < blocks.length; i++) {
        if (blocks[i].type == 11) {
          return (Right(true));
        }
      }
      return (Right(false));
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, bool>> getIfNoteHasLink(
      NoteModel note, List<BlockInfo> blocks) async {
    try {
      for (int i = 0; i < blocks.length; i++) {
        if (blocks[i].type == 5) {
          return (Right(true));
        }
      }
      return (Right(false));
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }

  @override
  Future<Either<Failure, bool>> getIfNoteHasTable(
      NoteModel note, List<BlockInfo> blocks) async {
    try {
      for (int i = 0; i < blocks.length; i++) {
        if (blocks[i].type == 8) {
          return (Right(true));
        }
      }
      return (Right(false));
    } on Exception {
      return Left(NativeDatabaseException());
    }
  }
}
