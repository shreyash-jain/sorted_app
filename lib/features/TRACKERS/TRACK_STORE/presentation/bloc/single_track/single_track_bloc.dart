import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/domain/repositories/track_store_repository.dart';
import '../../../domain/entities/track_comment.dart';
import '../../../domain/entities/track_property.dart';
import '../../../domain/entities/track_goal.dart';
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
      final propertiesResult =
          await repository.getPropertiesByTrackId(event.track_id);
      final goalsResult = await repository.getGoalsByTrackId(event.track_id);
      List<String> colossals;
      List<TrackProperty> properties;
      List<TrackGoal> goals;
      bool failed = false;
      colossalsResult.fold(
        (failure) => failed = true,
        (colos) => colossals = colos,
      );
      propertiesResult.fold(
        (failure) => failed = true,
        (props) => properties = props,
      );
      goalsResult.fold(
        (failure) => failed = true,
        (gls) => goals = gls,
      );
      if (failed) {
        yield GetSingleTrackFailedState();
      } else {
        yield GetSingleTrackLoadedState(
          colossals: colossals,
          trackProperties: properties,
          trackGoals: goals,
          trackComments: [],
        );
      }
    }
  }
}
