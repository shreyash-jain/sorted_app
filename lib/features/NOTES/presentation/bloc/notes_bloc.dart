import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'notes_event.dart';
part 'notes_state.dart';
class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc() : super(NotesInitial());
  @override
  Stream<NotesState> mapEventToState(
    NotesEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
