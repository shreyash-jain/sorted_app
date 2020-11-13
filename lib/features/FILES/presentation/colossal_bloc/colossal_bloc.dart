import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/models/image.dart';
import 'package:sorted/features/FILES/data/models/block_image_colossal.dart';
import 'package:sorted/features/FILES/data/models/block_info.dart';
import 'package:sorted/features/FILES/data/models/block_textbox.dart';
import 'package:sorted/features/FILES/domain/repositories/note_repository.dart';
import 'package:sorted/features/FILES/presentation/note_bloc/note_bloc.dart';
import 'package:sorted/features/PLAN/data/models/todo.dart';
import 'package:sorted/features/PLAN/data/models/todo_item.dart';
import 'package:sorted/features/PLAN/domain/repositories/todo_repository.dart';
import 'package:zefyr/zefyr.dart';
part 'colossal_event.dart';
part 'colossal_state.dart';

class ColossalBloc extends Bloc<ColossalEvent, ColossalState> {
  final NoteRepository noteRepository;
  final TodoRepository todoRepository;
  final NoteBloc noteBloc;
  ColossalBloc(this.noteRepository, this.noteBloc, this.todoRepository)
      : super(ColossalInitial());
  @override
  Stream<ColossalState> mapEventToState(
    ColossalEvent event,
  ) async* {
    if (event is UpdateColossal) {
      print("UpdateTextbox  " + event.block.id.toString());
      Failure failure;
      ColossalBlock colossal;

      List<ImageModel> images;

      if (failure == null) yield ColossalLoaded(images, event.block, colossal);
    }
  }

  @override
  Future<void> close() {
    print(" update textbox");

    return super.close();
  }
}
