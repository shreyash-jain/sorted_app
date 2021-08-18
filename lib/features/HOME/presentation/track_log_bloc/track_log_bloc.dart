import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/widgets/slider_widget.dart';
import 'package:sorted/features/HOME/data/models/recipes/recipe.dart';
import 'package:sorted/features/HOME/domain/repositories/home_repository.dart';
import 'package:sorted/features/HOME/presentation/home_stories_bloc/home_stories_bloc.dart';
import 'package:sorted/features/HOME/presentation/widgets/performance_log/aim_reach_page.dart';
import 'package:sorted/features/HOME/presentation/widgets/performance_log/duration_log.dart';
import 'package:sorted/features/HOME/presentation/widgets/performance_log/number_log.dart';
import 'package:sorted/features/HOME/presentation/widgets/performance_log/rate_log.dart';
import 'package:sorted/features/HOME/presentation/widgets/performance_log/text_log.dart';
import 'package:sorted/features/HOME/presentation/widgets/performance_log/weight_log.dart';
import 'package:sorted/features/PLANNER/data/models/activity.dart';
import 'package:sorted/features/PLANNER/data/models/day_diets.dart';
import 'package:sorted/features/PLANNER/data/models/day_workout.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/activity_log.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/activity_settings.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/activity_summary.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/diet_log.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/diet_settings.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/diet_summary.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_summary.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_log.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_model.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_property_model.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_property_settings.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_user_settings.dart';
import 'package:sorted/features/TRACKERS/COMMON/performance_track_data/track_data.dart';
import 'package:sorted/features/TRACKERS/COMMON/performance_track_data/track_property_data.dart';
import 'package:sorted/features/TRACKERS/PERMORMANCE/domain/repositories/performance_repository.dart';
part 'track_log_event.dart';
part 'track_log_state.dart';

class PerformanceLogBloc extends Bloc<PerformanceEvent, PerformanceLogState> {
  final PerformanceRepository repository;
  final HomeRepository homeRepository;
  HomeStoriesBloc homeStoriesBloc;
  TrackLog currentLog;
  TrackSummary currentTrackSummary;

