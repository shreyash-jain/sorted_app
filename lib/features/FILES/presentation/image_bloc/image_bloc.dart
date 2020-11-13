import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/features/FILES/data/models/block_image.dart';
import 'package:sorted/features/FILES/data/models/block_info.dart';
import 'package:sorted/features/FILES/data/models/block_textbox.dart';
import 'package:sorted/features/FILES/domain/repositories/note_repository.dart';
import 'package:sorted/features/FILES/presentation/note_bloc/note_bloc.dart';
import 'package:zefyr/zefyr.dart';
part 'image_event.dart';
part 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final NoteRepository noteRepository;
  final NoteBloc noteBloc;
  ImageBloc(this.noteRepository, this.noteBloc) : super(ImageInitial());
  @override
  Stream<ImageState> mapEventToState(
    ImageEvent event,
  ) async* {
    if (event is UpdateImage) {
      print("UpdateTextbox  " + event.block.id.toString());
      Failure failure;
      ImageBlock imageBlock;
      var textboxOrFailure =
          await noteRepository.getImageOfId(event.block.itemId);
      textboxOrFailure.fold((l) {
        failure = l;
      }, (r) {
        imageBlock = r;
      });
       print("whats url " + imageBlock.id.toString());
      print("whats url " + imageBlock.url);
      if (failure == null) yield ImageLoaded(imageBlock, event.block);
    }
  }

  @override
  Future<void> close() {
    print(" update textbox");

    return super.close();
  }
}
