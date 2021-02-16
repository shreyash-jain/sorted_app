part of 'track_store_bloc.dart';
abstract class TrackStoreState extends Equatable {
  const TrackStoreState();
}
class TrackStoreInitial extends TrackStoreState {
  @override
  List<Object> get props => [];
}