  PerformanceLogBloc(this.repository, this.homeRepository,
      {this.homeStoriesBloc})
      : super(PerformanceLogInitial());
  @override
  Stream<PerformanceLogState> mapEventToState(
    PerformanceEvent event,
  ) async* {
    if (event is LoadFromStory) {
      Failure failure;
      TrackSummary trackSummary = event.trackSummary;
      TrackModel track = event.track;
      BuildContext context = event.context;
      TrackUserSettings trackSettings;

      List<TrackPropertyModel> properties;
      List<TrackPropertySettings> propertySettings;
      sl<FirebaseAnalytics>().logEvent(
          name: 'TrackLog', parameters: {"trackId": track.id.toString()});
      if (homeStoriesBloc != null) {
        homeStoriesBloc.add(StartLoading(track));
      }

      properties = getAllProperties()
          .where((element) => (element.track_id == track.id))
          .toList();

      var trackSettingsResult = await repository.getTrackSettings(track.id);
      trackSettingsResult.fold((l) => failure = l, (r) => trackSettings = r);

      if (failure == null) {
        List propertyResult = await Future.wait([
          for (int i = 0; i < properties.length; i++)
            getPropertySettings(properties[i].track_id, properties[i].id),
        ]);

        if (propertyResult.length > 0)
          propertySettings =
              propertyResult.map((e) => e as TrackPropertySettings).toList();
        openBottomSheet(context, track, trackSettings, trackSummary, properties,
            propertySettings);

        // yield (PerformanceLogLoaded(
        //     track, trackSettings, trackSummary, properties, propertySettings));
      } else
        yield PerformanceLogError(Failure.mapToString(failure));

      if (homeStoriesBloc != null) {
        homeStoriesBloc.add(EndLoading(track));
      }
    } else if (event is LoadActivityStory) {
      Failure failure;
      TrackModel track = track_workout;
      sl<FirebaseAnalytics>()
          .logEvent(name: 'TrackLog', parameters: {"trackId": "2"});
      ActivityLogSettings settings;
      ActivityLogSummary summary = event.trackSummary; //
      int totalCalBurntToday = 0;
      try {
        totalCalBurntToday = double.parse(summary.calorieBurnt).toInt();
      } catch (e) {}

      List<ActivityModel> todayActivities = [];
      List<WorkoutModel> workouts = [];

      var trackSettingsResult = await repository.getActivityLogSettings();

      trackSettingsResult.fold((l) => failure = l, (r) => settings = r);

      List<ActivityLog> todayLogs = summary.activities
          .where((element) => isSameDate(element.time, DateTime.now()))
          .toList();
      totalCalBurntToday = 0;
      for (var i = 0; i < todayLogs.length; i++) {
        totalCalBurntToday += todayLogs[i].caloriesBurnt;
      }

      if (summary.activities.isNotEmpty) {
        try {
          List todayActivitiesResult = await Future.wait([
            for (int i = 0; i < todayLogs.length; i++)
              getActivityById(todayLogs[i].activityId),
          ]);

          if (todayActivitiesResult.length > 0)
            todayActivities = todayActivitiesResult.map((e) {
              var activity = e as ActivityModel;

              if (activity.id != -1) return activity;
            }).toList();
        } catch (e) {
          yield PerformanceLogError("Server Error");
        }
      }

      if (failure == null)
        yield ActivityLogLoaded(track, settings, summary, totalCalBurntToday,
            getWorkoutsFromLogs(todayActivities, todayLogs));
      else
        yield PerformanceLogError(Failure.mapToString(failure));
    } else if (event is LoadDietlogStory) {
      Failure failure;
      TrackModel track = track_workout;
      DietLogSettings settings;
      sl<FirebaseAnalytics>()
          .logEvent(name: 'TrackLog', parameters: {"trackId": "1"});
      DietLogSummary summary = event.trackSummary; //
      int totalCalBurntToday = 0;
      // try {
      //   totalCalBurntToday = double.parse(summary.calorieBurnt).toInt();
      // } catch (e) {}

      List<RecipeModel> todayActivities = [];
      List<DietModel> workouts = [];

      var trackSettingsResult = await repository.getDietLogSettings();

      trackSettingsResult.fold((l) => failure = l, (r) => settings = r);

      List<DietLog> todayLogs = summary.diets
          .where((element) => isSameDate(element.time, DateTime.now()))
          .toList();
      totalCalBurntToday = 0;
      for (var i = 0; i < todayLogs.length; i++) {
        totalCalBurntToday += todayLogs[i].calories.toInt();
      }

      if (summary.diets.isNotEmpty) {
        try {
          List todayActivitiesResult = await Future.wait([
            for (int i = 0; i < todayLogs.length; i++)
              getRecipeById(todayLogs[i].dietId),
          ]);

          if (todayActivitiesResult.length > 0)
            todayActivities = todayActivitiesResult.map((e) {
              var activity = e as RecipeModel;

              return activity;
            }).toList();
        } catch (e) {
          yield PerformanceLogError("Server Error");
        }
      }

      if (failure == null)
        yield DietLogLoaded(track, settings, summary, totalCalBurntToday,
            getDietsFromLogs(todayActivities, todayLogs));
      else
        yield PerformanceLogError(Failure.mapToString(failure));
    } else if (event is AddActivityLog) {
      var prevState = state as ActivityLogLoaded;
      int totalCalBurntToday = prevState.totalCalBurntToday;
      List<ActivityModel> todayActivities = List<ActivityModel>.from(
          prevState.todayActivities.map((e) => e.activity).toList());
      todayActivities.add(event.model);

      repository.addActivityLog(event.activity);
      ActivityLogSummary newSummary =
          updateActivitySummary(prevState.summary, event.activity);

      repository.setActivitySummary(newSummary);

      homeStoriesBloc.add(UpdateActivitySummary(newSummary));
      yield prevState.copyWith(
          summary: newSummary,
          totalCalBurntToday: totalCalBurntToday + event.activity.caloriesBurnt,
          todayActivities:
              getWorkoutsFromLogs(todayActivities, newSummary.activities));
    } else if (event is AddDietLog) {
      var prevState = state as DietLogLoaded;
      int totalCalBurntToday = prevState.totalCalTakenToday;
      List<DietModel> todayActivities =
          List<DietModel>.from(prevState.todayDiets.map((e) => e).toList());
      todayActivities.add(DietModel(
          recipeId: event.model.id,
          recipeImage: event.model.image_url,
          name: event.model.name,
          servingUnit: "Servings",
          daySlot: event.diet.daySlot,
          servings: event.diet.servings.toInt(),
          calories: event.diet.calories.toInt()));

      repository.addDietLog(event.diet);
      DietLogSummary newSummary =
          updateDietSummary(prevState.summary, event.diet);

      repository.setDietSummary(newSummary);

      homeStoriesBloc.add(UpdateDietSummary(newSummary));
      yield prevState.copyWith(
          summary: newSummary,
          totalCalTakenToday:
              (totalCalBurntToday + event.diet.calories).toInt(),
          todayDiets: todayActivities);
    }
  }

