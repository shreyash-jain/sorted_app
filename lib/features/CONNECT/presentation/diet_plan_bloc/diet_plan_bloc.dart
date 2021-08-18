import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/models/health_profile.dart';
import 'package:sorted/features/CONNECT/data/models/client_consultation_model.dart';
import 'package:sorted/features/CONNECT/domain/entities/diet_plan_entity.dart';
import 'package:sorted/features/CONNECT/domain/repositories/connect_repository.dart';
import 'package:sorted/features/HOME/data/models/recipes/recipe.dart';
import 'package:sorted/features/HOME/domain/repositories/home_repository.dart';
import 'package:sorted/features/PLANNER/data/datasources/static_data.dart';
import 'package:sorted/features/PLANNER/data/models/day_diets.dart';
import 'package:sorted/features/PLANNER/data/models/diet_plan.dart';
import 'package:sorted/features/USER_INTRODUCTION/domain/repositories/user_intro_repository.dart';
part 'diet_plan_event.dart';
part 'diet_plan_state.dart';

class DietPlanBloc extends Bloc<DietPlanEvent, DietPlanState> {
  final ConnectRepository connectRepository;
  final HomeRepository homeRepository;
  final UserIntroductionRepository introductionRepository;
  final _random = new Random();
  DietPlanBloc(
      this.connectRepository, this.homeRepository, this.introductionRepository)
      : super(DietPlanInitial());

