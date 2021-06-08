import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:bloc/bloc.dart';

import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/routes/router.gr.dart' as rt;
import 'package:sorted/features/FILES/data/models/block_form_field.dart';
import 'package:sorted/features/FILES/data/models/block_info.dart';
import 'package:sorted/features/FILES/data/models/block_textbox.dart';

import 'package:sorted/features/FILES/data/models/note_model.dart';
import 'package:sorted/features/FILES/data/models/notebook_model.dart';
import 'package:sorted/features/FILES/data/repositories/notebooks_list.dart';
import 'package:sorted/features/FILES/domain/entities/block_heading.dart';
import 'package:sorted/features/FILES/domain/repositories/note_repository.dart';
import 'package:sorted/features/FILES/presentation/audio_bloc/todolist_bloc.dart';
import 'package:sorted/features/PLAN/data/models/todo.dart';

import 'package:sorted/features/PLAN/domain/repositories/todo_repository.dart';

part 'notes_hub_event.dart';
part 'notes_hub_state.dart';

class NotesHubBloc extends Bloc<NotesHubEvent, NotesHubState> {
  final NoteRepository noteRepository;
  final TodoRepository todoRepository;
  LinkedHashMap<int, Widget> typeToWidgetMap = LinkedHashMap();

  var _newMediaLinkAddressController = TextEditingController();
  NotesHubBloc(this.noteRepository, this.todoRepository)
      : super(NotesHubLoading());

  @override
  Stream<NotesHubState> mapEventToState(
    NotesHubEvent event,
  ) async* {
    if (event is GetNotesHubInitialData) {
      Failure failure;
      List<NoteModel> notes = [];
      var sNotes =
          await noteRepository.getNotesOfNotebook(event.thisNotebook.id);
      sNotes.fold((l) {
        failure = l;
      }, (r) {
        notes = r;
      });
      if (failure == null) {
        yield NotesHubLoaded(event.thisNotebook, notes, [], [], [], [], []);

        List<String> notesText = [];
        List<String> notesImageURL = [];
        List<bool> hasList = [];
        List<bool> hasCal = [];
        List<bool> hasTable = [];

        for (int i = 0; i < notes.length; i++) {
          List<BlockInfo> blocks =
              (await noteRepository.getBlocksOfNote(notes[i])).getOrElse(null);
          if (blocks != null)
            notesText.add((await noteRepository.getTextOfNote(notes[i], blocks))
                .getOrElse(() => ""));
          else
            notesText.add("");
          if (blocks != null)
            notesImageURL.add(
                (await noteRepository.getImageUrlOfNote(notes[i], blocks))
                    .getOrElse(() => ""));
          else
            notesImageURL.add("");
          if (blocks != null)
            hasList.add(
                (await noteRepository.getIfNoteHasLink(notes[i], blocks))
                    .getOrElse(() => false));
          else
            hasList.add(false);
          if (blocks != null)
            hasCal.add(
                (await noteRepository.getIfNoteHasCalendar(notes[i], blocks))
                    .getOrElse(() => false));
          else
            hasCal.add(false);
          if (blocks != null)
            hasTable.add(
                (await noteRepository.getIfNoteHasTable(notes[i], blocks))
                    .getOrElse(() => false));
          else
            hasTable.add(false);
        }
        yield NotesHubLoaded(event.thisNotebook, notes, notesText,
            notesImageURL, hasList, hasTable, hasCal);
      }
    } else if (event is AddNewRecord) {
      NotesHubLoaded prevNoteState = (state as NotesHubLoaded);

      print("AddNewRecord");
      yield NotesHubLoading();
      NoteModel newNote =
          await makeNewNoteWithTemplate(event.type, event.notebook);
      prevNoteState.notes.add(newNote);
      yield NotesHubLoaded(
          prevNoteState.thisNotebook,
          prevNoteState.notes,
          prevNoteState.notesText,
          prevNoteState.notesUrl,
          prevNoteState.hasList,
          prevNoteState.hasTable,
          prevNoteState.hasCalendar);
      // rt.Router.navigator.pushNamed(rt.Router.noteHub,
      //     arguments: rt.NoteMainArguments(note: newNote));
    }
  }

  Future<NoteModel> makeNewNoteWithTemplate(
      int type, NotebookModel notebook) async {
    DateTime now = DateTime.now();
    DateFormat mainFormatter = DateFormat('dd MMM');
    NoteModel newNote = NoteModel(
        id: now.millisecondsSinceEpoch,
        numBlocks: 3,
        savedTs: now.millisecondsSinceEpoch,
        notebookId: notebook.id,
        noteEmoji: notebook.icon,
        cover: notebook.cover,
        title: "Quick note on ${mainFormatter.format(now)}");
    if (notebook.id == 10) {
      TextboxBlock textboxBlock = TextboxBlock(
          id: now.millisecondsSinceEpoch,
          title: "Note",
          savedTs: now.millisecondsSinceEpoch);

      BlockInfo autherBlockInfo = BlockInfo(
        height: 80,
        type: 13,
        id: now.millisecondsSinceEpoch,
        savedTs: now.millisecondsSinceEpoch,
        position: 0,
        itemId: 0,
      );

      BlockInfo textBlock = BlockInfo(
        height: 160,
        type: 0,
        id: now.millisecondsSinceEpoch + 1,
        savedTs: now.millisecondsSinceEpoch,
        position: 1,
        itemId: textboxBlock.id,
      );
      await noteRepository.addTextbox(textboxBlock);

      await noteRepository.addBlockInfo(autherBlockInfo);

      await noteRepository.addBlockInfo(textBlock);

      await noteRepository.linkNoteAndBlock(
          newNote, textBlock, now.millisecondsSinceEpoch);

      await noteRepository.linkNoteAndBlock(
          newNote, autherBlockInfo, now.millisecondsSinceEpoch);
    }
    if (notebook.id == 20) {
      BlockInfo autherBlockInfo = BlockInfo(
        height: 80,
        type: 13,
        id: now.millisecondsSinceEpoch,
        savedTs: now.millisecondsSinceEpoch,
        position: 0,
        itemId: 0,
      );

      TodoModel groceriesList = TodoModel(
          id: now.millisecondsSinceEpoch,
          title: "Groceries",
          savedTs: now,
          operation: 1,
          unit: "Units",
          searchId: 1,
          type: 1);

      BlockInfo todoBlockInfo = BlockInfo(
        height: 0,
        type: 3,
        id: now.millisecondsSinceEpoch + 1,
        savedTs: now.millisecondsSinceEpoch,
        position: 1,
        itemId: groceriesList.id,
      );
      await todoRepository.addTodo(groceriesList);
      await noteRepository.addBlockInfo(todoBlockInfo);
      await noteRepository.addBlockInfo(autherBlockInfo);

      await noteRepository.linkNoteAndBlock(
          newNote, autherBlockInfo, now.millisecondsSinceEpoch);
      await noteRepository.linkNoteAndBlock(
          newNote, todoBlockInfo, now.millisecondsSinceEpoch);
    }
    await noteRepository.addNote(newNote);
    return newNote;
  }
}
