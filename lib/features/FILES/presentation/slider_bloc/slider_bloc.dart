import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/features/FILES/data/models/block_info.dart';
import 'package:sorted/features/FILES/data/models/block_slider.dart';
import 'package:sorted/features/FILES/data/models/block_textbox.dart';
import 'package:sorted/features/FILES/domain/repositories/note_repository.dart';
import 'package:sorted/features/FILES/presentation/note_bloc/note_bloc.dart';
import 'package:sorted/features/PLAN/data/models/todo.dart';
import 'package:sorted/features/PLAN/data/models/todo_item.dart';
import 'package:sorted/features/PLAN/domain/repositories/todo_repository.dart';
import 'package:zefyr/zefyr.dart';
part 'slider_event.dart';
part 'slider_state.dart';

class SliderBloc extends Bloc<SliderEvent, SliderState> {
  final NoteRepository noteRepository;

  final NoteBloc noteBloc;
  SliderBloc(this.noteRepository, this.noteBloc) : super(SliderInitial());
  @override
  Stream<SliderState> mapEventToState(
    SliderEvent event,
  ) async* {
    if (event is LoadSlider) {
      print("UpdateTextbox  " + event.block.id.toString());
      Failure failure;
      SliderBlock slider;
      var todoOrFailure = await noteRepository.getSlider(event.block.itemId);
      todoOrFailure.fold((l) {
        failure = l;
      }, (r) {
        slider = r;
      });

      if (failure == null) yield SliderLoaded(slider, event.block);
    } else if (event is UpdateSliderValue) {
      yield SliderLoaded(event.newSlider, (state as SliderLoaded).blockInfo);
      noteRepository.updateSliderBlock(event.newSlider);
    }
  }

  @override
  Future<void> close() {
    print(" update textbox");

    return super.close();
  }
}
