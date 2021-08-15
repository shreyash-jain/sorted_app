import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/database/cacheDataClass.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/models/health_profile.dart';
import 'package:sorted/core/global/models/user_details.dart';
import 'package:sorted/core/services/notifications/entitites/success_message.dart';
import 'package:sorted/core/services/notifications/notification_repository.dart';

import 'package:sorted/features/USER_INTRODUCTION/domain/repositories/user_intro_repository.dart';
import 'package:truecaller_sdk/truecaller_sdk.dart';
part 'flow_event.dart';
part 'flow_state.dart';

const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String NETWORK_FAILURE_MESSAGE = 'Network Failure';
const String NATIVE_DATABASE_FAILURE_MESSAGE = "Database error";
const String FAILURE_MESSAGE = "Uncatched error";

class UserIntroductionBloc extends Bloc<FlowEvent, UserIntroductionState> {
  StreamSubscription<double> _downloadProgress;
  final UserIntroductionRepository repository;
  final NotificationRepository notificationRepository;
  bool oldState;
  int deviceId;
  String deviceName;
  StreamSubscription streamSubscription;
  String userName = "";

  UserIntroductionBloc(this.repository, this.notificationRepository)
      : super(UserIntroductionInitial()) {}

  @override
  Stream<UserIntroductionState> mapEventToState(
    FlowEvent event,
  ) async* {
    if (event is StartDownload) {
      (await repository.doInitialDownload()).fold((l) async {}, (r) async {
        _downloadProgress = r.listen((event) {
          add(UpdateProgress(event));
        });
      });
    } else if (event is GetUserHistoryStatus) {
      UserDetail userDetail;
      if (sl<CacheDataClass>().getOldState() != null) {
        oldState = sl<CacheDataClass>().getOldState();
        print("5 : " + oldState.toString());
      }
      if (oldState == null) {
        var oldUserState = await repository.oldUserState;
        yield* oldUserState.fold((l) async* {
          yield Error(message: CACHE_FAILURE_MESSAGE);
        }, (r) async* {
          oldState = r;
        });
        print(5);
      }
      print(sl<CacheDataClass>().getUserDetail().toString());
      if (sl<CacheDataClass>().getUserDetail() != null) {
        print(3);
        userDetail = sl<CacheDataClass>().getUserDetail();
        deviceId = userDetail.currentDeviceId;
        deviceName = userDetail.currentDevice;
        print(userDetail.currentDevice);
      }

      if (userDetail == null) {
        var failureOrUserName = await repository.userName;
        yield* failureOrUserName.fold((l) async* {
          yield Error(message: CACHE_FAILURE_MESSAGE);
        }, (r) async* {
          userName = r;
        });
        print(4);
        userDetail.copyWith(name: userName);
      }

      yield UserInteractionState(
          oldState: oldState, userDetail: userDetail, progress: 0);
    } else if (event is UpdateProgress) {
      print(event.progress);
      yield UserInteractionState(
          oldState: (state as UserInteractionState).oldState,
          userDetail: (state as UserInteractionState).userDetail,
          progress: event.progress);
    } else if (event is EndDownload) {
      yield* doOnEndDownloadEvent();
    } else if (event is UpdateGender) {
      if (state is LoginState) {
        UserDetail prevDetail = (state as LoginState).userDetail;
        prevDetail.copyWith(gender: event.gender);
        yield (state as LoginState).copyWith(
            userDetail:
                (state as LoginState).userDetail.copyWith(gender: event.gender),
            valid: checkValidity((state as LoginState)
                .userDetail
                .copyWith(gender: event.gender)),
            message: generateValidityMessage((state as LoginState)
                .userDetail
                .copyWith(gender: event.gender)));
      }
    } else if (event is UpdateAge) {
      if (state is LoginState) {
        UserDetail prevDetail = (state as LoginState).userDetail;
        prevDetail.copyWith(age: event.age);
        yield (state as LoginState).copyWith(
            userDetail:
                (state as LoginState).userDetail.copyWith(age: event.age),
            valid: checkValidity(
                (state as LoginState).userDetail.copyWith(age: event.age)),
            message: generateValidityMessage(
                (state as LoginState).userDetail.copyWith(age: event.age)));
      }
    } else if (event is UpdatePhoneNumberFromTrueCaller) {
      if (state is LoginState) {
        if (event.phoneNumber.length < 10)
          yield (state as LoginState).copyWith(isPhoneCorrect: false);
        else {
          try {
            int mobilenumber = int.parse(event.phoneNumber);
            yield (state as LoginState).copyWith(
                userDetail: (state as LoginState)
                    .userDetail
                    .copyWith(mobileNumber: mobilenumber),
                isPhoneCorrect: true);
          } catch (e) {
            yield (state as LoginState).copyWith(isPhoneCorrect: false);
          }
        }
      }
    } else if (event is UpdateProfession) {
      if (state is LoginState) {
        UserDetail prevDetail = (state as LoginState).userDetail;
        prevDetail.copyWith(profession: event.prof);
        yield (state as LoginState).copyWith(
            userDetail: (state as LoginState)
                .userDetail
                .copyWith(profession: event.prof),
            valid: checkValidity((state as LoginState)
                .userDetail
                .copyWith(profession: event.prof)),
            message: generateValidityMessage((state as LoginState)
                .userDetail
                .copyWith(profession: event.prof)));
      }
    } else if (event is UpdateWeight) {
      if (state is LoginState) {
        yield (state as LoginState).copyWith(
            healthProfile: (state as LoginState)
                .healthProfile
                .copyWith(weight_kg: event.weightInKG));
      }
    } else if (event is UpdateHeight) {
      if (state is LoginState) {
        yield (state as LoginState).copyWith(
            healthProfile: (state as LoginState)
                .healthProfile
                .copyWith(height_cm: event.heightInCm));
      }
    } else if (event is UpdateHealthDailyActivity) {
      if (state is LoginState) {
        HealthProfile fitnessProfile = (state as LoginState).healthProfile;

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

        yield (state as LoginState).copyWith(healthProfile: fitnessProfile);
      }
    } else if (event is UpdateHealthGoalActivity) {
      if (state is LoginState) {
        HealthProfile fitnessProfile = (state as LoginState).healthProfile;
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

        yield (state as LoginState).copyWith(healthProfile: fitnessProfile);
      }
    } else if (event is UpdateMentalDailyActivity) {
      if (state is LoginState) {
        HealthProfile mentalProfile = (state as LoginState).healthProfile;

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

        yield (state as LoginState).copyWith(healthProfile: mentalProfile);
      }
    } else if (event is UpdateMentalGoalActivity) {
      if (state is LoginState) {
        HealthProfile mentalProfile = (state as LoginState).healthProfile;

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

        yield (state as LoginState).copyWith(healthProfile: mentalProfile);
      }
    } else if (event is UpdateSleepActivity) {
      if (state is LoginState) {
        HealthProfile lifestyleProfile = (state as LoginState).healthProfile;

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

        yield (state as LoginState).copyWith(healthProfile: lifestyleProfile);
      }
    } else if (event is UpdateFoodPreference) {
      if (state is LoginState) {
        HealthProfile lifestyleProfile = (state as LoginState).healthProfile;

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

        yield (state as LoginState).copyWith(healthProfile: lifestyleProfile);
      }
    } else if (event is UpdateHealthCondition) {
      if (state is LoginState) {
        HealthProfile lifestyleProfile = (state as LoginState).healthProfile;

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

        yield (state as LoginState).copyWith(healthProfile: lifestyleProfile);
      }
    } else if (event is SaveDetails) {
      //print("at save  >>>" + event.details.currentDevice);
      UserDetail toSaveDetail = event.details
          .copyWith(currentDevice: deviceName, currentDeviceId: deviceId);

      repository.addUser(toSaveDetail);
      repository.saveHealthProfile(event.healthProfile);

      yield SuccessState();
    } else if (event is RequestOTP) {
      var prevState = state as LoginState;
      Failure failure;
      SuccessOTPResponse response;
      if (event.phoneNumber.length != 10) {
        yield prevState.copyWith(message: "Invalid Phone Number");
      } else {
        yield prevState.copyWith(
            isOtpLoading: true, message: "Sending Message");
        String currentNumber = "91" + event.phoneNumber;

        var otpResult = await notificationRepository.sendOTP(currentNumber);
        otpResult.fold((l) => failure = l, (r) => response = r);

        if (failure == null) {
          yield prevState.copyWith(
              currentNumber: currentNumber,
              actualOtp: response.otp,
              message: "Message sent",
              isOtpLoading: false);
        } else
          yield prevState.copyWith(
              isOtpLoading: false, message: Failure.mapToString(failure));
      }
    } else if (event is SetInvalidPhone) {
      if (state is LoginState) {
        if ((state as LoginState).isPhoneCorrect)
          yield (state as LoginState).copyWith(isPhoneCorrect: false);
      }
    } else if (event is SetValidPhone) {
      if (state is LoginState) {
        if (!((state as LoginState).isPhoneCorrect))
          yield (state as LoginState).copyWith(isPhoneCorrect: true);
      }
    }
  }

