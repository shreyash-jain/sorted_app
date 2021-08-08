import 'dart:async';
import 'dart:collection';
import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/features/CONNECT/data/models/client_consultation_model.dart';
import 'package:sorted/features/CONNECT/domain/repositories/connect_repository.dart';
import 'package:sorted/features/HOME/data/models/class_model.dart';
import 'package:sorted/features/PLANNER/data/models/activity.dart';
import 'package:sorted/features/PLANNER/data/models/day_workout.dart';
import 'package:sorted/features/PLANNER/data/models/workout_plan.dart';
import 'package:sorted/features/PLANNER/domain/entities/workout_plan_entity.dart';
part 'workout_plan_event.dart';
part 'workout_plan_state.dart';

class WorkoutPlanBloc extends Bloc<WorkoutPlanEvent, WorkoutPlanState> {
  final ConnectRepository connectRepository;
  WorkoutPlanBloc(this.connectRepository) : super(WorkoutPlanInitial());

  @override
  Stream<WorkoutPlanState> mapEventToState(
    WorkoutPlanEvent event,
  ) async* {
    if (event is LoadWorkoutPlan) {
      print("parsed json ");

      WorkoutPlanModel data = event.plan;
      print("parsed json ");

      List<DayWorkout> dayWorkouts = [];
      List<int> indexList = List<int>.generate(getPlanLength(data), (index) {
        int obj = index;

        return obj;
      });

      var workoutResult = await Future.wait(
          indexList.map((i) => getCompletedDayWorkout(data, i + 1)));
      dayWorkouts = workoutResult;

      // for (var i = 1; i <= data.length; i++) {
      //   DayDiet thisDiets = getCompletedDayDiet(data, i);
      //   print("index " + i.toString());
      //   print(thisDiets.dayBreakfastDiets.toString());

      //   dayDiets.add(thisDiets);
      // }

      yield WorkoutPlanLoaded(
          workoutEntity: WorkoutPlanEntitiy(
              planLength: data.length,
              id: data.id,
              dayWorkouts: dayWorkouts,
              planName: data.name,
              planImage: data.name,
              startDate: data.startDate));
    } else if (event is LoadWorkoutBoard) {
      List<DayWorkout> dayWorkouts = event.workoutPlan.dayWorkouts;

      LinkedHashMap<int, List<ActivityItem>> activityBoard;
      activityBoard = LinkedHashMap();

      if (dayWorkouts.length == 0) {
        dayWorkouts.add(DayWorkout(dayTitle: "Day 1", dayActivities: []));
      }

      for (var i = 0; i < dayWorkouts.length; i++) {
        List<WorkoutModel> activities = dayWorkouts[i].dayActivities;

        List<ActivityItem> boardActivities = [];

        for (var j = 0; j < activities.length; j++) {
          boardActivities.add(ActivityItem(
              id: activities[j].activity.id,
              listId: i,
              activity: activities[j]));
        }

        activityBoard.addAll({
          i: boardActivities,
        });
      }
      yield WorkoutBoardLoaded(activityBoard);
    } else if (event is LoadWorkoutList) {
      if (event.type == 0) {
        yield await getStateForClassroom(event.classroom);
      }
    } else if (event is LoadCurrentWorkoutPlan) {
      print("parsed json ");
      List<WorkoutPlanModel> plans = [];
      List<WorkoutPlanEntitiy> entities = [];
      Failure failure;
      var workoutResult;
      if (event.type == 0) {
        workoutResult =
            await connectRepository.getClassWorkoutPlans(event.classroom);

        workoutResult.fold((l) => failure = l, (r) {
          plans = r;
        });
      } else {
        //Todo: for consultation
      }

      if (failure == null) {
        if (plans.length > 0) {
          WorkoutPlanModel data = plans[0];
          print("parsed json ");

          List<DayWorkout> dayWorkouts = [];

          List<int> indexList =
              List<int>.generate(getPlanLength(plans[0]), (index) {
            int obj = index;

            return obj;
          });

          var workoutResult = await Future.wait(
              indexList.map((i) => getCompletedDayWorkout(data, i + 1)));
          dayWorkouts = workoutResult;

          // for (var i = 1; i <= data.length; i++) {
          //   DayDiet thisDiets = getCompletedDayDiet(data, i);
          //   print("index " + i.toString());
          //   print(thisDiets.dayBreakfastDiets.toString());

          //   dayDiets.add(thisDiets);
          // }

          yield WorkoutPlanLoaded(
              workoutEntity: WorkoutPlanEntitiy(
                  planLength: data.length,
                  dayWorkouts: dayWorkouts,
                  id: data.id,
                  planName: data.name,
                  planImage: data.name,
                  startDate: data.startDate));
        } else {
          yield WorkoutPlanEmpty();
        }
      } else {
        yield WorkoutPlanError(Failure.mapToString(failure));
      }
    } else if (event is SaveClassWorkoutPlan) {
    } else if (event is LoadWorkoutEntity) {
      if (state is WorkoutPlanLoaded)
        yield WorkoutPlanLoaded(workoutEntity: event.plan);
    }
  }

