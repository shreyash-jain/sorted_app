import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/features/FILES/data/models/block_form_field.dart';
import 'package:sorted/features/FILES/data/models/block_info.dart';
import 'package:sorted/features/FILES/data/models/block_textbox.dart';
import 'package:sorted/features/FILES/domain/entities/block_heading.dart';
import 'package:sorted/features/FILES/domain/repositories/note_repository.dart';
import 'package:sorted/features/FILES/presentation/note_bloc/note_bloc.dart';
import 'package:sorted/features/PLAN/data/models/todo.dart';
import 'package:sorted/features/PLAN/data/models/todo_item.dart';
import 'package:sorted/features/PLAN/domain/repositories/todo_repository.dart';
import 'package:zefyr/zefyr.dart';
part 'heading_event.dart';
part 'heading_state.dart';

class HeadingBloc extends Bloc<HeadingEvent, HeadingState> {
  final NoteRepository noteRepository;

  final NoteBloc noteBloc;
  HeadingBloc(this.noteRepository, this.noteBloc) : super(HeadingInitial());
  @override
  Stream<HeadingState> mapEventToState(
    HeadingEvent event,
  ) async* {
    if (event is UpdateHeading) {
      print("UpdateTextbox  " + event.block.id.toString());
      Failure failure;
      FormFieldBlock formfield;
      var fieldOrFailure =
          await noteRepository.getFormField(event.block.itemId);

      fieldOrFailure.fold((l) {
        failure = l;
        print("shreyash 123 " + "error");
      }, (r) {
        formfield = r;
        print("shreyash 123 " + r.toString());
      });

      if (failure == null)
        yield HeadingLoaded(formfield.toHeading(), event.block);
    } else if (event is UpdateDecoration) {
      HeadingBlock thisBlock = event.headingBlock;
      thisBlock = thisBlock.copyWith(decoration: event.newDecoration);
      yield HeadingLoaded(thisBlock, (state as HeadingLoaded).blockInfo);
      noteRepository.updateFormField(thisBlock.toFormFieldBlock());
    }
  }

  @override
  Future<void> close() {
    print(" update textbox");

    return super.close();
  }
}
