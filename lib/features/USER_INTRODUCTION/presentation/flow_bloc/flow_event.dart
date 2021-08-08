part of 'flow_bloc.dart';

abstract class FlowEvent extends Equatable {
  @override
  List<Object> get props => [];
}
class GetUserHistoryStatus extends FlowEvent {}
class StartDownload extends FlowEvent {}


class EndDownload extends FlowEvent {}

class UpdateProgress extends FlowEvent {
  final double progress;
  UpdateProgress(this.progress);
  @override
  List<Object> get props => [progress];
}

class UpdateUsername extends FlowEvent {
  final String name;
  UpdateUsername(this.name);
  @override
  List<Object> get props => [name];
}
class UpdateGender extends FlowEvent {
  final Gender gender;
  UpdateGender(this.gender);
  @override
  List<Object> get props => [gender];
}
class UpdateProfession extends FlowEvent {
  final Profession prof;
  UpdateProfession(this.prof);
  @override
  List<Object> get props => [prof];
}
class UpdateAge extends FlowEvent {
  final int age;
  UpdateAge(this.age);
  @override
  List<Object> get props => [age];
}

class UpdatePhoneNumber extends FlowEvent {
  final String phoneNumber;
  UpdatePhoneNumber(this.phoneNumber);
  @override
  List<Object> get props => [phoneNumber];
}

class SaveDetails extends FlowEvent {
  final UserDetail details;

  SaveDetails(this.details);
  @override
  List<Object> get props => [details];
}