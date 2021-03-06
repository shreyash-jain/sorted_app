part of 'track_store_bloc.dart';

abstract class TrackStoreEvent extends Equatable {
  const TrackStoreEvent();
}

class GetMarketsEvent extends TrackStoreEvent {
  @override
  List<Object> get props => [];
}

class GetTracksListEvent extends TrackStoreEvent {
  final List<int> tracks;

  const GetTracksListEvent({this.tracks});
  @override
  List<Object> get props => [];
}
