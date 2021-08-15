import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/activity_summary.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/diet_summary.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_summary.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_details.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_model.dart';
import 'package:sorted/features/TRACKERS/COMMON/performance_track_data/track_data.dart';
import 'package:sorted/features/TRACKERS/PERMORMANCE/domain/repositories/performance_repository.dart';
part 'home_stories_event.dart';
part 'home_stories_state.dart';

class HomeStoriesBloc extends Bloc<HomeStoriesEvent, HomeStoriesState> {
  final PerformanceRepository repository;
  HomeStoriesBloc(this.repository) : super(HomeStoriesInitial());
  @override
  Stream<HomeStoriesState> mapEventToState(
    HomeStoriesEvent event,
  ) async* {
    if (event is LoadTrackStories) {
      Failure failure;

      UserTracks tracksIds = UserTracks(
          subscribed_ids: [1, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]);
      List<TrackModel> subTracks = [];
      List<TrackSummary> trackSummaries = [];
      List<bool> isLoading = [];
      ActivityLogSummary activityLogSummary;
      DietLogSummary dietLogSummary;

      var userTrackResult = await repository.getUserTracks();
      userTrackResult.fold((l) => failure = l, (r) {
        if (r.subscribed_ids.length > 0) tracksIds = r;
      });

      var dietSummartResult = await repository.getDietLogSummary();
      dietSummartResult.fold((l) => failure = l, (r) => dietLogSummary = r);
      var activitySummartResult = await repository.getActivityLogSummary();
      activitySummartResult.fold(
          (l) => failure = l, (r) => activityLogSummary = r);
      if (failure == null) {
        isLoading = List.filled(tracksIds.subscribed_ids.length, false);
        subTracks = getAllTracks()
            .where((element) => (tracksIds.subscribed_ids.contains(element.id)))
            .toList();
        try {
          List summaryResult = await Future.wait([
            for (int i = 0; i < subTracks.length; i++)
              getSummaryFromCloud(subTracks[i].id),
          ]);
          if (summaryResult.length > 0)
            trackSummaries =
                summaryResult.map((e) => e as TrackSummary).toList();

          yield HomeStoriesLoaded(subTracks, trackSummaries, isLoading,
              activityLogSummary, dietLogSummary);
        } catch (e) {
          yield HomeStoriesError(Failure.mapToString(failure));
        }
      } else
        yield HomeStoriesError(Failure.mapToString(failure));
    }

    if (event is StartLoading) {
      var prevState = state as HomeStoriesLoaded;
      if (!prevState.isLoading.contains(true)) {
        var trackIndex = prevState.subsTracks.indexOf(event.trackModel);

        if (trackIndex > -1) {
          var isLoadingList = List<bool>.from(prevState.isLoading);

          isLoadingList[trackIndex] = true;

          yield prevState.copyWith(isLoading: isLoadingList);
        }
      }
    }
    if (event is EndLoading) {
      var prevState = state as HomeStoriesLoaded;
      if (prevState.isLoading.contains(true)) {
        var trackIndex = prevState.subsTracks.indexOf(event.trackModel);

        if (trackIndex > -1) {
          var isLoadingList = List<bool>.from(prevState.isLoading);

          isLoadingList[trackIndex] = false;

          yield prevState.copyWith(isLoading: isLoadingList);
        }
      }
    } else if (event is UpdateTrackSummary) {
      var prevState = state as HomeStoriesLoaded;
      var trackModel = prevState.subsTracks.firstWhere(
          (element) => element.id == event.summary.track_id,
          orElse: () => TrackModel(id: -1));

      if (trackModel.id != -1) {
        var trackIndex = prevState.subsTracks.indexOf(trackModel);
        if (trackIndex > -1) {
          var newSummaries = List<TrackSummary>.from(prevState.trackSummaries);

          newSummaries[trackIndex] = event.summary;

          yield prevState.copyWith(trackSummaries: newSummaries);
        }
      }
    } else if (event is UpdateActivitySummary) {
      var prevState = state as HomeStoriesLoaded;

      yield prevState.copyWith(activityLogSummary: event.summary);
    } else if (event is UpdateDietSummary) {
      var prevState = state as HomeStoriesLoaded;

      yield prevState.copyWith(dietLogSummary: event.summary);
    }
  }

  Future<TrackSummary> getSummaryFromCloud(int trackId) async {
    TrackSummary thisSummary;
    var result = await repository.getTrackSummary(trackId);
    result.fold((l) => thisSummary = TrackSummary(), (r) => thisSummary = r);
    return thisSummary;
  }
}
