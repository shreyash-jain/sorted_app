part of 'colossal_bloc.dart';

abstract class ColossalEvent extends Equatable {
  const ColossalEvent();
}

class UpdateColossal extends ColossalEvent {
  final BlockInfo block;
  UpdateColossal(this.block);

  @override
  List<Object> get props => [block];
}
