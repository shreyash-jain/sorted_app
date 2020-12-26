part of 'colossal_bloc.dart';

abstract class ColossalState extends Equatable {
  const ColossalState();
}

class ColossalInitial extends ColossalState {
  @override
  List<Object> get props => [];
}

class ColossalLoaded extends ColossalState {
  final ColossalBlock colossal;
  final List<ImageBlock> images;
  final BlockInfo blockInfo;
  final List<bool> doLocalExist;

  ColossalLoaded(this.images, this.blockInfo, this.colossal, this.doLocalExist);
  @override
  List<Object> get props => [images, blockInfo, colossal, doLocalExist];
}

class ColossalError extends ColossalState {
  final String message;

  ColossalError({this.message});

  @override
  List<Object> get props => [message];
}
