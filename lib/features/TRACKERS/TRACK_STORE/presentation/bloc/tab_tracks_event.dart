part of 'tab_tracks_bloc.dart';

abstract class TabTracksEvent extends Equatable {
  const TabTracksEvent();

  @override
  List<Object> get props => [];
}

class GetTabTracksEvent extends TabTracksEvent {
  final List<int> tracks;
  const GetTabTracksEvent({this.tracks});
}