  Stream<UserIntroductionState> doOnEndDownloadEvent() async* {
    Failure failure;

    UserDetail userDetail;
    LoginState downloadedState;
    HealthProfile healthProfile;

    print(doOnEndDownloadEvent);
    userDetail = sl<CacheDataClass>().getUserDetail();

    if (oldState == null || !oldState) {
    } else {
      var failureOrUserDetails = await repository.userDetails;
      failureOrUserDetails.fold((l) {
        failure = l;
      }, (r) {
        userDetail = r;
      });
      print(userDetail);
    }
    print("to enter doOnEndDownloadEvent");
    var healthResult = await repository.getHealthProfile();
    healthResult.fold((l) => failure = l, (r) => healthProfile = r);
    if (failure == null) {
      downloadedState = LoginState(
          userDetail: userDetail,
          isOtpLoading: false,
          healthProfile: healthProfile,
          isPhoneCorrect: (userDetail != null &&
                  userDetail.mobileNumber.toString().length == 10)
              ? true
              : false,
          valid: checkValidity(userDetail),
          message: (userDetail != null &&
                  userDetail.mobileNumber.toString().length == 10)
              ? ""
              : "Please enter your mobile number");
      if ((userDetail == null ||
          userDetail.mobileNumber.toString().length < 10))
        initializeTruecallerSDK(downloadedState);
      yield downloadedState;
    } else {
      yield Error(message: mapFailureToString(failure));
    }
  }

