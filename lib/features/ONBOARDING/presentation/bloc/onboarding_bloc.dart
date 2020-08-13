import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sorted/core/authentication/remote_auth_repository.dart';
part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc({@required AuthenticationRepository authRepo})
      : _authenticationRepository=authRepo,assert(authRepo != null),
        super(StartState());

  final AuthenticationRepository _authenticationRepository;

  @override
  Stream<OnboardingState> mapEventToState(
    OnboardingEvent event,
  ) async* {
    if (event is OpenBottomSheet) {
      yield BottomSheetState();
    } else if (event is LogInWithGoogle) {
      yield Loading();
      try {
        await _authenticationRepository.logInWithGoogle();
        yield (SignInCompleted());
      } on Exception {
        yield (Error(message: "Unable to authenticate"));
      }
    }
  }
}