  bool isSameDate(DateTime thisDate, DateTime other) {
    return thisDate.year == other.year &&
        thisDate.month == other.month &&
        thisDate.day == other.day;
  }

  List<WorkoutModel> getWorkoutsFromLogs(
      List<ActivityModel> models, List<ActivityLog> logs) {
    List<WorkoutModel> workouts = [];

    int reps;
    for (var i = 0; i < models.length; i++) {
      reps = 0;
      try {
        reps = double.parse(logs[i].reps).toInt();
      } catch (e) {}
      if (models[i].id == -1) continue;
      workouts.add(WorkoutModel(
          activity: models[i],
          restTime: [30],
          activityType: models[i].is_yoga,
          sequence: [reps]));
    }
    return workouts;
  }

  List<DietModel> getDietsFromLogs(
      List<RecipeModel> models, List<DietLog> logs) {
    List<DietModel> workouts = [];

    int reps;
    for (var i = 0; i < models.length; i++) {
      if (models[i].id == -1) continue;
      workouts.add(DietModel(
          recipeId: models[i].id,
          recipeImage: models[i].image_url,
          name: models[i].name,
          servingUnit: "Servings",
          daySlot: logs[i].daySlot,
          servings: logs[i].servings.toInt(),
          calories: logs[i].calories.toInt()));
    }
    return workouts;
  }

  Future<ActivityModel> getActivityById(int activityId) async {
    ActivityModel activity = ActivityModel(id: -1);

    var result = await repository.getActivityById(activityId);
    result.fold((l) => null, (r) => activity = r);

    return activity;
  }

  Future<RecipeModel> getRecipeById(int recipeId) async {
    RecipeModel activity = RecipeModel(id: -1);

    var result = await homeRepository.getRecipeById(recipeId);
    result.fold((l) => null, (r) => activity = r);

    return activity;
  }

  Future<TrackPropertySettings> getPropertySettings(
      int trackId, int propertyId) async {
    TrackPropertySettings thisProperty;
    var result = await repository.getPropertySettings(propertyId, trackId);
    result.fold((l) {
      thisProperty = getAllDefaultPropertySettings().singleWhere(
          (element) => (element.property_id == propertyId),
          orElse: () => TrackPropertySettings());
    }, (r) => thisProperty = r);
    if (thisProperty.property_id == 0)
      thisProperty = getAllDefaultPropertySettings().singleWhere(
          (element) => (element.property_id == propertyId),
          orElse: () => TrackPropertySettings());
    return thisProperty;
  }

