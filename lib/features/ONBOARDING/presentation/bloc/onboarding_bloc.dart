import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'onboarding_event.dart';
part 'onboarding_state.dart';
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(OnboardingInitial());
  @override
  Stream<OnboardingState> mapEventToState(
    OnboardingEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
