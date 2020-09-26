part of 'affirmation_bloc.dart';

abstract class AffirmationState extends Equatable {
  const AffirmationState();
}

class LoadingState extends AffirmationState {
  @override
  List<Object> get props => [];
}

class LoadedState extends AffirmationState {
 
  final List<DayAffirmation> affirmations;

  LoadedState({this.affirmations});

  @override
  List<Object> get props => [affirmations];
}

class Error extends AffirmationState {
  final String message;

  Error({this.message});

  @override
  List<Object> get props => [message];
}
