import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/features/HOME/data/models/motivation/pep_talks.dart';
import 'package:sorted/features/HOME/domain/repositories/home_repository.dart';
part 'pep_talk_event.dart';
part 'pep_talk_state.dart';

class PeptalkBloc extends Bloc<PeptalkEvent, PeptalkState> {
  final HomeRepository repository;
  PeptalkBloc(this.repository) : super(PeptalkInitial());
  @override
  Stream<PeptalkState> mapEventToState(
    PeptalkEvent event,
  ) async* {
    if (event is GetPeptalk) {
      Failure failure;
      PepTalkModel talk;
      var result = await repository.getMotivationOfTheDay();
      result.fold((l) => failure = l, (r) => talk = r);
      if (failure == null && talk.id != -1) {
        yield PeptalkLoaded(talk);
      } else
        yield PeptalkError(Failure.mapToString(failure));
    }
  }
}
