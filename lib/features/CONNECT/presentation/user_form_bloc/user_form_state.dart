part of 'user_form_bloc.dart';

abstract class UserRequestFormProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadedFormState extends UserRequestFormProfileState {
  final UserDetail userDetail;
  final MindfulGoals mindfulGoals;
  final String messageToTrainer;
  final UserFoodPreferences foodPreferences;
  final HealthConditions healthConditions;
  final FitnessGoals fitnessGoals;
  final DateTime startDate;
  final int timeSlot;
  final ExpertCalendarModel calendarModel;

  LoadedFormState(
      this.userDetail, this.startDate, this.timeSlot, this.calendarModel,
      {this.fitnessGoals,
      this.mindfulGoals,
      this.messageToTrainer,
      this.foodPreferences,
      this.healthConditions});
  @override
  List<Object> get props => [
        userDetail,
        messageToTrainer,
        foodPreferences,
        healthConditions,
        fitnessGoals
      ];

  LoadedFormState copyWith({
    UserDetail userDetail,
    MindfulGoals mindfulGoals,
    String messageToTrainer,
    UserFoodPreferences foodPreferences,
    HealthConditions healthConditions,
    FitnessGoals fitnessGoals,
    DateTime startDate,
    int timeSlot,
    ExpertCalendarModel calendarModel,
  }) {
    return LoadedFormState(
      userDetail ?? this.userDetail,
      startDate ?? this.startDate,
      timeSlot ?? this.timeSlot,
      calendarModel ?? this.calendarModel,
      fitnessGoals: fitnessGoals ?? this.fitnessGoals,
      mindfulGoals: mindfulGoals ?? this.mindfulGoals,
      messageToTrainer: messageToTrainer ?? this.messageToTrainer,
      foodPreferences: foodPreferences ?? this.foodPreferences,
      healthConditions: healthConditions ?? this.healthConditions,
    );
  }
}

class InitialFormState extends UserRequestFormProfileState {}

class FormErrorState extends UserRequestFormProfileState {
  final String message;

  FormErrorState(this.message);
  @override
  List<Object> get props => [message];
}
