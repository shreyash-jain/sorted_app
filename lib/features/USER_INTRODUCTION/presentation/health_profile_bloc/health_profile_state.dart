part of 'health_profile_bloc.dart';

abstract class HealthProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadedState extends HealthProfileState {
  final HealthProfile healthProfile;

  LoadedState(
    this.healthProfile,
  );
  @override
  List<Object> get props => [
        healthProfile,
      ];
}

class LoadingState extends HealthProfileState {}
