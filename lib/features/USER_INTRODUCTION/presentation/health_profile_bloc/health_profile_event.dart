part of 'health_profile_bloc.dart';

abstract class HealthProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Add extends HealthProfileEvent {
  final UserTag tag;
  final int type;
  Add(this.tag, this.type);
  @override
  List<Object> get props => [tag, type];
}

class LoadProfile extends HealthProfileEvent {}

class UpdateProfile extends HealthProfileEvent {
  final HealthProfile lifestyleProfile;

  UpdateProfile(
    this.lifestyleProfile,
  );
  @override
  List<Object> get props => [
     
        lifestyleProfile,
      
      ];
}

class UpdateHealthDailyActivity extends HealthProfileEvent {
  final int category;

  UpdateHealthDailyActivity(this.category);
  @override
  List<Object> get props => [category];
}

class UpdateHealthGoalActivity extends HealthProfileEvent {
  final int category;

  UpdateHealthGoalActivity(this.category);
  @override
  List<Object> get props => [category];
}

class UpdateMentalGoalActivity extends HealthProfileEvent {
  final int category;

  UpdateMentalGoalActivity(this.category);
  @override
  List<Object> get props => [category];
}

class UpdateSleepActivity extends HealthProfileEvent {
  final int category;

  UpdateSleepActivity(this.category);
  @override
  List<Object> get props => [category];
}

class UpdateFoodPreference extends HealthProfileEvent {
  final int category;

  UpdateFoodPreference(this.category);
  @override
  List<Object> get props => [category];
}

class UpdateMentalDailyActivity extends HealthProfileEvent {
  final int category;

  UpdateMentalDailyActivity(this.category);
  @override
  List<Object> get props => [category];
}

class UpdateHeight extends HealthProfileEvent {
  final double heightInCm;

  UpdateHeight(this.heightInCm);
  @override
  List<Object> get props => [heightInCm];
}

class UpdateWeight extends HealthProfileEvent {
  final double weightInKG;

  UpdateWeight(this.weightInKG);
  @override
  List<Object> get props => [weightInKG];
}

class ChangeHealthConditionStatus extends HealthProfileEvent {
  ChangeHealthConditionStatus();
}

class ChangeHealthCondition extends HealthProfileEvent {
  final int condition;
  ChangeHealthCondition(this.condition);
  @override
  List<Object> get props => [condition];
}

class SaveHealthProfile extends HealthProfileEvent {
  SaveHealthProfile();
}

class Remove extends HealthProfileEvent {
  final UserTag tag;
  final int type;
  Remove(this.tag, this.type);
  @override
  List<Object> get props => [tag, type];
}
