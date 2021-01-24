part of 'affirmation_pv_bloc.dart';

abstract class AffirmationPVState extends Equatable {
  const AffirmationPVState();
}

class LoadingPVState extends AffirmationPVState {
  @override
  List<Object> get props => [];
}

class LoadedPVState extends AffirmationPVState {
 
  final List<DayAffirmation> affirmations;

  LoadedPVState({this.affirmations});

  @override
  List<Object> get props => [affirmations];
}

class ErrorPVState extends AffirmationPVState {
  final String message;

  ErrorPVState({this.message});

  @override
  List<Object> get props => [message];
}
