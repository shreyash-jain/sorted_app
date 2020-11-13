import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'files_event.dart';
part 'files_state.dart';
class FilesBloc extends Bloc<FilesEvent, FilesState> {
  FilesBloc() : super(FilesInitial());
  @override
  Stream<FilesState> mapEventToState(
    FilesEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
