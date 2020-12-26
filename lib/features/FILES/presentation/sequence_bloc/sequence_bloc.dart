import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_cache_store/flutter_cache_store.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/models/link.dart';
import 'package:sorted/features/FILES/data/models/block_image.dart';
import 'package:sorted/features/FILES/data/models/block_info.dart';
import 'package:sorted/features/FILES/data/models/block_sequence.dart';
import 'package:sorted/features/FILES/data/models/block_textbox.dart';
import 'package:sorted/features/FILES/domain/repositories/note_repository.dart';
import 'package:sorted/features/FILES/presentation/note_bloc/note_bloc.dart';
import 'package:string_validator/string_validator.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart' as ht;

part 'sequence_event.dart';
part 'sequence_state.dart';

class SequenceBloc extends Bloc<SequenceEvent, SequenceState> {
  final NoteRepository noteRepository;
  final NoteBloc noteBloc;
  SequenceBloc(this.noteRepository, this.noteBloc) : super(SequenceInitial());
  @override
  Stream<SequenceState> mapEventToState(
    SequenceEvent event,
  ) async* {
    if (event is GetSequence) {
      print("UpdateTextbox  " + event.block.id.toString());
      Failure failure;
      SequenceBlock sequence;

      sequence = new SequenceBlock(
        title: "Link",
      );
      var linkOrFailure = await noteRepository.getSequence(event.block.itemId);
      linkOrFailure.fold((l) {
        failure = l;
      }, (r) {
        sequence = r;
      });

      print("whats seq " + sequence.id.toString());
      print("whats seq " + sequence.title);

      if (failure == null) yield SequenceLoaded(sequence, event.block);
    } else if (event is UpdateItem) {
      yield SequenceLoaded(event.item, (state as SequenceLoaded).blockInfo);
      noteRepository.updateSequenceBlock(event.item);
    }
  }

  @override
  Future<void> close() {
    print(" update textbox");

    return super.close();
  }
}
