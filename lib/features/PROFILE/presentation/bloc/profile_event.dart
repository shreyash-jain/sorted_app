part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadProfile extends ProfileEvent {}

class Signout extends ProfileEvent {}

class UpdateHealthDailyActivity extends ProfileEvent {
  final int category;

  UpdateHealthDailyActivity(this.category);
  @override
  List<Object> get props => [category];
}

class UpdateHealthGoalActivity extends ProfileEvent {
  final int category;

  UpdateHealthGoalActivity(this.category);
  @override
  List<Object> get props => [category];
}

class UpdateMentalGoalActivity extends ProfileEvent {
  final int category;

  UpdateMentalGoalActivity(this.category);
  @override
  List<Object> get props => [category];
}

class UpdateSleepActivity extends ProfileEvent {
  final int category;

  UpdateSleepActivity(this.category);
  @override
  List<Object> get props => [category];
}

class UpdateFoodPreference extends ProfileEvent {
  final int category;

  UpdateFoodPreference(this.category);
  @override
  List<Object> get props => [category];
}

class UpdateHealthCondition extends ProfileEvent {
  final int category;

  UpdateHealthCondition(this.category);
  @override
  List<Object> get props => [category];
}

class UpdateMentalDailyActivity extends ProfileEvent {
  final int category;

  UpdateMentalDailyActivity(this.category);
  @override
  List<Object> get props => [category];
}

class UpdateHeight extends ProfileEvent {
  final double heightInCm;

  UpdateHeight(this.heightInCm);
  @override
  List<Object> get props => [heightInCm];
}

class UpdateWeight extends ProfileEvent {
  final double weightInKG;

  UpdateWeight(this.weightInKG);
  @override
  List<Object> get props => [weightInKG];
}

class SaveDetails extends ProfileEvent {
  final UserDetail details;
  final HealthProfile healthProfile;

  SaveDetails(this.details, this.healthProfile);
  @override
  List<Object> get props => [details];
}
