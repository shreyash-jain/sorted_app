part of 'todolist_bloc.dart';

abstract class YoutubeState extends Equatable {
  const YoutubeState();
}

class YoutubeInitial extends YoutubeState {
  @override
  List<Object> get props => [];
}

class YoutubeLoaded extends YoutubeState {
  final YoutubeBlock item;

  final BlockInfo blockInfo;

  YoutubeLoaded(this.blockInfo, this.item);
  @override
  List<Object> get props => [item, blockInfo];
}

class YoutubeError extends YoutubeState {
  final String message;

  YoutubeError({this.message});

  @override
  List<Object> get props => [message];
}