  WorkoutPlanModel storeWorkoutData(
      WorkoutPlanModel input, int day, String activities, String reps) {
    WorkoutPlanModel output = input;
    switch (day) {
      case 0:
        return output
            .copyWith(day1name: "Monday")
            .copyWith(day1activityIds: activities)
            .copyWith(day1reps: reps);

        break;
      case 1:
        return output
            .copyWith(day2name: "Tuesday")
            .copyWith(day2activityIds: activities)
            .copyWith(day2reps: reps);

        break;
      case 2:
        return output
            .copyWith(day3name: "Wednesday")
            .copyWith(day3activityIds: activities)
            .copyWith(day3reps: reps);

        break;
      case 3:
        return output
            .copyWith(day4name: "Thrusday")
            .copyWith(day4activityIds: activities)
            .copyWith(day4reps: reps);

        break;
      case 4:
        return output
            .copyWith(day5name: "Friday")
            .copyWith(day5activityIds: activities)
            .copyWith(day5reps: reps);

        break;
      case 5:
        return output
            .copyWith(day6name: "Saturday")
            .copyWith(day6activityIds: activities)
            .copyWith(day6reps: reps);

        break;
      case 6:
        return output
            .copyWith(day7name: "Sunday")
            .copyWith(day7activityIds: activities)
            .copyWith(day7reps: reps);

        break;
      default:
        return output;
    }
  }

  int getPlanLength(WorkoutPlanModel plan) {
    if (plan.day7activityIds != "")
      return 7;
    else if (plan.day6activityIds != "")
      return 6;
    else if (plan.day5activityIds != "")
      return 5;
    else if (plan.day4activityIds != "")
      return 4;
    else if (plan.day3activityIds != "")
      return 3;
    else if (plan.day2activityIds != "")
      return 2;
    else if (plan.day1activityIds != "")
      return 1;
    else
      return 0;
  }

  Future<WorkoutModel> getUpdatedActivity(WorkoutModel activity) async {
    Failure failure;
    ActivityModel thisActivity;
    WorkoutModel newActivity = activity;

    var result =
        await connectRepository.getActivityById(newActivity.activity.id);
    result.fold((l) => failure = l, (r) => thisActivity = r);
    if (failure == null)
      newActivity.activity = thisActivity;
    else
      newActivity.activity = newActivity.activity.copyWith(
          image_url:
              "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/Placeholders%2Fbibimbap.png?alt=media&token=95d7ad83-7c40-4135-9158-cfdd33f82f1d");

    //Todo:  add calorie and serving unit
    return newActivity;
  }

  Future<DayWorkout> getCompletedDayWorkout(
      WorkoutPlanModel data, int i) async {
    DayWorkout thisDayActivity = getDayWorkoutFromIndex(data, i);
    print("workout index " + i.toString());

    if (data.length == 7)
      thisDayActivity.daySubTitle = getDayName(i);
    else
      thisDayActivity.daySubTitle = "Day $i";
    var workoutResult = await Future.wait(
        thisDayActivity.dayActivities.map((i) => getUpdatedActivity(i)));
    thisDayActivity.dayActivities = workoutResult;

    // }

    thisDayActivity.id = i;
    return thisDayActivity;
  }

