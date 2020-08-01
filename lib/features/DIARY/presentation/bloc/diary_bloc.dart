import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'diary_event.dart';
part 'diary_state.dart';
class DiaryBloc extends Bloc<DiaryEvent, DiaryState> {
  DiaryBloc() : super(DiaryInitial());
  @override
  Stream<DiaryState> mapEventToState(
    DiaryEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
