import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/models/link.dart';
import 'package:sorted/features/FILES/data/models/block_form_field.dart';
import 'package:sorted/features/FILES/data/models/block_image.dart';
import 'package:sorted/features/FILES/data/models/block_info.dart';
import 'package:sorted/features/FILES/data/models/block_textbox.dart';
import 'package:sorted/features/FILES/domain/repositories/note_repository.dart';
import 'package:sorted/features/FILES/presentation/note_bloc/note_bloc.dart';
import 'package:string_validator/string_validator.dart';


part 'password_event.dart';
part 'password_state.dart';

class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  final NoteRepository noteRepository;
  final NoteBloc noteBloc;
  PasswordBloc(this.noteRepository, this.noteBloc) : super(PasswordInitial());
  @override
  Stream<PasswordState> mapEventToState(
    PasswordEvent event,
  ) async* {
    if (event is GetPassword) {
      print("UpdateTextbox  " + event.block.id.toString());
      Failure failure;
      FormFieldBlock password;
      // var textboxOrFailure =
      //     await noteRepository.getImageOfId(event.block.itemId);
      // textboxOrFailure.fold((l) {
      //   failure = l;
      // }, (r) {
      //   link = r;
      // });
      password = new FormFieldBlock(
          url:
              "https://docs.google.com/spreadsheets/d/1AXI0nXEyaeSdG-A95XAEGlg29Igz6ydwjo9SWgfPd_I/edit#gid=186001220");

      var linkOrFailure = await noteRepository.getFormField(event.block.itemId);
      linkOrFailure.fold((l) {
        failure = l;
      }, (r) {
        password = r;
      });

      if (failure == null) yield PasswordLoaded(password, event.block);
    }
  }

  @override
  Future<void> close() {
    print(" update textbox");

    return super.close();
  }

  
}