  DayWorkout getDayWorkoutFromIndex(WorkoutPlanModel data, int i) {
    switch (i) {
      case 1:
        List<WorkoutModel> activities =
            getWorkout(data.day1activityIds, data.day1reps);

        return DayWorkout(
            dayActivities: activities, daySubTitle: data.day1name);
        break;
      case 2:
        List<WorkoutModel> activities =
            getWorkout(data.day2activityIds, data.day2reps);

        return DayWorkout(
            dayActivities: activities, daySubTitle: data.day2name);
        break;
      case 3:
        List<WorkoutModel> activities =
            getWorkout(data.day3activityIds, data.day3reps);

        return DayWorkout(
            dayActivities: activities, daySubTitle: data.day3name);
        break;
      case 4:
        List<WorkoutModel> activities =
            getWorkout(data.day4activityIds, data.day4reps);

        return DayWorkout(
            dayActivities: activities, daySubTitle: data.day4name);
        break;
      case 5:
        List<WorkoutModel> activities =
            getWorkout(data.day5activityIds, data.day5reps);

        return DayWorkout(
            dayActivities: activities, daySubTitle: data.day5name);
        break;
      case 6:
        List<WorkoutModel> activities =
            getWorkout(data.day6activityIds, data.day6reps);

        return DayWorkout(
            dayActivities: activities, daySubTitle: data.day6name);
        break;
      case 7:
        List<WorkoutModel> activities =
            getWorkout(data.day7activityIds, data.day7reps);

        return DayWorkout(
            dayActivities: activities, daySubTitle: data.day7name);
        break;
      default:
        return DayWorkout();
    }
  }

  Map<String, dynamic> getStringsFromDayWorkout(List<ActivityItem> activities) {
    String activitieString = "[";
    String reps = "[";

    for (int i = 0; i < activities.length; i++) {
      if (i != activities.length - 1)
        activitieString += "${activities[i].activity.activity.id},";
      else
        activitieString += "${activities[i].activity.activity.id}]";
      for (int j = 0; j < activities[i].activity.sequence.length; j++) {
        reps +=
            "${activities[i].activity.activity.id}:[${activities[i].activity.sequence[j]},0],";
      }
    }
    if (reps.length > 1) {
      reps = reps.substring(0, reps.length - 1);
    }
    reps += "]";

    return {
      "data": {"activities": activitieString, "reps": reps}
    };
  }

  List<WorkoutModel> getWorkout(String activityIds, String reps) {
    List<WorkoutModel> activities = [];
    var activitySubString = activityIds.substring(1, activityIds.length - 1);
    print(activitySubString + " activitySubString ");

    var activityIdList = activitySubString.split(',').toList();
    var sequence = reps.substring(1, reps.length - 1).split(',').toList();
    for (var i = 0; i < activityIdList.length; i++) {
      List<int> activitySets = [];
      try {
        for (int j = 0; j < sequence.length; j++) {
          if ((sequence[j].split(':')?.toList())[0] != null &&
              (sequence[j].split(':').toList())[0] == activityIdList[i]) {
            try {
              // activitySets.addAll([10, 12, 12]);
              print("hhhhhhh  " + (sequence[j]));
              print("hhhhhhh  " + (sequence[j].split(':').toList())[0]);
              print("hhhhhhh  " + (sequence[j].split(':').toList())[1]);

              int numReps = int.parse((sequence[j].split(':').toList())[1]
                  .substring(1)
                  .split(',')[0]);
              activitySets.add(numReps);
            } on Exception {
              activitySets.addAll([10]);
            }
          }
        }
      } on Exception {
        activitySets.addAll([10, 12, 12]);
      }

      activities.add(WorkoutModel(
        activity: ActivityModel(id: int.parse(activityIdList[i])),
        sequence: activitySets,
        activityType: 0,
        restTime: List.filled(activitySets.length, 30),
      ));
    }
    return activities;
  }

  String getDayName(int i) {
    switch (i) {
      case 1:
        return "Monday";
        break;
      case 2:
        return "Tuesday";
        break;
      case 3:
        return "Wednesday";
        break;
      case 4:
        return "Thrusday";
        break;
      case 5:
        return "Friday";
        break;
      case 6:
        return "Saturday";
        break;
      case 7:
        return "Sunday";
        break;
      default:
        return "";
    }
  }

  Future<WorkoutPlanState> getStateForClassroom(ClassModel classroom) async {
    WorkoutPlanState state;
    List<WorkoutPlanModel> plans = [];
    List<WorkoutPlanEntitiy> entities = [];
    Failure failure;
    var workoutResult = await connectRepository.getClassWorkoutPlans(classroom);

    workoutResult.fold((l) => failure = l, (r) {
      plans = r;
    });

    if (failure == null) {
      return WorkoutPlanListState(plans);
    } else {
      return WorkoutPlanError(Failure.mapToString(failure));
    }
  }
}

class ActivityItem {
  final int id;
  int listId;

  final WorkoutModel activity;
  ActivityItem({this.id, this.listId, this.activity});
}
