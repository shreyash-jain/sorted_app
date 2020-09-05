part of 'interest_bloc.dart';

abstract class UserInterestState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadedState extends UserInterestState {
  final List<UserAModel> activities;
  LoadedState(this.activities);
  @override
  List<Object> get props => [activities];
}

class LoadingState extends UserInterestState {}
