import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/features/FILES/data/models/block_info.dart';
import 'package:sorted/features/FILES/data/models/block_textbox.dart';
import 'package:sorted/features/FILES/domain/repositories/note_repository.dart';
import 'package:sorted/features/FILES/presentation/note_bloc/note_bloc.dart';
import 'package:zefyr/zefyr.dart';
part 'textbox_event.dart';
part 'textbox_state.dart';

class TextboxBloc extends Bloc<TextboxEvent, TextboxState> {
  final NoteRepository noteRepository;
  final NoteBloc noteBloc;
  TextboxBloc(this.noteRepository, this.noteBloc) : super(TextboxInitial());
  @override
  Stream<TextboxState> mapEventToState(
    TextboxEvent event,
  ) async* {
    if (event is UpdateTextbox) {
      print("UpdateTextbox  " + event.block.id.toString());
      Failure failure;
      TextboxBlock textboxBlock;
      var textboxOrFailure =
          await noteRepository.getTextboxOfId(event.block.itemId);
      textboxOrFailure.fold((l) {
        failure = l;
      }, (r) {
        textboxBlock = r;
      });
      if (failure == null) yield Textboxloaded(textboxBlock, event.block);
    } else if (event is UpdateText) {
      print("update at bloc");
      print((state as Textboxloaded).textboxBlock.text);
      await noteRepository.updateTextbox(event.textblock);
      print(event.textblock.text);

      yield Textboxloaded(event.textblock, (state as Textboxloaded).blockInfo);
    }
  }

  @override
  Future<void> close() {
    print(" update textbox");

    return super.close();
  }
}