  @override
  Stream<DietPlanState> mapEventToState(
    DietPlanEvent event,
  ) async* {
    if (event is LoadCurrentDietPlan) {
      print("parsed json ");
      List<DietPlanModel> plans = [];
      Failure failure;

      var dietResult =
          await connectRepository.getConsultationDietPlans(event.consultation);
      dietResult.fold((l) => failure = l, (r) {
        plans = r;
      });
      if (failure == null) {
        if (plans.length > 0) {
          DietPlanModel currentPlan = plans[plans.length - 1];
          List<String> foodsToAvoid = [];
          if (currentPlan.foodsToAvoid != "")
            foodsToAvoid = json
                .decode(currentPlan.foodsToAvoid.replaceAll("'", '"'))
                .cast<String>();

          print("parsed json " + foodsToAvoid.toString());
          List<String> foodsToEat = [];
          if (currentPlan.foodsToEat != "")
            List<String> foodsToEat = json
                .decode(currentPlan.foodsToEat.replaceAll("'", '"'))
                .cast<String>();
          print("parsed json " + foodsToEat.toString());
          currentPlan =
              currentPlan.copyWith(length: getPlanLength(currentPlan));

          List<DayDiet> dayDiets = [];
          List<int> indexList = List<int>.generate(currentPlan.length, (index) {
            int obj = index;

            return obj;
          });

          var dietsResult = await Future.wait(
              indexList.map((i) => getCompletedDayDiet(currentPlan, i + 1)));
          dayDiets = dietsResult;

          DietPlanEntitiy newPlanEntitiy = DietPlanEntitiy(
              planLength: currentPlan.length,
              dayDiets: dayDiets,
              planImage: currentPlan.name,
              foodsToAvoid: foodsToAvoid,
              foodsToEat: foodsToEat,
              snacks: currentPlan.snacks,
              startDate: currentPlan.startDate,
              drinks: currentPlan.drinks);
          yield DietPlanLoaded(newPlanEntitiy);
        } else {
          yield DietPlanEmpty();
        }
      } else {
        yield DietPlanError(Failure.mapToString(failure));
      }
    }

    if (event is LoadDietPlan) {
      print("parsed json ");

      DietPlanModel currentPlan = event.plan;
      List<String> foodsToAvoid = [];
      List<String> foodsToEat = [];

      if (currentPlan.foodsToAvoid != "")
        foodsToAvoid = json
            .decode(currentPlan.foodsToAvoid.replaceAll("'", '"'))
            .cast<String>();

      print("parsed json " + foodsToAvoid.toString());
      if (currentPlan.foodsToEat != "")
        List<String> foodsToEat = json
            .decode(currentPlan.foodsToEat.replaceAll("'", '"'))
            .cast<String>();
      print("parsed json " + foodsToEat.toString());
      currentPlan = currentPlan.copyWith(length: getPlanLength(currentPlan));
      List<DayDiet> dayDiets = [];
      List<int> indexList = List<int>.generate(currentPlan.length, (index) {
        int obj = index;

        return obj;
      });
      var dietsResult = await Future.wait(
          indexList.map((i) => getCompletedDayDiet(currentPlan, i + 1)));
      dayDiets = dietsResult;

      // for (var i = 1; i <= data.length; i++) {
      //   DayDiet thisDiets = getCompletedDayDiet(data, i);
      //   print("index " + i.toString());
      //   print(thisDiets.dayBreakfastDiets.toString());

      //   dayDiets.add(thisDiets);
      // }
      DietPlanEntitiy newPlanEntitiy = DietPlanEntitiy(
          planLength: currentPlan.length,
          dayDiets: dayDiets,
          planImage: currentPlan.name,
          foodsToAvoid: foodsToAvoid,
          foodsToEat: foodsToEat,
          snacks: currentPlan.snacks,
          startDate: currentPlan.startDate,
          drinks: currentPlan.drinks);
      yield DietPlanLoaded(newPlanEntitiy);
    } else if (event is LoadConsultationDietplanList) {
      yield await getStateForConsultation(event.consultation);
    } else if (event is GetRecommendedDietPlan) {
      Failure failure;
      DietPlanModel plan = dietPlan;
      HealthProfile healthProfile;
      List<DietPlanModel> dietPlanModels = [];
      var profileResult = await introductionRepository.getHealthProfile();
      profileResult.fold((l) => failure = l, (r) => healthProfile = r);
      var globalDietPlansResult = await homeRepository.getGlobalDietPlans();
      globalDietPlansResult.fold((l) => failure = l, (r) => dietPlanModels = r);
      if (failure == null) {
        int isVegeratian = (healthProfile.is_vegetarian == 1 ||
                healthProfile.is_vegan == 1 ||
                healthProfile.is_sattvik == 1)
            ? 1
            : 0;

        int isMuscleGain = (healthProfile.goal_gain_muscle == 1) ? 1 : 0;
        int isWeightLoose = (healthProfile.goal_loose_weight == 1 ||
                healthProfile.goal_stay_fit == 1)
            ? 1
            : 0;

        /// Level 1
        ///
        if (dietPlanModels.length > 0 && isVegeratian == 1)
          dietPlanModels =
              dietPlanModels.where((element) => element.isVegetarian == 1);
        if (dietPlanModels.length > 0)
          plan = dietPlanModels[_random.nextInt(dietPlanModels.length)];

        /// Level 2
        ///
        if (dietPlanModels.length > 0 && isWeightLoose == 1)
          dietPlanModels =
              dietPlanModels.where((element) => element.isWeightLoss == 1);
        if (dietPlanModels.length > 0)
          plan = dietPlanModels[_random.nextInt(dietPlanModels.length)];

        /// Level 3
        ///
        if (dietPlanModels.length > 0 && isMuscleGain == 1)
          dietPlanModels =
              dietPlanModels.where((element) => element.isGainMuscle == 1);
        if (dietPlanModels.length > 0)
          plan = dietPlanModels[_random.nextInt(dietPlanModels.length)];

        this.add(LoadDietPlan(plan));
      }
    }
  }

