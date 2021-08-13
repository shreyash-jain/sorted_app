part of 'pep_talk_bloc.dart';

abstract class PeptalkState extends Equatable {
  const PeptalkState();
}

class PeptalkInitial extends PeptalkState {
  @override
  List<Object> get props => [];
}

class PeptalkLoaded extends PeptalkState {
  final PepTalkModel talk;

  PeptalkLoaded(this.talk);
  @override
  List<Object> get props => [talk];
}

class PeptalkError extends PeptalkState {
  final String message;

  PeptalkError(this.message);

  @override
  List<Object> get props => [message];
}
