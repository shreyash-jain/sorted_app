import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/domain/entities/track.dart';
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
      final trackResult = await repository.getTrackDetailsById(event.track_id);
      final colossalsResult =
          await repository.getColossalsByTrackId(event.track_id);
      final propertiesResult =
          await repository.getPropertiesByTrackId(event.track_id);
      final goalsResult = await repository.getGoalsByTrackId(event.track_id);

      Track track;
      List<String> colossals = [];
      List<TrackProperty> properties = [];
      List<TrackGoal> goals = [];
      bool failed = false;
      trackResult.fold(
        (f) => failed = true,
        (t) {
          track = t;
          failed = false;
        },
      );
      colossalsResult.fold(
        (failure) {
          print("Failed to get colossals");
        },
        (colos) => colossals = colos,
      );
      propertiesResult.fold(
        (failure) => failed = true,
        (props) => properties = props,
      );
      goalsResult.fold(
        (failure) => {},
        (gls) => goals = gls,
      );
      print("COLOSSALS = " + colossals.toString());
      if (failed) {
        yield GetSingleTrackFailedState();
      } else {
        yield GetSingleTrackLoadedState(
          trackDetails: track,
          colossals: colossals,
          trackProperties: properties,
          trackGoals: goals,
          trackComments: [],
        );
      }
    }
    if (event is SubscribeToTrackEvent) {
      yield SubscribeToTrackLoadingState();
      final subResult =
          await repository.subscribeToTrack(event.track, event.trackProps);
      bool failed = false;
      subResult.fold(
        (failure) => failed = true,
        (r) {},
      );
      print("FAILED " + failed.toString());
      if (failed) {
        yield SubscribeToTrackFailedState();
      } else {
        yield SubscribeToTrackLoadedState();
      }
    }
    if (event is UnsubscribeFromTrackEvent) {
      yield SubscribeToTrackLoadingState();
      final subResult = await repository.unsubscribeFromTrack(event.track_id);
      bool failed = false;
      subResult.fold(
        (failure) => failed = true,
        (r) {},
      );
      print("FAILED " + failed.toString());
      if (failed) {
        yield SubscribeToTrackFailedState();
      } else {
        yield SubscribeToTrackLoadedState();
      }
    }
    if (event is PauseTrackEvent) {
      yield SubscribeToTrackLoadingState();
      final pauseResult = await repository.pauseTrack(event.track);
      bool failed = false;
      pauseResult.fold(
        (failure) => failed = true,
        (r) {},
      );
      if (failed) {
        yield SubscribeToTrackFailedState();
      } else {
        yield SubscribeToTrackLoadedState();
      }
    }
  }
}
