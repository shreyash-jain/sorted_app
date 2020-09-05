part of 'interest_bloc.dart';

abstract class UserInterestEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Add extends UserInterestEvent {
  final UserAModel activity;
  Add(this.activity);
  @override
  List<Object> get props => [activity];
}



class Remove extends UserInterestEvent {
  final UserAModel activity;
  Remove(this.activity);
  @override
  List<Object> get props => [activity];
}