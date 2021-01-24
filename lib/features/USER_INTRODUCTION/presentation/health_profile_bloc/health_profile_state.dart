part of 'health_profile_bloc.dart';

abstract class HealthProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadedState extends HealthProfileState {
  final PhysicalHealthProfile fitnessProfile;
  final MentalHealthProfile mentalProfile;
  final LifestyleProfile lifestyleProfile;
  final HealthConditions healthCondition;
  final AddictionConditions addictionCondition;

  LoadedState(this.fitnessProfile, this.mentalProfile, this.lifestyleProfile,
      this.healthCondition, this.addictionCondition);
  @override
  List<Object> get props => [
        fitnessProfile,
        mentalProfile,
        lifestyleProfile,
        healthCondition,
        addictionCondition
      ];
}

class LoadingState extends HealthProfileState {}
