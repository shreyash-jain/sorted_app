import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/domain/repositories/track_store_repository.dart';

part 'leaderboard_event.dart';
part 'leaderboard_state.dart';

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  final TrackStoreRepository repository;
  LeaderboardBloc(this.repository) : super(LeaderboardInitial());

  @override
  Stream<LeaderboardState> mapEventToState(
    LeaderboardEvent event,
  ) async* {
    if (event is GetLeaderboardDataEvent) {
      print("FORM BLOC");
      yield GetLeaderboardDataLoadingState();
      final dataResult = await repository.getLeaderboardData();
      List<Map<String, dynamic>> data;
      bool failed = false;

      dataResult.fold(
        (failure) => failed = true,
        (result) => data = result,
      );
      List<Map<String, dynamic>> alltime_data = List<Map<String, dynamic>>();
      List<Map<String, dynamic>> last7_data = List<Map<String, dynamic>>();
      List<Map<String, dynamic>> last30_data = List<Map<String, dynamic>>();
      // all time data
      data.forEach((user) {
        Map<String, dynamic> new_user_data = Map<String, dynamic>();
        new_user_data["score"] = 0.0;
        user.entries.forEach((element) {
          if (element.key != "user" && element.key != "id") {
            new_user_data["score"] += element.value;
          } else {
            new_user_data[element.key] = element.value;
          }
        });
        alltime_data.add(new_user_data);
      });
      alltime_data.sort((a, b) => (b["score"]).compareTo(a["score"]));
      // last 7 days data
      DateTime currentTime = DateTime.now();
      data.forEach((user) {
        Map<String, dynamic> new_user_data = Map<String, dynamic>();
        new_user_data["score"] = 0.0;
        for (int i = 0; i < 7; i++) {
          DateTime new_time = currentTime.subtract(Duration(days: i));
          user.entries.forEach((element) {
            if (element.key != "user" && element.key != "id") {
              DateTime timeFromTs =
                  DateTime.fromMillisecondsSinceEpoch(int.parse(element.key));
              if (isSameDate(timeFromTs, new_time)) {
                new_user_data["score"] += element.value;
              }
            } else {
              new_user_data[element.key] = element.value;
            }
          });
        }
        last7_data.add(new_user_data);
      });
      last7_data.sort((a, b) => (b["score"]).compareTo(a["score"]));

      // last 30 days
      data.forEach((user) {
        Map<String, dynamic> new_user_data = Map<String, dynamic>();
        new_user_data["score"] = 0.0;
        for (int i = 0; i < 30; i++) {
          DateTime new_time = currentTime.subtract(Duration(days: i));
          user.entries.forEach((element) {
            if (element.key != "user" && element.key != "id") {
              DateTime timeFromTs =
                  DateTime.fromMillisecondsSinceEpoch(int.parse(element.key));
              if (isSameDate(timeFromTs, new_time)) {
                new_user_data["score"] += element.value;
              }
            } else {
              new_user_data[element.key] = element.value;
            }
          });
        }
        last30_data.add(new_user_data);
      });
      last30_data.sort((a, b) => (b["score"]).compareTo(a["score"]));

      if (failed) {
        yield GetLeaderboardDataFailedState();
      } else {
        yield GetLeaderboardDataLoadedState(
          alltime_data: alltime_data,
          last7_data: last7_data,
          last30_data: last30_data,
        );
      }
    }
  }
}

bool isSameDate(DateTime a, DateTime b) {
  return a.day == b.day && a.month == b.month && a.year == b.year;
}
