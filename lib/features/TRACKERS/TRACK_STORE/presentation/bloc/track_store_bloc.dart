import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/domain/repositories/track_store_repository.dart';

part 'track_store_event.dart';
part 'track_store_state.dart';

class TrackStoreBloc extends Bloc<TrackStoreEvent, TrackStoreState> {
  final TrackStoreRepository repository;
  TrackStoreBloc(this.repository) : super(TrackStoreInitial());
  @override
  Stream<TrackStoreState> mapEventToState(
    TrackStoreEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
