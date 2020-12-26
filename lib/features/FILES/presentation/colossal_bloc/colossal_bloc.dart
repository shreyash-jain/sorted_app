import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/models/image.dart';
import 'dart:io' as io;
import 'package:sorted/features/FILES/data/models/block_image.dart';
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

  final NoteBloc noteBloc;
  ColossalBloc(this.noteRepository, this.noteBloc) : super(ColossalInitial());
  @override
  Stream<ColossalState> mapEventToState(
    ColossalEvent event,
  ) async* {
    if (event is UpdateColossal) {
      print("UpdateTextbox  " + event.block.id.toString());
      Failure failure;
      ColossalBlock colossal;
      List<ImageBlock> images;
      List<bool> doLocalExists;

      var colossalOrFailure =
          await noteRepository.getColossal(event.block.itemId);

      colossalOrFailure.fold((l) {
        failure = l;
      }, (r) {
        colossal = r;
      });
      if (colossal != null) {
        var imagesOrFailure =
            await noteRepository.getImagesInColossal(colossal.id);
        await imagesOrFailure.fold((l) async {
          failure = l;
        }, (r) async {
          images = r;
        });

        doLocalExists = [];
        for (int j = 0; j < images.length; j++) {
          if (images[j].imagePath == null || images[j].imagePath == '')
            doLocalExists.add(false);
          else
            doLocalExists.add(await io.File(images[j].imagePath).exists());
        }
      }
      if (failure == null) {
        yield ColossalLoaded(images, event.block, colossal, doLocalExists);
        print(images.length.toString() + "  shreyash1 images");
        print(doLocalExists.length.toString() + "  shreyash2");
      }
    }
  }

  @override
  Future<void> close() {
    print(" update textbox");

    return super.close();
  }
}
