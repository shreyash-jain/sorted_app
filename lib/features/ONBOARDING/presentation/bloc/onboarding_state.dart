part of 'onboarding_bloc.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  List<Object> get props => [];
}

class StartState extends OnboardingState {}

class BottomSheetState extends OnboardingState {}

class Loading extends OnboardingState {}

class SignInCompleted extends OnboardingState {}

class Error extends OnboardingState {
  final String message;

  Error({@required this.message});

  @override
  List<Object> get props => [message];
}