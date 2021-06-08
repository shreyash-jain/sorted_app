import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:sorted/features/TRACKERS/TRACK_STORE/domain/entities/log_multifill.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/domain/repositories/track_store_repository.dart';

part 'track_log_event.dart';
part 'track_log_state.dart';
class Util {
  static const List<String> monthsLabels = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  static String fromTimeToString(DateTime date) {
    return date.day.toString() +
        '-' +
        date.month.toString() +
        '-' +
        date.year.toString();
  }
}

class TrackLogBloc extends Bloc<TrackLogEvent, TrackLogState> {
  final TrackStoreRepository repository;
  TrackLogBloc(this.repository) : super(TrackLogInitial());

  Map<String, double> events = Map<String, double>();
  Map<String, Color> colors = Map<String, Color>();

  @override
  Stream<TrackLogState> mapEventToState(
    TrackLogEvent event,
  ) async* {
    if (event is GetTrackLogEvent) {
      print("FORM BLOC");
      yield GetTrackLogLoadingState();
      final logResult = await repository.getTrackLog();
      List<LogMultifill> logs;
      bool failed = false;

      logResult.fold(
        (failure) => failed = true,
        (result) => logs = result,
      );
      if (failed) {
        yield GetTrackLogFailedState();
      } else {
        _fromLogsToEvents(logs, 2);
        print("EVENTS = $events");
        print("COLORS = $colors");

        yield GetTrackLogLoadedState(
          events: events,
          colors: colors,
        );
      }
    }
  }

  _fromLogsToEvents(List<LogMultifill> logs, int option) {
    Color red = Colors.red;
    Color green = Colors.green;

    Map<String, double> nb = Map<String, double>();
    Map<String, double> confirmAvg = Map<String, double>();
    Map<String, double> confirmNb = Map<String, double>();

    // most recent
    if (option == 0) {
      logs.forEach((log) {
        DateTime date = DateTime.fromMillisecondsSinceEpoch(log.ts.toInt());
        String stringDate = Util.fromTimeToString(date);
        if (log.confirmation_value != null) {
          if (log.confirmation_value == 0) {
            colors[stringDate] = red;
          } else {
            colors[stringDate] = green;
          }
        }
        if (log.rating != null) {
          events[stringDate] = log.rating * 1.0 / 10;
        }
      });
    }
    // avg
    if (option == 1) {
      logs.forEach((log) {
        DateTime date = DateTime.fromMillisecondsSinceEpoch(log.ts.toInt());
        String stringDate = Util.fromTimeToString(date);
        if (log.confirmation_value != null) {
          if (log.confirmation_value == 0) {
            colors[stringDate] = red;
          } else {
            colors[stringDate] = green;
          }
        }
        if (log.rating != null) {
          if (events[stringDate] == null) {
            events[stringDate] = log.rating * 1.0 / 10;
            nb[stringDate] = 1;
          } else {
            events[stringDate] += log.rating * 1.0 / 10;
            nb[stringDate] += 1;
          }
        }
      });
      // calculate average
      events.forEach((key, value) {
        events[key] = events[key] / nb[key];
      });
    }
    const double MAX = 10;
    // sum
    if (option == 2) {
      logs.forEach((log) {
        DateTime date = DateTime.fromMillisecondsSinceEpoch(log.ts.toInt());
        String stringDate = Util.fromTimeToString(date);
        if (log.confirmation_value != null) {
          if (log.confirmation_value == 0) {
            colors[stringDate] = red;
          } else {
            colors[stringDate] = green;
          }
        }
        if (log.rating != null) {
          if (events[stringDate] == null) {
            events[stringDate] = log.rating * 1.0 / MAX;
          } else {
            events[stringDate] += log.rating * 1.0 / MAX;
          }
        }
      });
      events.forEach((key, value) {
        events[key] = min(events[key], 1.0);
      });
    }
    return;
  }
}

double min(double a, double b) {
  return a < b ? a : b;
}
