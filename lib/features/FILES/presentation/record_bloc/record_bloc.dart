import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:bloc/bloc.dart';

import 'package:path/path.dart' as p;
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/models/image.dart';
import 'package:sorted/core/global/models/link.dart';
import 'package:sorted/core/global/utility/measure_child.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/features/FILES/data/models/block_calendar.dart';
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
import 'package:sorted/features/FILES/data/models/notebook_model.dart';
import 'package:sorted/features/FILES/data/repositories/notebooks_list.dart';
import 'package:sorted/features/FILES/domain/entities/block_heading.dart';
import 'package:sorted/features/FILES/domain/repositories/note_repository.dart';
import 'package:sorted/features/FILES/presentation/calendar_bloc/calendar_bloc.dart';
import 'package:sorted/features/FILES/presentation/colossal_bloc/colossal_bloc.dart';
import 'package:sorted/features/FILES/presentation/date_bloc/date_bloc.dart';
import 'package:sorted/features/FILES/presentation/heading_bloc/heading_bloc.dart';
import 'package:sorted/features/FILES/presentation/image_bloc/image_bloc.dart';
import 'package:sorted/features/FILES/presentation/link_bloc/link_bloc.dart';
import 'package:sorted/features/FILES/presentation/password_bloc/password_bloc.dart';
import 'package:sorted/features/FILES/presentation/sequence_bloc/sequence_bloc.dart';
import 'package:sorted/features/FILES/presentation/slider_bloc/slider_bloc.dart';
import 'package:sorted/features/FILES/presentation/table_bloc/table_bloc.dart';
import 'package:sorted/features/FILES/presentation/textbox_bloc/textbox_bloc.dart';
import 'package:sorted/features/FILES/presentation/todolist_bloc/todolist_bloc.dart';
import 'package:sorted/features/FILES/presentation/widgets/add_column.dart';
import 'package:sorted/features/FILES/presentation/widgets/auther_widget.dart';
import 'package:sorted/features/FILES/presentation/widgets/calendar_widget.dart';
import 'package:sorted/features/FILES/presentation/widgets/colossal_widget.dart';
import 'package:sorted/features/FILES/presentation/widgets/date_widget.dart';
import 'package:sorted/features/FILES/presentation/widgets/heading_menu.dart';
import 'package:sorted/features/FILES/presentation/widgets/heading_widget.dart';
import 'package:sorted/features/FILES/presentation/widgets/image_widget.dart';
import 'package:sorted/features/FILES/presentation/widgets/link_widget.dart';
import 'package:sorted/features/FILES/presentation/widgets/password_widget.dart';
import 'package:sorted/features/FILES/presentation/widgets/sequence_widget.dart';
import 'package:sorted/features/FILES/presentation/widgets/slider_widget.dart';
import 'package:sorted/features/FILES/presentation/widgets/table_widget.dart';
import 'package:sorted/features/FILES/presentation/widgets/textbox_widget.dart';
import 'package:sorted/features/FILES/presentation/widgets/todo_item_menu.dart';
import 'package:sorted/features/FILES/presentation/widgets/todolist_widget.dart';
import 'package:sorted/features/FILES/presentation/widgets/youtube_widget.dart';
import 'package:sorted/features/FILES/presentation/youtube_bloc/todolist_bloc.dart';
import 'package:sorted/features/PLAN/data/models/todo.dart';
import 'package:sorted/features/PLAN/data/models/todo_item.dart';
import 'package:sorted/features/PLAN/domain/repositories/todo_repository.dart';
import 'package:sorted/features/PLAN/presentation/widgets/add_link.dart';
import 'package:string_validator/string_validator.dart';
part 'record_event.dart';
part 'record_state.dart';

class RecordBloc extends Bloc<RecordEvent, RecordState> {
  final NoteRepository noteRepository;
  final TodoRepository todoRepository;
  LinkedHashMap<int, Widget> typeToWidgetMap = LinkedHashMap();

  var _newMediaLinkAddressController = TextEditingController();
  RecordBloc(this.noteRepository, this.todoRepository) : super(RecordLoading());

  @override
  Stream<RecordState> mapEventToState(
    RecordEvent event,
  ) async* {
    if (event is GetRecordInitialData) {
      List<NotebookModel> everydayNotebooks = NotebookList.notebooks
          .where((element) => element.listCategory == 1)
          .toList();
      List<NotebookModel> educationNotebooks = NotebookList.notebooks
          .where((element) => element.listCategory == 2)
          .toList();
      List<NotebookModel> financeNotebooks = NotebookList.notebooks
          .where((element) => element.listCategory == 3)
          .toList();
      List<NotebookModel> friendsNotebooks = NotebookList.notebooks
          .where((element) => element.listCategory == 4)
          .toList();
      List<NotebookModel> selfloveNotebooks = NotebookList.notebooks
          .where((element) => element.listCategory == 5)
          .toList();
      List<NotebookModel> blogsNotebooks = NotebookList.notebooks
          .where((element) => element.listCategory == 6)
          .toList();
      List<NotebookModel> healthNotebooks = NotebookList.notebooks
          .where((element) => element.listCategory == 7)
          .toList();
      List<NoteModel> recentNotes = [];
      List<String> categories = [
        "Routine",
        "Education & work",
        "Finance",
        "Friends & Family",
        "Self Love",
        "Blogs",
        "Health"
      ];
      List<String> categoriesDescription = [
        "Day to day productivity booster",
        "Manage your important notes from work to school",
        "Keep the incoming and outgoing money in check",
        "Cherish the beautiful moments with your loved ones",
        "Introspect the small changes around you to have control over them",
        "Save the top moments of life",
        "Fast, simple and straightforward way to log and track and health event"
      ];
      print(everydayNotebooks.length.toString() + " kkskjs ");

      yield RecordLoaded(
        everydayNotebooks,
        educationNotebooks,
        financeNotebooks,
        friendsNotebooks,
        selfloveNotebooks,
        blogsNotebooks,
        healthNotebooks,
        recentNotes,
        categories,
        categoriesDescription,
      );
    }
  }
}
