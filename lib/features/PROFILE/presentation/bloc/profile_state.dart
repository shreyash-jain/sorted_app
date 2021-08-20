part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  @override
  List<Object> get props => [];
}

class ProfileLoaded extends ProfileState {
  final HealthProfile healthProfile;
  final UserDetail details;

  ProfileLoaded(
    this.healthProfile,
    this.details,
  );

  @override
  List<Object> get props => [healthProfile, details];

  ProfileLoaded copyWith({
    HealthProfile healthProfile,
    UserDetail details,
  }) {
    return ProfileLoaded(
      healthProfile ?? this.healthProfile,
      details ?? this.details,
    );
  }
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);

  @override
  List<Object> get props => [message];
}
