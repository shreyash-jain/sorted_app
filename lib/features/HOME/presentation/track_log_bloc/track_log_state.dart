part of 'track_log_bloc.dart';

abstract class PerformanceLogState extends Equatable {
  const PerformanceLogState();
}

class PerformanceLogInitial extends PerformanceLogState {
  @override
  List<Object> get props => [];
}

// class PerformanceLogLoaded extends PerformanceLogState {
//   final TrackModel track;
//   final TrackUserSettings trackSettings;
//   final TrackSummary trackSummary;
//   final List<TrackPropertyModel> properties;
//   final List<TrackPropertySettings> propertySettings;

//   PerformanceLogLoaded(this.track, this.trackSettings, this.trackSummary,
//       this.properties, this.propertySettings);

//   @override
//   List<Object> get props =>
//       [track, trackSettings, trackSummary, properties, propertySettings];
// }

class ActivityLogLoaded extends PerformanceLogState {
  final TrackModel track;
  final ActivityLogSettings settings;
  final ActivityLogSummary summary;
  final int totalCalBurntToday;
  final List<WorkoutModel> todayActivities;

  ActivityLogLoaded(this.track, this.settings, this.summary,
      this.totalCalBurntToday, this.todayActivities);

  @override
  List<Object> get props =>
      [track, settings, summary, totalCalBurntToday, todayActivities];

  ActivityLogLoaded copyWith({
    TrackModel track,
    ActivityLogSettings settings,
    ActivityLogSummary summary,
    int totalCalBurntToday,
    List<WorkoutModel> todayActivities,
  }) {
    return ActivityLogLoaded(
      track ?? this.track,
      settings ?? this.settings,
      summary ?? this.summary,
      totalCalBurntToday ?? this.totalCalBurntToday,
      todayActivities ?? this.todayActivities,
    );
  }
}

class DietLogLoaded extends PerformanceLogState {
  final TrackModel track;
  final DietLogSettings settings;
  final DietLogSummary summary;
  final int totalCalTakenToday;
  final List<DietModel> todayDiets;

  DietLogLoaded(this.track, this.settings, this.summary,
      this.totalCalTakenToday, this.todayDiets);

  @override
  List<Object> get props => [track, settings, summary, totalCalTakenToday, todayDiets];

  DietLogLoaded copyWith({
    TrackModel track,
    DietLogSettings settings,
    DietLogSummary summary,
    int totalCalTakenToday,
    List<DietModel> todayDiets,
  }) {
    return DietLogLoaded(
      track ?? this.track,
      settings ?? this.settings,
      summary ?? this.summary,
      totalCalTakenToday ?? this.totalCalTakenToday,
      todayDiets ?? this.todayDiets,
    );
  }
}

class PerformanceLogError extends PerformanceLogState {
  final String message;

  PerformanceLogError(this.message);
  @override
  List<Object> get props => [message];
}