  DietPlanModel storeDietplanData(DietPlanModel input, int day, String dietName,
      String dietIds, int mealtype) {
    DietPlanModel output = input;
    switch (day) {
      case 0:
        switch (mealtype) {
          case 0:
            return output
                .copyWith(day1breakfastIds: dietIds)
                .copyWith(day1breakfastItems: dietName);
          case 1:
            return output
                .copyWith(day1lunchIds: dietIds)
                .copyWith(day1lunchItems: dietName);
          case 2:
            return output
                .copyWith(day1dinnerIds: dietIds)
                .copyWith(day1dinnerItems: dietName);

          default:
            return output;
        }

        break;
      case 1:
        switch (mealtype) {
          case 0:
            return output
                .copyWith(day2breakfastIds: dietIds)
                .copyWith(day2breakfastItems: dietName);
          case 1:
            return output
                .copyWith(day2lunchIds: dietIds)
                .copyWith(day2lunchItems: dietName);
          case 2:
            return output
                .copyWith(day2dinnerIds: dietIds)
                .copyWith(day2dinnerItems: dietName);

          default:
            return output;
        }

        break;
      case 2:
        switch (mealtype) {
          case 0:
            return output
                .copyWith(day3breakfastIds: dietIds)
                .copyWith(day3breakfastItems: dietName);
          case 1:
            return output
                .copyWith(day3lunchIds: dietIds)
                .copyWith(day3lunchItems: dietName);
          case 2:
            return output
                .copyWith(day3dinnerIds: dietIds)
                .copyWith(day3dinnerItems: dietName);

          default:
            return output;
        }

        break;
      case 3:
        switch (mealtype) {
          case 0:
            return output
                .copyWith(day4breakfastIds: dietIds)
                .copyWith(day4breakfastItems: dietName);
          case 1:
            return output
                .copyWith(day4lunchIds: dietIds)
                .copyWith(day4lunchItems: dietName);
          case 2:
            return output
                .copyWith(day4dinnerIds: dietIds)
                .copyWith(day4dinnerItems: dietName);

          default:
            return output;
        }

        break;
      case 4:
        switch (mealtype) {
          case 0:
            return output
                .copyWith(day5breakfastIds: dietIds)
                .copyWith(day5breakfastItems: dietName);
          case 1:
            return output
                .copyWith(day5lunchIds: dietIds)
                .copyWith(day5lunchItems: dietName);
          case 2:
            return output
                .copyWith(day5dinnerIds: dietIds)
                .copyWith(day5dinnerItems: dietName);

          default:
            return output;
        }

        break;
      case 5:
        switch (mealtype) {
          case 0:
            return output
                .copyWith(day6breakfastIds: dietIds)
                .copyWith(day6breakfastItems: dietName);
          case 1:
            return output
                .copyWith(day6lunchIds: dietIds)
                .copyWith(day6lunchItems: dietName);
          case 2:
            return output
                .copyWith(day6dinnerIds: dietIds)
                .copyWith(day6dinnerItems: dietName);

          default:
            return output;
        }

        break;
      case 6:
        switch (mealtype) {
          case 0:
            return output
                .copyWith(day7breakfastIds: dietIds)
                .copyWith(day6breakfastItems: dietName);
          case 1:
            return output
                .copyWith(day7lunchIds: dietIds)
                .copyWith(day7lunchItems: dietName);
          case 2:
            return output
                .copyWith(day7dinnerIds: dietIds)
                .copyWith(day7dinnerItems: dietName);

          default:
            return output;
        }

        break;
      default:
        return output;
    }
  }

  int getPlanLength(DietPlanModel plan) {
    if (plan.day7breakfastIds != "" ||
        plan.day7lunchIds != "" ||
        plan.day7dinnerIds != "")
      return 7;
    else if (plan.day6breakfastIds != "" ||
        plan.day6lunchIds != "" ||
        plan.day6dinnerIds != "")
      return 6;
    else if (plan.day5breakfastIds != "" ||
        plan.day5lunchIds != "" ||
        plan.day5dinnerIds != "")
      return 5;
    else if (plan.day4breakfastIds != "" ||
        plan.day4lunchIds != "" ||
        plan.day4dinnerIds != "")
      return 4;
    else if (plan.day3breakfastIds != "" ||
        plan.day3lunchIds != "" ||
        plan.day3dinnerIds != "")
      return 3;
    else if (plan.day2breakfastIds != "" ||
        plan.day2lunchIds != "" ||
        plan.day2dinnerIds != "")
      return 2;
    else if (plan.day1breakfastIds != "" ||
        plan.day1lunchIds != "" ||
        plan.day1dinnerIds != "")
      return 1;
    else
      return 0;
  }

  Future<DietModel> getUpdatedDiet(DietModel diet) async {
    Failure failure;
    RecipeModel thisRecipe;
    DietModel newDiet = diet;
    newDiet.recipeImage =
        "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/Placeholders%2Fbibimbap.png?alt=media&token=95d7ad83-7c40-4135-9158-cfdd33f82f1d";

    var result = await homeRepository.getRecipeById(newDiet.recipeId);
    result.fold((l) => failure = l, (r) => thisRecipe = r);
    if (failure == null)
      newDiet.recipeImage = thisRecipe.image_url;
    else
      newDiet.recipeImage =
          "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/Placeholders%2Fbibimbap.png?alt=media&token=95d7ad83-7c40-4135-9158-cfdd33f82f1d";
    //Todo:  add calorie and serving unit
    return newDiet;
  }

