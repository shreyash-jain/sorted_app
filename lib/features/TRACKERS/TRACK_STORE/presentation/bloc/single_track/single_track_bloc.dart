import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/domain/repositories/track_store_repository.dart';
import '../../../domain/entities/track_comment.dart';
part 'single_track_event.dart';
part 'single_track_state.dart';

class SingleTrackBloc extends Bloc<SingleTrackEvent, SingleTrackState> {
  final TrackStoreRepository repository;
  SingleTrackBloc(this.repository) : super(SingleTrackInitial());

  @override
  Stream<SingleTrackState> mapEventToState(
    SingleTrackEvent event,
  ) async* {
    if (event is GetSingleTrackEvent) {
      yield GetSingleTrackLoadingState();
      final colossalsResult =
          await repository.getColossalsByTrackId(event.track_id);
      List<String> colossals;
      bool failed = false;
      colossalsResult.fold(
        (failure) => failed = true,
        (colos) => colossals = colos,
      );
      if (failed) {
        yield GetSingleTrackFailedState();
      } else {
        yield GetSingleTrackLoadedState(
          colossals: colossals,
          trackComments: [],
        );
      }
    }
  }
}
