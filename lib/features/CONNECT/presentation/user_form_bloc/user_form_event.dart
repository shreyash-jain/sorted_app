part of 'user_form_bloc.dart';

abstract class UserRequestFormEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadProfile extends UserRequestFormEvent {
  final int formType;
  final ExpertCalendarModel calendarModel;

  LoadProfile(this.formType, this.calendarModel);
  @override
  List<Object> get props => [formType, calendarModel];
}

class UpdateProfile extends UserRequestFormEvent {
  final HealthProfile lifestyleProfile;

  UpdateProfile(
    this.lifestyleProfile,
  );
  @override
  List<Object> get props => [
        lifestyleProfile,
      ];
}

class UpdateHealthCondition extends UserRequestFormEvent {
  final HealthConditions condition;
  UpdateHealthCondition(this.condition);
  @override
  List<Object> get props => [condition];
}

class SaveHealthProfile extends UserRequestFormEvent {
  SaveHealthProfile();
}

class UpdateFitnessGoals extends UserRequestFormEvent {
  final FitnessGoals goals;
  UpdateFitnessGoals(this.goals);
  @override
  List<Object> get props => [goals];
}

class UpdateMindfulGoals extends UserRequestFormEvent {
  final MindfulGoals goals;
  UpdateMindfulGoals(this.goals);
  @override
  List<Object> get props => [goals];
}

class UpdateFoodPreference extends UserRequestFormEvent {
  final UserFoodPreferences preferences;
  UpdateFoodPreference(this.preferences);
  @override
  List<Object> get props => [preferences];
}