  openBottomSheet(
      BuildContext context,
      TrackModel track,
      TrackUserSettings trackSettings,
      TrackSummary trackSummary,
      List<TrackPropertyModel> properties,
      List<TrackPropertySettings> propertySettings) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModelState) {
            return Container(
              child: SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  child: Wrap(
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          ListTile(
                            leading: CachedNetworkImage(
                              errorWidget: (context, url, error) => Icon(
                                Icons.error,
                                color: Colors.grey,
                              ),
                              imageUrl: track.icon,
                              fit: BoxFit.cover,
                              height: 40,
                              width: 40,
                            ),
                            title: Gtheme.stext(track.name),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      Container(
                        height: 400,
                        child: PageView.builder(
                            itemBuilder: (context, position) {
                              return popertyTypeToWidget(properties[position],
                                  propertySettings[position], trackSummary);
                            },
                            itemCount: properties.length),
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MaterialButton(
                              color: Colors.grey.shade300,
                              elevation: 0,
                              minWidth: Gparam.width / 2,
                              height: 40,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              onPressed: () {
                                Navigator.pop(context);

                                if (currentLog != null &&
                                    currentTrackSummary != null) {
                                  repository.addTrackLog(currentLog);

                                  TrackModel thisTrack = getAllTracks()
                                      .firstWhere(
                                          (element) => (element.id ==
                                              currentLog.track_id),
                                          orElse: () => TrackModel(id: -1));
                                  if (thisTrack.id != -1 &&
                                      thisTrack.primary_property_id ==
                                          currentLog.property_id) {
                                    TrackSummary newSummary =
                                        updateTrackSummary(
                                            currentTrackSummary, currentLog);
                                    repository.setTrackSummary(newSummary);
                                    homeStoriesBloc
                                        .add(UpdateTrackSummary(newSummary));
                                    openGoalCompletedPopup(context, thisTrack);
                                  }
                                }
                              },
                              child: Gtheme.stext("Save")),
                        ],
                      ),
                      SizedBox(
                        height: 120,
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  Widget popertyTypeToWidget(TrackPropertyModel property,
      TrackPropertySettings settings, TrackSummary summary) {
    sl<FirebaseAnalytics>()
        .logEvent(name: 'TrackLogView', parameters: {"trackId": property.track_id.toString()});
    if (property.track_id == 3)
      return WeightLog(
        property: property,
        settings: settings,
        summary: summary,
        onLog: onLog,
      );
    switch (property.property_type) {
      case 1:
        {
          return TextLog(
            property: property,
            settings: settings,
            summary: summary,
            onLog: onLog,
          );
        }
      case 2:
        return NumberLog(
            property: property,
            settings: settings,
            summary: summary,
            onLog: onLog);
        break;
      case 3:
        return RateLog(
            property: property,
            settings: settings,
            summary: summary,
            onLog: onLog);
        break;
      case 4:
        return DurationLog(
            property: property,
            settings: settings,
            summary: summary,
            onLog: onLog);
        break;
      default:
        return Container(height: 0);
    }
  }

  onLog(TrackLog log, TrackSummary prevSummary) {
    currentLog = log;
    currentTrackSummary = prevSummary;
  }

  TrackSummary updateTrackSummary(TrackSummary prevSummary, TrackLog newLog) {
    String updatedValue = getUpdatedCurrentValue(prevSummary, newLog);

    List<TrackLog> logs = updateTrackLogInSummary(prevSummary, newLog);

    TrackSummary newSummary = TrackSummary(
        last_log: newLog.time,
        track_id: newLog.track_id,
        track_logs: logs,
        property_id: newLog.property_id,
        type: newLog.property_type,
        currentValue: updatedValue);
    return newSummary;
  }

  ActivityLogSummary updateActivitySummary(
      ActivityLogSummary summary, ActivityLog newLog) {
    String updatedValue = getUpdatedActivityCurrentValue(summary, newLog);

    List<ActivityLog> logs = updateActivityLogInSummary(summary, newLog);

    ActivityLogSummary newSummary = ActivityLogSummary(
        last_log: newLog.time, activities: logs, calorieBurnt: updatedValue);
    return newSummary;
  }

  DietLogSummary updateDietSummary(DietLogSummary summary, DietLog newLog) {
    String updatedValue = getUpdatedDietCurrentValue(summary, newLog);

    List<DietLog> logs = updateDietLogInSummary(summary, newLog);

    DietLogSummary newSummary = DietLogSummary(
        last_log: newLog.time, diets: logs, calorieTaken: updatedValue);
    return newSummary;
  }

  List<TrackLog> updateTrackLogInSummary(
      TrackSummary summary, TrackLog newLog) {
    if (summary.track_logs.length == 0) {
      return [newLog];
    }
    if (summary.track_logs.length >= 60) {
      List<TrackLog> newList = List<TrackLog>.from(summary.track_logs);
      newList.removeAt(0);
      newList.add(newLog);
      return newList;
    }
    List<TrackLog> newList = List<TrackLog>.from(summary.track_logs);
    newList.add(newLog);
    return newList;
  }

  List<ActivityLog> updateActivityLogInSummary(
      ActivityLogSummary summary, ActivityLog newLog) {
    if (summary.activities.length == 0) {
      return [newLog];
    }
    if (summary.activities.length >= 60) {
      List<ActivityLog> newList = List<ActivityLog>.from(summary.activities);
      newList.removeAt(0);
      newList.add(newLog);
      return newList;
    }
    List<ActivityLog> newList = List<ActivityLog>.from(summary.activities);
    newList.add(newLog);
    return newList;
  }

  List<DietLog> updateDietLogInSummary(DietLogSummary summary, DietLog newLog) {
    if (summary.diets.length == 0) {
      return [newLog];
    }
    if (summary.diets.length >= 60) {
      List<DietLog> newList = List<DietLog>.from(summary.diets);
      newList.removeAt(0);
      newList.add(newLog);
      return newList;
    }
    List<DietLog> newList = List<DietLog>.from(summary.diets);
    newList.add(newLog);
    return newList;
  }

  String getUpdatedCurrentValue(TrackSummary prevSummary, TrackLog newLog) {
    if (newLog.property_type == 1) {
      return newLog.value;
    } else if (newLog.property_type == 2) {
      TrackPropertyModel thisProp = getAllProperties()
          .firstWhere((element) => (element.id == newLog.property_id));

      if (thisProp.n_stat_condition == 0) {
        return newLog.value;
      } else if (thisProp.n_stat_condition == 1) {
        if (prevSummary.track_logs.length != 0) {
          if (sameDay(prevSummary.last_log, newLog.time)) {
            double value;
            try {
              value = double.parse(prevSummary.currentValue) +
                  double.parse(newLog.value);
            } catch (c) {
              value = 0.0;
            }
            return value.toStringAsFixed(thisProp.n_after_decimal);
          } else {
            double value;
            try {
              value = double.parse(newLog.value);
            } catch (c) {
              value = 0.0;
            }
            return value.toStringAsFixed(thisProp.n_after_decimal);
          }
        } else {
          double value;
          try {
            value = double.parse(newLog.value);
          } catch (c) {
            value = 0.0;
          }
          return value.toStringAsFixed(thisProp.n_after_decimal);
        }
      } else if (thisProp.n_stat_condition == 2) {
        if (prevSummary.track_logs.length != 0) {
          double sumOfDay = 0;
          int totalInDay = 0;
          for (var i = 0; i < prevSummary.track_logs.length; i++) {
            if (sameDay(prevSummary.track_logs[i].time, newLog.time)) {
              double value;
              try {
                value = double.parse(prevSummary.track_logs[i].value);
              } catch (c) {
                value = 0.0;
              }
              sumOfDay += value;
              totalInDay++;
            }
          }
          double logvalue;
          try {
            logvalue = double.parse(newLog.value);
          } catch (c) {
            logvalue = 0.0;
          }
          return ((sumOfDay + logvalue) / 1 + totalInDay)
              .toStringAsFixed(thisProp.n_after_decimal);
        } else {
          double value;
          try {
            value = double.parse(newLog.value);
          } catch (c) {
            value = 0.0;
          }
          return value.toStringAsFixed(thisProp.n_after_decimal);
        }
      }
    } else if (newLog.property_type == 3) {
      if (prevSummary.track_logs.length != 0) {
        double sumOfDay = 0;
        int totalInDay = 0;
        for (var i = 0; i < prevSummary.track_logs.length; i++) {
          if (sameDay(prevSummary.track_logs[i].time, newLog.time)) {
            double value;
            try {
              value = double.parse(prevSummary.track_logs[i].value);
            } catch (c) {
              value = 0.0;
            }
            sumOfDay += value;
            totalInDay++;
          }
        }
        double logvalue;
        try {
          logvalue = double.parse(newLog.value);
        } catch (c) {
          logvalue = 0.0;
        }
        return ((sumOfDay + logvalue) / (1 + totalInDay)).toStringAsFixed(0);
      } else {
        double value;
        try {
          value = double.parse(newLog.value);
        } catch (c) {
          value = 0.0;
        }
        return value.toStringAsFixed(0);
      }
    } else if (newLog.property_type == 4) {
      if (prevSummary.track_logs.length != 0) {
        if (sameDay(prevSummary.last_log, newLog.time)) {
          double value;
          try {
            value = double.parse(prevSummary.currentValue) +
                double.parse(newLog.value);
          } catch (c) {
            value = 0.0;
          }
          return value.toStringAsFixed(1);
        } else {
          double value;
          try {
            value = double.parse(newLog.value);
          } catch (c) {
            value = 0.0;
          }
          return value.toStringAsFixed(1);
        }
      } else {
        double value;
        try {
          value = double.parse(newLog.value);
        } catch (c) {
          value = 0.0;
        }
        return value.toStringAsFixed(1);
      }
    } else if (newLog.property_type == 5) {
      return newLog.value;
    } else {
      return newLog.value;
    }
  }

  String getUpdatedActivityCurrentValue(
      ActivityLogSummary prevSummary, ActivityLog newLog) {
    if (prevSummary.activities.length != 0) {
      if (sameDay(prevSummary.last_log, newLog.time)) {
        double value;
        try {
          value = double.parse(prevSummary.calorieBurnt) +
              (newLog.caloriesBurnt).toDouble();
        } catch (c) {
          value = 0.0;
        }
        return value.toStringAsFixed(0);
      } else {
        double value;
        try {
          value = newLog.caloriesBurnt.toDouble();
        } catch (c) {
          value = 0.0;
        }
        return value.toStringAsFixed(0);
      }
    } else {
      double value;
      try {
        value = newLog.caloriesBurnt.toDouble();
      } catch (c) {
        value = 0.0;
      }
      return value.toStringAsFixed(0);
    }
  }

  String getUpdatedDietCurrentValue(
      DietLogSummary prevSummary, DietLog newLog) {
    if (prevSummary.diets.length != 0) {
      if (sameDay(prevSummary.last_log, newLog.time)) {
        double value;
        try {
          value = double.parse(prevSummary.calorieTaken) +
              (newLog.calories).toDouble();
        } catch (c) {
          value = 0.0;
        }
        return value.toStringAsFixed(0);
      } else {
        double value;
        try {
          value = newLog.calories.toDouble();
        } catch (c) {
          value = 0.0;
        }
        return value.toStringAsFixed(0);
      }
    } else {
      double value;
      try {
        value = newLog.calories.toDouble();
      } catch (c) {
        value = 0.0;
      }
      return value.toStringAsFixed(0);
    }
  }

  bool sameDay(DateTime d1, DateTime d2) {
    return (d1.year == d2.year && d1.month == d2.month && d1.day == d2.day);
  }

  void openGoalCompletedPopup(BuildContext context, TrackModel track) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: GoalCompletedPopup(
            text: "Yay!! We reached closer to being fit, one step at a time",
            title: track.name,
            imageUrl: track.icon,
          ));
        });
  }
}
