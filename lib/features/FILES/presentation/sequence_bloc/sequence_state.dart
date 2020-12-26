part of 'sequence_bloc.dart';

abstract class SequenceState extends Equatable {
  const SequenceState();
}

class SequenceInitial extends SequenceState {
  @override
  List<Object> get props => [];
}

class SequenceLoaded extends SequenceState {
  final SequenceBlock item;
  final BlockInfo blockInfo;

  SequenceLoaded(this.item, this.blockInfo);
  @override
  List<Object> get props => [item, blockInfo];
}

class SequenceError extends SequenceState {
  final String message;

  SequenceError({this.message});

  @override
  List<Object> get props => [message];
}
