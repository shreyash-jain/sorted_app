part of 'tab_tracks_bloc.dart';

abstract class TabTracksState extends Equatable {
  const TabTracksState();

  @override
  List<Object> get props => [];
}

class TabTracksInitial extends TabTracksState {}

class GetTabTracksLoadedState extends TabTracksState {
  final List<Track> tracksDetail;
  GetTabTracksLoadedState({this.tracksDetail});
}

class GetTabTracksLoadingState extends TabTracksState {}

class GetTabTracksFailedState extends TabTracksState {}
