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
  final List<ImageModel> images;
  final BlockInfo blockInfo;

  ColossalLoaded(this.images, this.blockInfo, this.colossal);
  @override
  List<Object> get props => [images, blockInfo, colossal];
}

class TodoError extends ColossalState {
  final String message;

  TodoError({this.message});

  @override
  List<Object> get props => [message];
}
