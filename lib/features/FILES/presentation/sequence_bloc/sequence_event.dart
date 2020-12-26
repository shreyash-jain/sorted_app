part of 'sequence_bloc.dart';

abstract class SequenceEvent extends Equatable {
  const SequenceEvent();
}

class GetSequence extends SequenceEvent {
  final BlockInfo block;
  GetSequence(this.block);

  @override
  List<Object> get props => [block];
}

class UpdateItem extends SequenceEvent {
  final SequenceBlock item;
  UpdateItem(this.item);

  @override
  List<Object> get props => [item];
}

