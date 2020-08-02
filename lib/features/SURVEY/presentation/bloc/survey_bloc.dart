import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'survey_event.dart';
part 'survey_state.dart';
class SurveyBloc extends Bloc<SurveyEvent, SurveyState> {
  SurveyBloc() : super(SurveyInitial());
  @override
  Stream<SurveyState> mapEventToState(
    SurveyEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
