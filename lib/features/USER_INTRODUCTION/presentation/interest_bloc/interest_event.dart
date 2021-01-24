part of 'interest_bloc.dart';

abstract class UserInterestEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Add extends UserInterestEvent {
  final UserTag tag;
  final int type;
  Add(this.tag, this.type);
  @override
  List<Object> get props => [tag, type];
}

class LoadInterest extends UserInterestEvent {}

class Remove extends UserInterestEvent {
  final UserTag tag;
  final int type;
  Remove(this.tag, this.type);
  @override
  List<Object> get props => [tag, type];
}

class SaveInterests extends UserInterestEvent {
  SaveInterests();
}