  String mapFailureToString(Failure failure) {
    if (failure == ServerFailure()) {
      return SERVER_FAILURE_MESSAGE;
    } else if (failure == NativeDatabaseException()) {
      return NATIVE_DATABASE_FAILURE_MESSAGE;
    } else if (failure == CacheFailure()) {
      return CACHE_FAILURE_MESSAGE;
    } else if (failure == NetworkFailure()) {
      return NETWORK_FAILURE_MESSAGE;
    } else
      return FAILURE_MESSAGE;
  }

  int checkValidity(UserDetail details) {
    print("checked Validity " + details.checkValidityOnUserIntro().toString());
    return details.checkValidityOnUserIntro();
  }

  String generateValidityMessage(UserDetail details) {
    return details.generateMessageOnUserIntro();
  }

  @override
  Future<void> close() {
    if (_downloadProgress != null) _downloadProgress.cancel();
    return super.close();
  }

  void initializeTruecallerSDK(LoginState loginState) {
    print("initializeTruecaller enter");

    TruecallerSdk.initializeSDK(
        sdkOptions: TruecallerSdkScope.SDK_OPTION_WITH_OTP);
    TruecallerSdk.isUsable.then((isUsable) {
      if (isUsable) {
        TruecallerSdk.getProfile;
      } else {
        print("***Not usable***");
      }
    });
    streamSubscription =
        TruecallerSdk.streamCallbackData.listen((truecallerSdkCallback) {
      print("***streamCallbackData***");
      switch (truecallerSdkCallback.result) {
        case TruecallerSdkCallbackResult.success:
          //If Truecaller user and has Truecaller app on his device, you'd directly get the Profile
          print("First Name: ${truecallerSdkCallback.profile.firstName}");
          print("Last Name: ${truecallerSdkCallback.profile.lastName}");
          print(
              "Last Name: ${truecallerSdkCallback.profile.phoneNumber.substring(truecallerSdkCallback.profile.phoneNumber.length - 10)}");
          print("initializeTruecaller case success");
          this.add(UpdatePhoneNumberFromTrueCaller(
              truecallerSdkCallback.profile.phoneNumber.substring(
                  truecallerSdkCallback.profile.phoneNumber.length - 10)));

          break;
        case TruecallerSdkCallbackResult.failure:
          print("Error code : ${truecallerSdkCallback.error.code}");

          break;
        case TruecallerSdkCallbackResult.verification:
          //If the callback comes here, it indicates that user has to be manually verified, so follow step 4
          //You'd receive nullable error which can be used to determine user action that led to verification
          print(
              "Manual Verification Required!! ${truecallerSdkCallback.error != null ? truecallerSdkCallback.error.code : ""}");

          break;
        default:
          print("Invalid result");
      }
    });
  }
}
