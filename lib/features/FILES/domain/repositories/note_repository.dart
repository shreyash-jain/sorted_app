import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/models/image.dart';
import 'package:sorted/core/global/models/link.dart';
import 'package:sorted/core/global/models/log.dart';
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
import 'package:sorted/features/FILES/presentation/colossal_bloc/colossal_bloc.dart';
import 'package:sorted/features/FILES/presentation/widgets/todo_item_menu.dart';
import 'package:sorted/features/HOME/domain/entities/unsplash_image.dart';

import 'package:sorted/features/PLAN/data/models/goal.dart';
import 'package:sorted/features/PLAN/data/models/task_status.dart';
import 'package:sorted/features/PLAN/data/models/todo_item.dart';

abstract class NoteRepository {
  /// Gets the affirmations from cloud and favourates and also adds to local
  ///
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, List<NoteModel>>> getNotes();

  Future<Either<Failure, String>> getTextOfNote(
      NoteModel note, List<BlockInfo> blocks);
  Future<Either<Failure, String>> getImageUrlOfNote(
      NoteModel note, List<BlockInfo> blocks);
  Future<Either<Failure, bool>> getIfNoteHasList(
      NoteModel note, List<BlockInfo> blocks);
  Future<Either<Failure, bool>> getIfNoteHasTable(
      NoteModel note, List<BlockInfo> blocks);
  Future<Either<Failure, bool>> getIfNoteHasCalendar(
      NoteModel note, List<BlockInfo> blocks);
  Future<Either<Failure, bool>> getIfNoteHasLink(
      NoteModel note, List<BlockInfo> blocks);

  /// Gets the affirmations from cloud and favourates and also adds to local
  ///
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, List<NoteModel>>> getNotesOfNotebook(int notebookId);

  /// Gets the affirmations from cloud and favourates and also adds to local
  ///
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, List<BlockInfo>>> getBlocksOfNote(NoteModel note);

  /// Gets the affirmations from cloud and favourates and also adds to local
  ///
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, TextboxBlock>> getTextboxOfId(int id);

  /// Gets the affirmations from cloud and favourates and also adds to local
  ///
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, ImageBlock>> getImageOfId(int id);
  Future<Either<Failure, void>> linkNoteAndBlock(
      NoteModel note, BlockInfo block, int id);

  /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, NoteModel>> addNote(NoteModel note);

  /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, BlockInfo>> addBlockInfo(BlockInfo block);

  /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, TextboxBlock>> addTextbox(TextboxBlock textbox);

  /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, void>> addImageBlock(ImageBlock imagebox);
  Future<Either<Failure, void>> addLinkBlock(LinkModel link);
  Future<Either<Failure, void>> updateLinkBlock(LinkModel link);
  Future<Either<Failure, void>> addCheckboxBlock(TodoItemModel item);
  Future<Either<Failure, void>> updateCheckboxBlock(TodoItemModel item);
  Future<Either<Failure, void>> addSliderBlock(SliderBlock item);
  Future<Either<Failure, void>> updateSliderBlock(SliderBlock item);
  Future<Either<Failure, void>> addFormFieldBlock(FormFieldBlock item);
  Future<Either<Failure, void>> updateFormFieldBlock(FormFieldBlock item);
  Future<Either<Failure, void>> addSequenceBlock(SequenceBlock item);
  Future<Either<Failure, void>> updateSequenceBlock(SequenceBlock item);
  Future<Either<Failure, void>> addYoutubeBlock(YoutubeBlock item);
  Future<Either<Failure, void>> updateYoutubeBlock(YoutubeBlock item);
  Future<Either<Failure, void>> addCalendarBlock(CalendarBlock item);
  Future<Either<Failure, void>> updateCalendarBlock(CalendarBlock item);
  Future<Either<Failure, void>> addTableBlock(TableBlock item);
  Future<Either<Failure, void>> updateTableBlock(TableBlock item);
  Future<Either<Failure, void>> addCalendarEventBlock(CalendarEventBlock item);
  Future<Either<Failure, void>> updateCalendarEventBlock(
      CalendarEventBlock item);
  Future<Either<Failure, void>> addTableColumn(ColumnBlock item);
  Future<Either<Failure, void>> updateTableColumn(ColumnBlock item);
  Future<Either<Failure, void>> addTableColumnItem(TableItemBlock item);
  Future<Either<Failure, void>> updateTableColumnItem(TableItemBlock item);
  Future<Either<Failure, ImageModel>> storeImage(ImageModel image, File file);

  /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, NoteModel>> updateNote(NoteModel note);

  /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, void>> updateFormField(FormFieldBlock item);

  /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, void>> updateImageBlock(ImageBlock item);

  /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, void>> addImagesInColossal(
      ColossalBlock colossal, List<ImageBlock> images);

  /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, List<ImageBlock>>> getImagesInColossal(int colossalId);

  /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, ColossalBlock>> getColossal(int colossalId);

  /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, SliderBlock>> getSlider(int sliderId);

  /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, LinkModel>> getLink(int link);
  Future<Either<Failure, YoutubeBlock>> getYoutube(int id);

  /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, FormFieldBlock>> getFormField(int formfieldId);

  /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, SequenceBlock>> getSequence(int sequenceId);

  /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, TodoItemModel>> getCheckBox(int checkboxId);

  /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, TableBlock>> getTableBlock(int tableId);

  /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, CalendarBlock>> getCalendarBlock(int calId);

  /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, List<CalendarEventBlock>>> getCalendarEventsBlock(
      int calId, DateTime startDay, DateTime endDay);

  /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, List<ColumnBlock>>> getTableColumnsBlock(int tableId);

  /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, List<TableItemBlock>>> getTableColumnsItems(int colId);

  /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, BlockInfo>> updateBlockInfo(BlockInfo block);

  /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, TextboxBlock>> updateTextbox(TextboxBlock textbox);

  /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, void>> removeNote(NoteModel note);

  /// Gets the thumbnail details and convert them in urls.

}
