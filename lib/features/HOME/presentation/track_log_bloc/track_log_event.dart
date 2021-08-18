part of 'track_log_bloc.dart';

abstract class PerformanceEvent extends Equatable {
  const PerformanceEvent();
  @override
  List<Object> get props => [];
}

class LoadFromStory extends PerformanceEvent {
  final TrackSummary trackSummary;
  final TrackModel track;
  final BuildContext context;

  LoadFromStory(this.trackSummary, this.track, this.context);
  @override
  List<Object> get props => [trackSummary, track, context];
}

class LoadActivityStory extends PerformanceEvent {
  final ActivityLogSummary trackSummary;

  LoadActivityStory(this.trackSummary);
  @override
  List<Object> get props => [trackSummary];
}

class LoadDietlogStory extends PerformanceEvent {
  final DietLogSummary trackSummary;

  LoadDietlogStory(this.trackSummary);
  @override
  List<Object> get props => [trackSummary];
}

class AddActivityLog extends PerformanceEvent {
  final ActivityLog activity;
  final ActivityModel model;

  AddActivityLog(this.activity, this.model);

  @override
  List<Object> get props => [activity, model];
}


class AddDietLog extends PerformanceEvent {
  final DietLog diet;
  final RecipeModel model;

  AddDietLog(this.diet, this.model);

  @override
  List<Object> get props => [diet, model];
}
