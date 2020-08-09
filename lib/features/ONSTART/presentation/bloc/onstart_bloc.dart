import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sorted/core/error/failures.dart';

import 'package:sorted/core/usecases/usecase.dart';
import 'package:sorted/features/ONSTART/domain/usecases/do_local_auth.dart';
import 'package:sorted/features/ONSTART/domain/usecases/cancel_local_auth.dart';
part 'onstart_event.dart';
part 'onstart_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String PLATFORM_FAILURE_MESSAGE = 'Platform Failure';

class OnstartBloc extends Bloc<OnstartEvent, OnstartState> {
  final DoLocalAuth doLocalAuth;
  final CancelLocalAuth cancelLocalAuth;

  OnstartBloc({
    @required DoLocalAuth localAuth,
    @required CancelLocalAuth cancelAuth,
    //TODO: add to injection
  })  : doLocalAuth = localAuth,
  cancelLocalAuth=cancelAuth,
        super(InitState());

  @override
  Stream<OnstartState> mapEventToState(
    OnstartEvent event,
  ) async* {
    if (event is GetLocalAuthDone) {
      yield Loading();
      final Either<Failure, bool> result = await doLocalAuth(NoParams());
      print("Bloc result : "+result.toString());
      yield* _eitherLoadedOrErrorState(result);
    }
  }

  Stream<OnstartState> _eitherLoadedOrErrorState(
      Either<Failure, bool> result) async* {
    result.fold(
        (l)  async* {
          print("error reset");
          cancelLocalAuth(NoParams());
          
          yield Error(message: _mapFailureToMessage(l));
          },
        (r)  async* {
           print("No error");
          if (r) {
            print("true");
            yield AccessGranted();
          }
          else yield AccessDenied();
        });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      case PlatformFailure:
        return PLATFORM_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
