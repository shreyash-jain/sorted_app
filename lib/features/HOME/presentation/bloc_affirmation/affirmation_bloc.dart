import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:sorted/features/HOME/domain/entities/display_thumbnail.dart';
import 'package:sorted/features/HOME/domain/repositories/home_repository.dart';
part 'affirmation_event.dart';
part 'affirmations_state.dart';

const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String NETWORK_FAILURE_MESSAGE = 'Network Failure';
const String NATIVE_DATABASE_FAILURE_MESSAGE = "Database error";
const String FAILURE_MESSAGE = "Uncatched error";

class AffirmationBloc extends Bloc<AffirmationEvent, AffirmationState> {
  final HomeRepository repository;

  AffirmationBloc(this.repository) : super(LoadingState());

  String mapFailureToString(Failure failure) {
    if (failure == ServerFailure()) {
      return SERVER_FAILURE_MESSAGE;
    } else if (failure == NativeDatabaseException()) {
      return NATIVE_DATABASE_FAILURE_MESSAGE;
    } else if (failure == CacheFailure()) {
      return CACHE_FAILURE_MESSAGE;
    } else if (failure == NetworkFailure()) {
      return NETWORK_FAILURE_MESSAGE;
    } else
      return FAILURE_MESSAGE;
  }

  @override
  Stream<AffirmationState> mapEventToState(
    AffirmationEvent event,
  ) async* {
    if (event is LoadStories) {
      yield LoadingState();
      yield* doOnLoad();
    } else if (event is UpdateAffirmation) {
     event.affirmations.sort((a, b) => compareList(a, b));
      yield LoadedState(affirmations: event.affirmations);
    }
  }

  Stream<AffirmationState> doOnLoad() async* {
    print(doOnLoad.toString() + " " + "");
    Failure failure;
    List<String> thumbnailUrl = [];
    List<DayAffirmation> affirmations;
    List<DayAffirmation> resultAffirmations = [];

    Either<Failure, List<DayAffirmation>> affirmationsOrFailure =
        await repository.todayAffirmations;

    affirmationsOrFailure.fold((l) {
      failure = l;
    }, (r) {
      affirmations = r;
      r.forEach((element) {
        print("at affirmations  " + element.category);
        print("at affirmations  " + element.thumbnailUrl);
      });
    });
    if (failure != null) {
      print(doOnLoad.toString() + " " + "in falure");
      yield Error(message: mapFailureToString(failure));
    } else {
      print(doOnLoad.toString() + " " + "LoadedState");
      affirmations.sort((a, b) => compareList(a, b));
      yield LoadedState(affirmations: affirmations);
    }
  }

  compareList(DayAffirmation a, DayAffirmation b) {
    if (a.read && !b.read) {
      return 1;
    } else if (!a.read && b.read)
      return 0;
    else {
      //Todo: check if this is correct
      return a.lastSeen.compareTo(b.lastSeen);
    }
  }
}