  Future<DayDiet> getCompletedDayDiet(DietPlanModel data, int i) async {
    DayDiet thisDiets = getDayDietFromIndex(data, i);
    print("index " + i.toString());
    print(thisDiets.dayBreakfastDiets.toString());
    thisDiets.dayName = "Day $i";

    if (data.length == 7)
      thisDiets.dayName = getDayName(i);
    else
      thisDiets.dayName = "Day $i";

    var breakfastDietsResult = await Future.wait(
        thisDiets.dayBreakfastDiets.map((i) => getUpdatedDiet(i)));
    thisDiets.dayBreakfastDiets = breakfastDietsResult;

    var lunchDietsResult = await Future.wait(
        thisDiets.dayLunchDiets.map((i) => getUpdatedDiet(i)));

    thisDiets.dayLunchDiets = lunchDietsResult;
    var dinnerDietsResult = await Future.wait(
        thisDiets.dayDinnerDiets.map((i) => getUpdatedDiet(i)));
    thisDiets.dayDinnerDiets = dinnerDietsResult;

    // for (var j = 0; j < thisDiets.dayBreakfastDiets.length; j++) {
    //   Failure failure;
    //   RecipeModel thisRecipe;
    //   thisDiets.dayBreakfastDiets[j].recipeImage =
    //       "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/Placeholders%2Fbibimbap.png?alt=media&token=95d7ad83-7c40-4135-9158-cfdd33f82f1d";

    //   var result = await repository
    //       .getRecipeById(thisDiets.dayBreakfastDiets[j].recipeId);
    //   result.fold((l) => failure = l, (r) => thisRecipe = r);
    //   if (failure == null)
    //     thisDiets.dayBreakfastDiets[j].recipeImage = thisRecipe.image_url;
    //   else
    //     thisDiets.dayBreakfastDiets[j].recipeImage =
    //         "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/Placeholders%2Fbibimbap.png?alt=media&token=95d7ad83-7c40-4135-9158-cfdd33f82f1d";
    //   //Todo:  add calorie and serving unit

    // }
    for (var j = 0; j < thisDiets.dayLunchDiets.length; j++) {
      Failure failure;
      RecipeModel thisRecipe;
      thisDiets.dayLunchDiets[j].recipeImage =
          "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/Placeholders%2Fbibimbap.png?alt=media&token=95d7ad83-7c40-4135-9158-cfdd33f82f1d";
      var result = await homeRepository
          .getRecipeById(thisDiets.dayLunchDiets[j].recipeId);
      result.fold((l) => failure = l, (r) => thisRecipe = r);
      if (failure == null)
        thisDiets.dayLunchDiets[j].recipeImage = thisRecipe.image_url;
      else
        thisDiets.dayLunchDiets[j].recipeImage =
            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/Placeholders%2Fbibimbap.png?alt=media&token=95d7ad83-7c40-4135-9158-cfdd33f82f1d";
      // //Todo:  add calorie and serving unit

    }
    for (var j = 0; j < thisDiets.dayDinnerDiets.length; j++) {
      Failure failure;
      RecipeModel thisRecipe;
      thisDiets.dayDinnerDiets[j].recipeImage =
          "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/Placeholders%2Fbibimbap.png?alt=media&token=95d7ad83-7c40-4135-9158-cfdd33f82f1d";

      var result = await homeRepository
          .getRecipeById(thisDiets.dayDinnerDiets[j].recipeId);
      result.fold((l) => failure = l, (r) => thisRecipe = r);
      if (failure == null)
        thisDiets.dayDinnerDiets[j].recipeImage = thisRecipe.image_url;
      else
        thisDiets.dayDinnerDiets[j].recipeImage =
            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/Placeholders%2Fbibimbap.png?alt=media&token=95d7ad83-7c40-4135-9158-cfdd33f82f1d";
      //Todo:  add calorie and serving unit

    }
    thisDiets.id = i;
    return thisDiets;
  }

