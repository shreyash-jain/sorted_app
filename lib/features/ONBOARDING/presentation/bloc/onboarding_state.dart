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
  Error({@required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}