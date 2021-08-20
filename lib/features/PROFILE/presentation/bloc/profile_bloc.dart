import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/core/authentication/remote_auth_repository.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/database/cacheDataClass.dart';
import 'package:sorted/core/global/models/health_profile.dart';
import 'package:sorted/core/global/models/user_details.dart';

import 'package:sorted/features/PROFILE/domain/repositories/profile_repository.dart';
import 'package:sorted/features/USER_INTRODUCTION/domain/repositories/user_intro_repository.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/widgets/health_profile.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;
  final AuthenticationRepository authenticationRepository;
  final UserIntroductionRepository userRepository;
  ProfileBloc(
      this.repository, this.authenticationRepository, this.userRepository)
      : super(ProfileInitial());
  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is LoadProfile) {
      yield ProfileInitial();
      var userDetails = CacheDataClass.cacheData.getUserDetail();
      if (userDetails == null) {
        userDetails = UserDetail();
      }

      Failure failure;
      HealthProfile profile = HealthProfile();

      var errorOrProfile = await repository.getFitnessProfileFromCloud();
      errorOrProfile.fold((l) => failure = l, (r) => profile = r);
      if (failure == null) {
        //print("hello  " + profile.mindfulness_skills.toString());
        yield ProfileLoaded(profile, userDetails ?? UserDetail());
      }
    } else if (event is Signout) {
      authenticationRepository.logOut();
    } else if (event is UpdateHeight) {
      if (state is ProfileLoaded) {
        yield (state as ProfileLoaded).copyWith(
            healthProfile: (state as ProfileLoaded)
                .healthProfile
                .copyWith(height_cm: event.heightInCm));
      }
    } else if (event is UpdateHealthDailyActivity) {
      if (state is ProfileLoaded) {
        HealthProfile fitnessProfile = (state as ProfileLoaded).healthProfile;

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
              fitnessProfile = fitnessProfile.copyWith(
                  do_dance: 1 - fitnessProfile.do_dance);
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

        yield (state as ProfileLoaded).copyWith(healthProfile: fitnessProfile);
      }
    } else if (event is UpdateHealthGoalActivity) {
      if (state is ProfileLoaded) {
        HealthProfile fitnessProfile = (state as ProfileLoaded).healthProfile;
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
                  goal_get_more_active:
                      1 - fitnessProfile.goal_get_more_active);
              break;
            }

            break;
          default:
        }

        yield (state as ProfileLoaded).copyWith(healthProfile: fitnessProfile);
      }
    } else if (event is UpdateMentalDailyActivity) {
      if (state is ProfileLoaded) {
        HealthProfile mentalProfile = (state as ProfileLoaded).healthProfile;

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

        yield (state as ProfileLoaded).copyWith(healthProfile: mentalProfile);
      }
    } else if (event is UpdateMentalGoalActivity) {
      if (state is ProfileLoaded) {
        HealthProfile mentalProfile = (state as ProfileLoaded).healthProfile;

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
                  goal_control_thoughts:
                      1 - mentalProfile.goal_control_thoughts);
              break;
            }

            break;
          default:
        }

        yield (state as ProfileLoaded).copyWith(healthProfile: mentalProfile);
      }
    } else if (event is UpdateSleepActivity) {
      if (state is ProfileLoaded) {
        HealthProfile lifestyleProfile = (state as ProfileLoaded).healthProfile;

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

        yield (state as ProfileLoaded)
            .copyWith(healthProfile: lifestyleProfile);
      }
    } else if (event is UpdateFoodPreference) {
      if (state is ProfileLoaded) {
        HealthProfile lifestyleProfile = (state as ProfileLoaded).healthProfile;

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
                  is_keto: 1 - lifestyleProfile.is_keto);
              break;
            }
          case 3:
            {
              lifestyleProfile = lifestyleProfile.copyWith(
                  is_sattvik: 1 - lifestyleProfile.is_sattvik);
              break;
            }

            break;
          default:
        }

        yield (state as ProfileLoaded)
            .copyWith(healthProfile: lifestyleProfile);
      }
    } else if (event is UpdateHealthCondition) {
      if (state is ProfileLoaded) {
        HealthProfile lifestyleProfile = (state as ProfileLoaded).healthProfile;

        switch (event.category) {
          case 0:
            {
              print("walk");
              lifestyleProfile = lifestyleProfile.copyWith(
                  has_high_bp: 1 - lifestyleProfile.has_high_bp);
              break;
            }
          case 1:
            {
              lifestyleProfile = lifestyleProfile.copyWith(
                  has_diabetes: 1 - lifestyleProfile.has_diabetes);
              break;
            }
          case 2:
            {
              lifestyleProfile = lifestyleProfile.copyWith(
                  has_cholesterol: 1 - lifestyleProfile.has_cholesterol);
              break;
            }
          case 3:
            {
              lifestyleProfile = lifestyleProfile.copyWith(
                  has_hypertension: 1 - lifestyleProfile.has_hypertension);
              break;
            }

            break;
          default:
        }

        yield (state as ProfileLoaded)
            .copyWith(healthProfile: lifestyleProfile);
      }
    } else if (event is SaveDetails) {
      //print("at save  >>>" + event.details.currentDevice);

      userRepository.addUser(event.details);
      userRepository.saveHealthProfile(event.healthProfile);
    }
  }
}
