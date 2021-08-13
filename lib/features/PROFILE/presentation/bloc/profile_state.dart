part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  @override
  List<Object> get props => [];
}

class ProfileLoaded extends ProfileState {
  final HealthProfile profile;
  final UserDetail details;

  ProfileLoaded(
    this.profile,
    this.details,
  );

  @override
  List<Object> get props => [profile, details];
}
