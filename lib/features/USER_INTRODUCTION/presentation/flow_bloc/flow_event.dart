part of 'flow_bloc.dart';

abstract class FlowEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetUserHistoryStatus extends FlowEvent {}

class StartDownload extends FlowEvent {}

class EndDownload extends FlowEvent {}

class UpdateProgress extends FlowEvent {
  final double progress;
  UpdateProgress(this.progress);
  @override
  List<Object> get props => [progress];
}

class UpdateGender extends FlowEvent {
  final Gender gender;
  UpdateGender(this.gender);
  @override
  List<Object> get props => [gender];
}

class UpdateProfession extends FlowEvent {
  final Profession prof;
  UpdateProfession(this.prof);
  @override
  List<Object> get props => [prof];
}

class UpdateAge extends FlowEvent {
  final int age;
  UpdateAge(this.age);
  @override
  List<Object> get props => [age];
}

class UpdatePhoneNumberFromTrueCaller extends FlowEvent {
  final String phoneNumber;
  UpdatePhoneNumberFromTrueCaller(this.phoneNumber);
  @override
  List<Object> get props => [phoneNumber];
}

class SaveDetails extends FlowEvent {
  final UserDetail details;
  final HealthProfile healthProfile;

  SaveDetails(this.details, this.healthProfile);
  @override
  List<Object> get props => [details];
}

class SetInvalidPhone extends FlowEvent {}

class SetValidPhone extends FlowEvent {}

////////////////////////////////////
///
///
///
///
///
///
///
///
///

class UpdateHealthDailyActivity extends FlowEvent {
  final int category;

  UpdateHealthDailyActivity(this.category);
  @override
  List<Object> get props => [category];
}

class UpdateHealthGoalActivity extends FlowEvent {
  final int category;

  UpdateHealthGoalActivity(this.category);
  @override
  List<Object> get props => [category];
}

class UpdateMentalGoalActivity extends FlowEvent {
  final int category;

  UpdateMentalGoalActivity(this.category);
  @override
  List<Object> get props => [category];
}

class UpdateSleepActivity extends FlowEvent {
  final int category;

  UpdateSleepActivity(this.category);
  @override
  List<Object> get props => [category];
}

class UpdateFoodPreference extends FlowEvent {
  final int category;

  UpdateFoodPreference(this.category);
  @override
  List<Object> get props => [category];
}

class UpdateMentalDailyActivity extends FlowEvent {
  final int category;

  UpdateMentalDailyActivity(this.category);
  @override
  List<Object> get props => [category];
}

class UpdateHeight extends FlowEvent {
  final double heightInCm;

  UpdateHeight(this.heightInCm);
  @override
  List<Object> get props => [heightInCm];
}

class UpdateWeight extends FlowEvent {
  final double weightInKG;

  UpdateWeight(this.weightInKG);
  @override
  List<Object> get props => [weightInKG];
}

class RequestOTP extends FlowEvent {
  final String phoneNumber;

  RequestOTP(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

class ResendOTP extends FlowEvent {
  ResendOTP();

  @override
  List<Object> get props => [];
}



/////////////////////////
///
///
///
///
///
///
///

