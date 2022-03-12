import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/database/cacheDataClass.dart';
import 'package:sorted/core/global/entities/sub_profiles/fitness_goals.dart';
import 'package:sorted/core/global/entities/sub_profiles/food_preferences.dart';
import 'package:sorted/core/global/entities/sub_profiles/health_condition.dart';
import 'package:sorted/core/global/entities/sub_profiles/mindful_goals.dart';
import 'package:sorted/core/global/models/health_profile.dart';
import 'package:sorted/core/global/models/user_details.dart';
import 'package:sorted/features/CONNECT/data/models/expert/expert_calendar.dart';
import 'package:sorted/features/USER_INTRODUCTION/data/models/user_tag.dart';
import 'package:sorted/features/USER_INTRODUCTION/domain/repositories/user_intro_repository.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/flow_bloc/flow_bloc.dart';
part 'user_form_event.dart';
part 'user_form_state.dart';

class UserRequestFormBloc
    extends Bloc<UserRequestFormEvent, UserRequestFormProfileState> {
  UserRequestFormBloc({@required this.repository})
      : super(
          InitialFormState(),
        );

  final UserIntroductionRepository repository;

  List<UserTag> openedTags = [];

  @override
  Stream<UserRequestFormProfileState> mapEventToState(
    UserRequestFormEvent event,
  ) async* {
    if (event is LoadProfile) {
      Failure failure;
      HealthProfile healthProfile;
      UserFoodPreferences foodPreferences;
      HealthConditions healthConditions;
      FitnessGoals fitnessGoals;
      MindfulGoals mindfulGoals;

      int type = event.formType;

      var userDetails = CacheDataClass.cacheData.getUserDetail();
      var healthProfileResult = await repository.getHealthProfile();

      healthProfileResult.fold((l) => failure = l, (r) => healthProfile = r);

      if (failure == null) {
        print("worked");
       
        // for fitness profile
        {
          fitnessGoals = FitnessGoals.fromHealthProfile(healthProfile);

          healthConditions = HealthConditions.fromHealthProfile(healthProfile);

          foodPreferences =
              UserFoodPreferences.fromHealthProfile(healthProfile);

          yield LoadedFormState(userDetails,
              DateTime.now().add(Duration(days: 1)), 7, event.calendarModel,
              fitnessGoals: fitnessGoals,
              foodPreferences: foodPreferences,
              healthConditions: healthConditions);
        } 
      } else {
        print("not worked");
      }
    } else if (event is SaveHealthProfile) {
    } else if (event is UpdateHealthCondition) {
      if (state is LoadedFormState) {
        var prevState = state as LoadedFormState;
        yield prevState.copyWith(healthConditions: event.condition);
      }
    } else if (event is UpdateFoodPreference) {
      if (state is LoadedFormState) {
        var prevState = state as LoadedFormState;
        yield prevState.copyWith(foodPreferences: event.preferences);
      }
    } else if (event is UpdateFitnessGoals) {
      if (state is LoadedFormState) {
        var prevState = state as LoadedFormState;
        yield prevState.copyWith(fitnessGoals: event.goals);
      }
    } else if (event is UpdateMindfulGoals) {
      if (state is LoadedFormState) {
        var prevState = state as LoadedFormState;
        yield prevState.copyWith(mindfulGoals: event.goals);
      }
    }
  }
}
