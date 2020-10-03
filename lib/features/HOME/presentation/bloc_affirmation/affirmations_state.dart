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
  final InspirationModel inspiration;
  final bool showInspiration;
  final bool showAffirmations;

  LoadedState({this.showInspiration, this.showAffirmations, this.affirmations, this.inspiration});

  @override
  List<Object> get props => [affirmations, inspiration, showInspiration, showAffirmations];
}

class Error extends AffirmationState {
  final String message;

  Error({this.message});

  @override
  List<Object> get props => [message];
}
