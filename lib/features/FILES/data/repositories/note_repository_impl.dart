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
import 'package:sorted/core/global/models/log.dart';
import 'package:sorted/core/network/network_info.dart';
import 'package:sorted/features/FILES/data/datasources/note_sources/note_cloud_data_source.dart';
import 'package:sorted/features/FILES/data/datasources/note_sources/note_native_data_source.dart';
import 'package:sorted/features/FILES/data/datasources/note_sources/note_shared_pref_data_source.dart';
import 'package:sorted/features/FILES/data/models/block_image.dart';
import 'package:sorted/features/FILES/data/models/note_model.dart';
import 'package:sorted/features/FILES/data/models/block_textbox.dart';
import 'package:sorted/features/FILES/data/models/block_info.dart';
import 'package:sorted/features/FILES/domain/repositories/note_repository.dart';

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
import 'package:sorted/features/PLAN/domain/repositories/goal_repository.dart';

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
    print("shreyash "+imagebox.id.toString());
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
}
