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
  LoginState({this.phoneNumber, 
      this.userDetail,
      this.valid,
      this.message,
      this.allActivities,
      this.userActivities});
  final int valid;
  final String message;
  final List<UserAModel> userActivities;
  final List<ActivityModel> allActivities;
  final UserDetail userDetail;
  final String phoneNumber;
  @override
  List<Object> get props =>
      [userDetail, valid, message, allActivities, userActivities,phoneNumber];
}

class Error extends UserIntroductionState {
  final String message;

  Error({this.message});

  @override
  List<Object> get props => [message];
}
