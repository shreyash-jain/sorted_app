import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:googleapis/verifiedaccess/v1.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/features/HOME/data/models/challenge_model.dart';
import 'package:sorted/features/HOME/domain/repositories/home_repository.dart';
part 'home_event.dart';
part 'home_state.dart';

class ChallengeBloc extends Bloc<ChallengeEvent, ChallengeState> {
  final HomeRepository repository;
  ChallengeBloc(this.repository) : super(ChallengeInitial());
  @override
  Stream<ChallengeState> mapEventToState(
    ChallengeEvent event,
  ) async* {
    if (event is GetTodayChallenge) {
      ChallengeModel challenge;
      Failure failure;

      var result = await repository.getChallengeOfTheDay();
      
      result.fold((l) => failure = l, (r) => challenge = r);

      if (failure == null && challenge.id != -1) {
        yield ChallengeLoaded(challenge);
      } else
        yield ChallengeError(Failure.mapToString(failure));
    }
  }
}
