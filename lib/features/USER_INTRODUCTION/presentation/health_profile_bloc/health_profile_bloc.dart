import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/models/addiction_condition.dart';
import 'package:sorted/core/global/models/health_condition.dart';
import 'package:sorted/core/global/models/lifestyle_profile.dart';
import 'package:sorted/core/global/models/mental_health_profile.dart';
import 'package:sorted/core/global/models/physical_health_profile.dart';
import 'package:sorted/features/PROFILE/data/models/user_activity.dart';
import 'package:sorted/features/USER_INTRODUCTION/data/models/user_tag.dart';
import 'package:sorted/features/USER_INTRODUCTION/domain/repositories/user_intro_repository.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/flow_bloc/flow_bloc.dart';
part 'health_profile_event.dart';
part 'health_profile_state.dart';

class HealthProfileBloc extends Bloc<HealthProfileEvent, HealthProfileState> {
  HealthProfileBloc({@required this.repository, @required this.flowBloc})
      : super(
          LoadingState(),
        );

  final UserIntroductionBloc flowBloc;
  final UserIntroductionRepository repository;

  List<UserTag> openedTags = [];

  @override
  Stream<HealthProfileState> mapEventToState(
    HealthProfileEvent event,
  ) async* {
    if (event is LoadProfile) {
      Failure failure;

      if (failure == null) {
        print("worked");
        yield LoadedState(PhysicalHealthProfile(), MentalHealthProfile(),
            LifestyleProfile(), HealthConditions(), AddictionConditions());
      } else {
        print("not worked");
      }
    } else if (event is Add) {
      Failure failure;
    } else if (event is UpdateWeight) {
      LoadedState prevState = (state as LoadedState);

      yield LoadedState(
          prevState.fitnessProfile.copyWith(weight_kg: event.weightInKG),
          prevState.mentalProfile,
          prevState.lifestyleProfile,
          prevState.healthCondition,
          prevState.addictionCondition);
    } else if (event is UpdateHeight) {
      LoadedState prevState = (state as LoadedState);

      yield LoadedState(
          prevState.fitnessProfile.copyWith(height_cm: event.heightInCm),
          prevState.mentalProfile,
          prevState.lifestyleProfile,
          prevState.healthCondition,
          prevState.addictionCondition);
    } else if (event is UpdateHealthDailyActivity) {
      LoadedState oldState = (state as LoadedState);
      PhysicalHealthProfile fitnessProfile = oldState.fitnessProfile;

      switch (event.category) {
        case 0:
          {
            print("walk");
            fitnessProfile =
                fitnessProfile.copyWith(do_walk: 1 - fitnessProfile.do_walk);
            break;
          }
        case 1:
          {
            fitnessProfile = fitnessProfile.copyWith(
                do_exercise: 1 - fitnessProfile.do_exercise);
            break;
          }
        case 2:
          {
            fitnessProfile =
                fitnessProfile.copyWith(do_yoga: 1 - fitnessProfile.do_yoga);
            break;
          }
        case 3:
          {
            fitnessProfile =
                fitnessProfile.copyWith(do_dance: 1 - fitnessProfile.do_dance);
            break;
          }
        case 4:
          {
            fitnessProfile = fitnessProfile.copyWith(
                play_sports: 1 - fitnessProfile.play_sports);
            break;
          }
        case 5:
          {
            fitnessProfile = fitnessProfile.copyWith(
                ride_cycle: 1 - fitnessProfile.ride_cycle);
            break;
          }

          break;
        default:
      }

      yield LoadedState(
          fitnessProfile,
          oldState.mentalProfile,
          oldState.lifestyleProfile,
          oldState.healthCondition,
          oldState.addictionCondition);
    } else if (event is UpdateHealthGoalActivity) {
      LoadedState oldState = (state as LoadedState);
      PhysicalHealthProfile fitnessProfile = oldState.fitnessProfile;

      switch (event.category) {
        case 0:
          {
            print("walk");
            fitnessProfile = fitnessProfile.copyWith(
                goal_stay_fit: 1 - fitnessProfile.goal_stay_fit);
            break;
          }
        case 1:
          {
            fitnessProfile = fitnessProfile.copyWith(
                goal_gain_muscle: 1 - fitnessProfile.goal_gain_muscle);
            break;
          }
        case 2:
          {
            fitnessProfile = fitnessProfile.copyWith(
                goal_loose_weight: 1 - fitnessProfile.goal_loose_weight);
            break;
          }
        case 3:
          {
            fitnessProfile = fitnessProfile.copyWith(
                goal_get_more_active: 1 - fitnessProfile.goal_get_more_active);
            break;
          }

          break;
        default:
      }

      yield LoadedState(
          fitnessProfile,
          oldState.mentalProfile,
          oldState.lifestyleProfile,
          oldState.healthCondition,
          oldState.addictionCondition);
    } else if (event is UpdateMentalDailyActivity) {
      LoadedState oldState = (state as LoadedState);
      MentalHealthProfile mentalProfile = oldState.mentalProfile;

      switch (event.category) {
        case 0:
          {
            print("walk");
            mentalProfile = mentalProfile.copyWith(
                do_talk_ablout_feelings:
                    1 - mentalProfile.do_talk_ablout_feelings);
            break;
          }
        case 1:
          {
            mentalProfile = mentalProfile.copyWith(
                do_enjoy_work: 1 - mentalProfile.do_enjoy_work);
            break;
          }
        case 2:
          {
            mentalProfile = mentalProfile.copyWith(
                do_meditation: 1 - mentalProfile.do_meditation);
            break;
          }
        case 3:
          {
            mentalProfile = mentalProfile.copyWith(
                do_love_self: 1 - mentalProfile.do_love_self);
            break;
          }
        case 4:
          {
            mentalProfile = mentalProfile.copyWith(
                do_stay_positive: 1 - mentalProfile.do_stay_positive);
            break;
          }

          break;
        default:
      }

      yield LoadedState(
          oldState.fitnessProfile,
          mentalProfile,
          oldState.lifestyleProfile,
          oldState.healthCondition,
          oldState.addictionCondition);
    } else if (event is UpdateMentalGoalActivity) {
      LoadedState oldState = (state as LoadedState);
      MentalHealthProfile mentalProfile = oldState.mentalProfile;

      switch (event.category) {
        case 0:
          {
            print("walk");
            mentalProfile = mentalProfile.copyWith(
                goal_live_in_present: 1 - mentalProfile.goal_live_in_present);
            break;
          }
        case 1:
          {
            mentalProfile = mentalProfile.copyWith(
                goal_reduce_stress: 1 - mentalProfile.goal_reduce_stress);
            break;
          }
        case 2:
          {
            mentalProfile = mentalProfile.copyWith(
                goal_sleep_more: 1 - mentalProfile.goal_sleep_more);
            break;
          }
        case 3:
          {
            mentalProfile = mentalProfile.copyWith(
                goal_control_anger: 1 - mentalProfile.goal_control_anger);
            break;
          }
        case 4:
          {
            mentalProfile = mentalProfile.copyWith(
                goal_control_thoughts: 1 - mentalProfile.goal_control_thoughts);
            break;
          }

          break;
        default:
      }

      yield LoadedState(
          oldState.fitnessProfile,
          mentalProfile,
          oldState.lifestyleProfile,
          oldState.healthCondition,
          oldState.addictionCondition);
    } else if (event is UpdateSleepActivity) {
      LoadedState oldState = (state as LoadedState);
      LifestyleProfile lifestyleProfile = oldState.lifestyleProfile;

      switch (event.category) {
        case 0:
          {
            print("walk");
            lifestyleProfile = lifestyleProfile.copyWith(
                is_early_bird: 1 - lifestyleProfile.is_early_bird);
            break;
          }
        case 1:
          {
            lifestyleProfile = lifestyleProfile.copyWith(
                is_night_owl: 1 - lifestyleProfile.is_night_owl);
            break;
          }
        case 2:
          {
            lifestyleProfile = lifestyleProfile.copyWith(
                is_humming_bird: 1 - lifestyleProfile.is_humming_bird);
            break;
          }

          break;
        default:
      }

      yield LoadedState(
          oldState.fitnessProfile,
          oldState.mentalProfile,
          lifestyleProfile,
          oldState.healthCondition,
          oldState.addictionCondition);
    } else if (event is UpdateFoodPreference) {
      LoadedState oldState = (state as LoadedState);
      LifestyleProfile lifestyleProfile = oldState.lifestyleProfile;

      switch (event.category) {
        case 0:
          {
            print("walk");
            lifestyleProfile = lifestyleProfile.copyWith(
                is_vegetarian: 1 - lifestyleProfile.is_vegetarian);
            break;
          }
        case 1:
          {
            lifestyleProfile = lifestyleProfile.copyWith(
                is_vegan: 1 - lifestyleProfile.is_vegan);
            break;
          }
        case 2:
          {
            lifestyleProfile = lifestyleProfile.copyWith(
                is_high_protien: 1 - lifestyleProfile.is_high_protien);
            break;
          }
        case 3:
          {
            lifestyleProfile = lifestyleProfile.copyWith(
                is_low_calorie: 1 - lifestyleProfile.is_low_calorie);
            break;
          }
        case 4:
          {
            lifestyleProfile = lifestyleProfile.copyWith(
                is_keto: 1 - lifestyleProfile.is_keto);
            break;
          }
        case 5:
          {
            lifestyleProfile = lifestyleProfile.copyWith(
                is_sattvik: 1 - lifestyleProfile.is_sattvik);
            break;
          }

          break;
        default:
      }

      yield LoadedState(
          oldState.fitnessProfile,
          oldState.mentalProfile,
          lifestyleProfile,
          oldState.healthCondition,
          oldState.addictionCondition);
    } else if (event is SaveHealthProfile) {}
  }

  @override
  Future<void> close() async {
    print("health block");
    LoadedState oldState = (state as LoadedState);
    repository.saveHealthProfile(
        oldState.fitnessProfile,
        oldState.mentalProfile,
        oldState.lifestyleProfile,
        oldState.healthCondition,
        oldState.addictionCondition);

    return super.close();
  }
}
