part of 'onboarding_bloc.dart';

abstract class OnboardingEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class OpenBottomSheet extends OnboardingEvent {}

class LogInWithGoogle extends OnboardingEvent {}
