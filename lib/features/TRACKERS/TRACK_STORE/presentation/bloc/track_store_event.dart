part of 'track_store_bloc.dart';

abstract class TrackStoreEvent extends Equatable {
  const TrackStoreEvent();
}

class GetMarketsEvent extends TrackStoreEvent {
  @override
  List<Object> get props => [];
}
