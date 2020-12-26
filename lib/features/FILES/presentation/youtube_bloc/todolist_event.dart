part of 'todolist_bloc.dart';

abstract class YoutubeEvent extends Equatable {
  const YoutubeEvent();
}

class GetVideo extends YoutubeEvent {
  final BlockInfo block;
  GetVideo(this.block);

  @override
  List<Object> get props => [block];
}
