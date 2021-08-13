part of 'home_bloc.dart';
abstract class ChallengeEvent extends Equatable {
  const ChallengeEvent();
}


class GetTodayChallenge extends ChallengeEvent {
  @override

  List<Object> get props => [];

}