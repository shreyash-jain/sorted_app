import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/routes/router.gr.dart';
import 'package:sorted/features/HOME/data/models/inspiration.dart';

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

  AffirmationBloc(this.repository) : super(InitialState());

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
      print("here");
      yield LoadingState();
      print("here1");
      yield* doOnLoad();
    } else if (event is UpdateAffirmation) {
      //event.affirmations.sort((a, b) => compareList(a, b));
    }
  }

  Stream<AffirmationState> doOnLoad() async* {
    print(doOnLoad.toString() + " " + "");
    Failure failure;
    List<String> thumbnailUrl = [];
    List<DayAffirmation> affirmations;
    InspirationModel inspiration;
    List<DayAffirmation> resultAffirmations = [];

    Either<Failure, List<DayAffirmation>> affirmationsOrFailure =
        await repository.todayAffirmations;
    Either<Failure, InspirationModel> inspirationOrFailure =
        await repository.inspiration;
    affirmationsOrFailure.fold((l) {
      failure = l;
    }, (r) {
      affirmations = r;
      r.forEach((element) {
        print("at affirmations  " + element.category);
        print("at affirmations  " + element.thumbnailUrl);
      });
    });
    bool showAffirmations = true;
    bool showInspiration = false;
    if (greeting() == 0) {
      bool allSeen = true;
      if (affirmations != null) {
        affirmations.forEach((element) {
          if (!element.read) {
            allSeen = false;
          }
        });
      }

      if (allSeen) {
        showAffirmations = false;
        showInspiration = true;
      }
    } else {
      showAffirmations = false;
      showInspiration = true;
    }

    inspirationOrFailure.fold((l) {
      failure = l;
    }, (r) {
      inspiration = r;
    });
    if (failure != null) {
      print(doOnLoad.toString() + " " + "in falure");
      yield Error(message: mapFailureToString(failure));
    } else {
      print(doOnLoad.toString() + " " + "LoadedState");
      affirmations.sort((a, b) => compareList(a, b));

      yield LoadedState(
          showInspiration: false,
          showAffirmations: true,
          affirmations: affirmations,
          inspiration: inspiration);


    //   ARouter.push(  
    //   BookDetailsRoute(  
    //       book: book,  
    //       onRateBook: (rating) {  
    //        // handle result  
    //       }),  
    // );  
    //   Router.navigator.pushNamed(Router.affirmationPageview,
    //       arguments: AffirmationPVArguments(
    //           affirmations: affirmations, startIndex: 0, outerBloc: this));
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

  int greeting() {
    return 0;
    var hour = DateTime.now().hour;
    //   if (hour < 12 && hour>6) {
    //     return 0;
    //   }
    //  else{
    //     return 1;
    //   }
  }
}
