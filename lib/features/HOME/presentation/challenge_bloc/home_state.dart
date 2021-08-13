part of 'home_bloc.dart';

abstract class ChallengeState extends Equatable {
  const ChallengeState();
}

class ChallengeInitial extends ChallengeState {
  @override
  List<Object> get props => [];
}

class ChallengeLoaded extends ChallengeState {
  final ChallengeModel challenge;

  ChallengeLoaded(this.challenge);

  @override
  List<Object> get props => [];
}

class ChallengeError extends ChallengeState {
  final String message;

  ChallengeError(this.message);

  @override
  List<Object> get props => [message];
}