  DayDiet getDayDietFromIndex(DietPlanModel data, int i) {
    switch (i) {
      case 1:
        List<DietModel> breakfastDiets =
            getMealDiets(data.day1breakfastItems, data.day1breakfastIds);
        List<DietModel> lunchDiets =
            getMealDiets(data.day1lunchItems, data.day1lunchIds);
        List<DietModel> dinnerDiets =
            getMealDiets(data.day1dinnerItems, data.day1dinnerIds);
        return DayDiet(
            dayBreakfastDiets: breakfastDiets,
            dayLunchDiets: lunchDiets,
            dayDinnerDiets: dinnerDiets);
        break;
      case 2:
        List<DietModel> breakfastDiets =
            getMealDiets(data.day2breakfastItems, data.day2breakfastIds);
        List<DietModel> lunchDiets =
            getMealDiets(data.day2lunchItems, data.day2lunchIds);
        List<DietModel> dinnerDiets =
            getMealDiets(data.day2dinnerItems, data.day2dinnerIds);
        return DayDiet(
            dayBreakfastDiets: breakfastDiets,
            dayLunchDiets: lunchDiets,
            dayDinnerDiets: dinnerDiets);
        break;
      case 3:
        List<DietModel> breakfastDiets =
            getMealDiets(data.day3breakfastItems, data.day3breakfastIds);
        List<DietModel> lunchDiets =
            getMealDiets(data.day3lunchItems, data.day3lunchIds);
        List<DietModel> dinnerDiets =
            getMealDiets(data.day3dinnerItems, data.day3dinnerIds);
        return DayDiet(
            dayBreakfastDiets: breakfastDiets,
            dayLunchDiets: lunchDiets,
            dayDinnerDiets: dinnerDiets);
        break;
      case 4:
        List<DietModel> breakfastDiets =
            getMealDiets(data.day4breakfastItems, data.day4breakfastIds);
        List<DietModel> lunchDiets =
            getMealDiets(data.day4lunchItems, data.day4lunchIds);
        List<DietModel> dinnerDiets =
            getMealDiets(data.day4dinnerItems, data.day4dinnerIds);
        return DayDiet(
            dayBreakfastDiets: breakfastDiets,
            dayLunchDiets: lunchDiets,
            dayDinnerDiets: dinnerDiets);
        break;
      case 5:
        List<DietModel> breakfastDiets =
            getMealDiets(data.day5breakfastItems, data.day5breakfastIds);
        List<DietModel> lunchDiets =
            getMealDiets(data.day5lunchItems, data.day5lunchIds);
        List<DietModel> dinnerDiets =
            getMealDiets(data.day5dinnerItems, data.day5dinnerIds);
        return DayDiet(
            dayBreakfastDiets: breakfastDiets,
            dayLunchDiets: lunchDiets,
            dayDinnerDiets: dinnerDiets);
        break;
      case 6:
        List<DietModel> breakfastDiets =
            getMealDiets(data.day6breakfastItems, data.day6breakfastIds);
        List<DietModel> lunchDiets =
            getMealDiets(data.day6lunchItems, data.day6lunchIds);
        List<DietModel> dinnerDiets =
            getMealDiets(data.day6dinnerItems, data.day6dinnerIds);
        return DayDiet(
            dayBreakfastDiets: breakfastDiets,
            dayLunchDiets: lunchDiets,
            dayDinnerDiets: dinnerDiets);
        break;
      case 7:
        List<DietModel> breakfastDiets =
            getMealDiets(data.day7breakfastItems, data.day7breakfastIds);
        List<DietModel> lunchDiets =
            getMealDiets(data.day7lunchItems, data.day7lunchIds);
        List<DietModel> dinnerDiets =
            getMealDiets(data.day7dinnerItems, data.day7dinnerIds);
        return DayDiet(
            dayBreakfastDiets: breakfastDiets,
            dayLunchDiets: lunchDiets,
            dayDinnerDiets: dinnerDiets);
        break;
      default:
        return DayDiet();
    }
  }

  List<DietModel> getMealDiets(String mealItems, String mealIds) {
    List<DietModel> diets = [];

    var mealsName = mealItems.split(',').toList();
    var mealsId = mealIds.split(',').toList();
    for (var i = 0; i < mealsName.length; i++) {
      diets.add(DietModel(
        name: mealsName[i],
        recipeId: int.parse((mealsId[i]?.split(':').toList())[0] ?? "-1") ?? -1,
        servings: int.parse((mealsId[i]?.split(':').toList())[1] ?? "-1") ?? -1,
      ));
    }
    return diets;
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

  Future<DietPlanState> getStateForConsultation(
      ClientConsultationModel consultation) async {
    DietPlanState state;
    List<DietPlanModel> plans = [];
    List<DietPlanEntitiy> entities = [];
    Failure failure;
    var workoutResult =
        await connectRepository.getConsultationDietPlans(consultation);

    workoutResult.fold((l) => failure = l, (r) {
      plans = r;
    });

    if (failure == null) {
      return DietPlanListState(plans);
    } else {
      return DietPlanError(Failure.mapToString(failure));
    }
  }
}
