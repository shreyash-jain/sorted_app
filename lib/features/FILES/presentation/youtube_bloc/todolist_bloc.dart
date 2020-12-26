import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/features/FILES/data/models/block_info.dart';
import 'package:sorted/features/FILES/data/models/block_textbox.dart';
import 'package:sorted/features/FILES/data/models/block_youtube.dart';
import 'package:sorted/features/FILES/domain/repositories/note_repository.dart';
import 'package:sorted/features/FILES/presentation/note_bloc/note_bloc.dart';
import 'package:sorted/features/PLAN/data/models/todo.dart';
import 'package:sorted/features/PLAN/data/models/todo_item.dart';
import 'package:sorted/features/PLAN/domain/repositories/todo_repository.dart';
import 'package:zefyr/zefyr.dart';
part 'todolist_event.dart';
part 'todolist_state.dart';

class YoutubeBloc extends Bloc<YoutubeEvent, YoutubeState> {
  final NoteRepository noteRepository;

  final NoteBloc noteBloc;
  YoutubeBloc(this.noteRepository, this.noteBloc) : super(YoutubeInitial());
  @override
  Stream<YoutubeState> mapEventToState(
    YoutubeEvent event,
  ) async* {
    if (event is GetVideo) {
      print("UpdateTextbox  " + event.block.id.toString());
      Failure failure;
      YoutubeBlock ytBlock;
      var todoOrFailure = await noteRepository.getYoutube(event.block.itemId);
      todoOrFailure.fold((l) {
        failure = l;
      }, (r) {
        ytBlock = r;
      });

      if (failure == null) yield YoutubeLoaded(event.block, ytBlock);
    }
  }

  @override
  Future<void> close() {
    print(" update textbox");

    return super.close();
  }
}
