part of 'flow_bloc.dart';

abstract class UserIntroductionState extends Equatable {
  @override
  List<Object> get props => [];
}

class UserIntroductionInitial extends UserIntroductionState {}

class UserInteractionState extends UserIntroductionState {
  final bool oldState;
  final double progress;
  final UserDetail userDetail;
  UserInteractionState({this.progress, this.oldState, this.userDetail});

  @override
  List<Object> get props => [oldState, userDetail, progress];
}

class SuccessState extends UserIntroductionState {}

class LoginState extends UserIntroductionState {
  LoginState({
    this.reSendTime,
    this.isOtpLoading,
    this.actualOtp,
    this.isPhoneCorrect,
    this.healthProfile,
    this.userDetail,
    this.valid,
    this.message,
    this.currentNumber
  });
  final int valid;
  final String message;
  final HealthProfile healthProfile;
  final bool isPhoneCorrect;
  final UserDetail userDetail;
  final DateTime reSendTime;
  final bool isOtpLoading;
  final String actualOtp;
  final String currentNumber;

  @override
  List<Object> get props => [
        userDetail,
        valid,
        message,
        healthProfile,
        isPhoneCorrect,
        actualOtp,
        isOtpLoading,
        reSendTime,
        currentNumber
      ];

  LoginState copyWith({
    int valid,
    String message,
    HealthProfile healthProfile,
    bool isPhoneCorrect,
    UserDetail userDetail,
    DateTime reSendTime,
    bool isOtpLoading,
    String actualOtp,
    String currentNumber
  }) {
    return LoginState(
      valid: valid ?? this.valid,
      message: message ?? this.message,
      healthProfile: healthProfile ?? this.healthProfile,
      isPhoneCorrect: isPhoneCorrect ?? this.isPhoneCorrect,
      userDetail: userDetail ?? this.userDetail,
      reSendTime: reSendTime ?? this.reSendTime,
      isOtpLoading: isOtpLoading ?? this.isOtpLoading,
      actualOtp: actualOtp ?? this.actualOtp,
      currentNumber: currentNumber?? this.currentNumber
    );
  }
}

class Error extends UserIntroductionState {
  final String message;

  Error({this.message});

  @override
  List<Object> get props => [message];
}
