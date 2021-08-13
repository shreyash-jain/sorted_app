import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sorted/core/authentication/remote_auth_repository.dart';
import 'package:sorted/core/error/failures.dart';
part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc({@required AuthenticationRepository authRepo})
      : _authenticationRepository = authRepo,
        assert(authRepo != null),
        super(StartState());

  final AuthenticationRepository _authenticationRepository;

  @override
  Stream<OnboardingState> mapEventToState(
    OnboardingEvent event,
  ) async* {
    if (event is OpenBottomSheet) {
      yield BottomSheetState();
    } else if (event is LogInWithGoogle) {
      Failure failure;
      yield Loading();
      Either<Failure, int> result;

      try {
        result = await _authenticationRepository.logInWithGoogle();
        result.fold((l) => failure = l, (r) => null);

        if (failure == null)
          yield (SignInCompleted());
        else {
          yield (SigninError(message: "Unable to authenticate"));
        }
      } catch (e) {
        
        yield (SigninError(message: "Unable to authenticate"));
      }
    }
  }
}
