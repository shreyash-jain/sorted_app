import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/database/cacheDataClass.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/models/user_details.dart';
import 'package:sorted/features/PROFILE/data/models/activity.dart';
import 'package:sorted/features/PROFILE/data/models/user_activity.dart';
import 'package:sorted/features/USER_INTRODUCTION/domain/repositories/user_intro_repository.dart';
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
  bool oldState;
  int deviceId;
  String deviceName;

  String userName = "";

  UserIntroductionBloc(this.repository) : super(UserIntroductionInitial());
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
        print(5);
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
      if (sl<CacheDataClass>().getOldState() != null) {
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
        yield LoginState(
            allActivities: (state as LoginState).allActivities,
            userActivities: (state as LoginState).userActivities,
            userDetail:
                (state as LoginState).userDetail.copyWith(gender: event.gender),
            valid: checkValidity((state as LoginState)
                .userDetail
                .copyWith(gender: event.gender)),
            message: generateValidityMessage((state as LoginState)
                .userDetail
                .copyWith(gender: event.gender)));
      }
    } else if (event is UpdateUserActivities) {
      if (state is LoginState) {
        yield LoginState(
            allActivities: (state as LoginState).allActivities,
            userActivities: event.activities,
            valid: checkValidity((state as LoginState).userDetail),
            message: generateValidityMessage((state as LoginState).userDetail),
            userDetail: (state as LoginState).userDetail);
      }
    } else if (event is UpdateName) {
      if (state is LoginState) {
        UserDetail prevDetail = (state as LoginState).userDetail;
        prevDetail.copyWith(name: event.name);
        yield LoginState(
            allActivities: (state as LoginState).allActivities,
            userActivities: (state as LoginState).userActivities,
            userDetail:
                (state as LoginState).userDetail.copyWith(name: event.name),
            valid: checkValidity(
                (state as LoginState).userDetail.copyWith(name: event.name)),
            message: generateValidityMessage(
                (state as LoginState).userDetail.copyWith(name: event.name)));
      }
    } else if (event is UpdateAge) {
      if (state is LoginState) {
        UserDetail prevDetail = (state as LoginState).userDetail;
        prevDetail.copyWith(age: event.age);
        yield LoginState(
            allActivities: (state as LoginState).allActivities,
            userActivities: (state as LoginState).userActivities,
            userDetail:
                (state as LoginState).userDetail.copyWith(age: event.age),
            valid: checkValidity(
                (state as LoginState).userDetail.copyWith(age: event.age)),
            message: generateValidityMessage(
                (state as LoginState).userDetail.copyWith(age: event.age)));
      }
    } else if (event is UpdateProfession) {
      if (state is LoginState) {
        UserDetail prevDetail = (state as LoginState).userDetail;
        prevDetail.copyWith(profession: event.prof);
        yield LoginState(
            allActivities: (state as LoginState).allActivities,
            userActivities: (state as LoginState).userActivities,
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
    } else if (event is SaveDetails) {
      print("@SaveDetails  " + event.activities.length.toString());
      if (event.activities.length > 0)
        await repository.deleteUserActivityTable();
      event.activities.forEach((element) {
        print(element.name);
        repository.add(element);
      });
      //print("at save  >>>" + event.details.currentDevice);
      UserDetail toSaveDetail = event.details
          .copyWith(currentDevice: deviceName, currentDeviceId: deviceId);
      repository.addUser(toSaveDetail);
      yield SuccessState();
    }
  }

  Stream<UserIntroductionState> doOnEndDownloadEvent() async* {
    Failure failure;
    List<ActivityModel> allActivities;
    List<UserAModel> userActivities;
    UserDetail userDetail;
    print(doOnEndDownloadEvent);

    var failureOrAllActivities = await repository.cloudActivities;
    failureOrAllActivities.fold((l) {
      failure = l;
    }, (r) {
      allActivities = r;
    });
    print(allActivities);
    var failureOrUserActivities = await repository.userActivities;
    failureOrUserActivities.fold((l) {
      failure = l;
    }, (r) {
      userActivities = r;
    });
    print(userActivities);
    if (oldState == null || !oldState) {
      userDetail = new UserDetail(name: userName);
    } else {
      var failureOrUserDetails = await repository.userDetails;
      failureOrUserDetails.fold((l) {
        failure = l;
      }, (r) {
        userDetail = r;
      });
      print(userDetail);
    }
    if (failure == null) {
      yield LoginState(
          allActivities: allActivities,
          userActivities: userActivities,
          userDetail: userDetail,
          valid: checkValidity(userDetail),
          message: "Please select your interests");
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
}
