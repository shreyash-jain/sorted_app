import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/features/HOME/data/models/motivation/pep_talks.dart';
import 'package:sorted/features/HOME/domain/repositories/home_repository.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_model.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_summary.dart';
import 'package:sorted/features/TRACKERS/COMMON/performance_track_data/track_data.dart';
import 'package:sorted/features/TRACKERS/PERMORMANCE/domain/repositories/performance_repository.dart';
part 'fit_info_event.dart';
part 'fit_info_state.dart';

class FitInfoBloc extends Bloc<FitInfoEvent, FitInfoState> {
  final HomeRepository repository;
  final PerformanceRepository performanceRepository;
  FitInfoBloc(this.repository, this.performanceRepository)
      : super(FitInfoInitial());
  @override
  Stream<FitInfoState> mapEventToState(
    FitInfoEvent event,
  ) async* {
    if (event is GetTrackUrls) {
      Failure failure;
      TrackSummary summary;
      var result = getAllTracks()
          .where((element) => element.carousel.length > 0)
          .toList();
      var today = DateTime.now().day;
      var track = result[today % result.length];
      var summaryResult = await performanceRepository.getTrackSummary(track.id);
      summaryResult.fold((l) => failure = l, (r) => summary = r);

      if (failure == null) {
        yield FitInfoLoaded(track.carousel, track, summary);
      } else
        yield FitInfoError(Failure.mapToString(failure));
    }
  }
}
