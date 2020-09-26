part of 'affirmation_bloc.dart';
abstract class AffirmationEvent extends Equatable {
  const AffirmationEvent();
}
class LoadStories extends AffirmationEvent {
  
  @override
  List<Object> get props => [];

}
class UpdateAffirmation extends AffirmationEvent {
  
  final List<DayAffirmation> affirmations;
  UpdateAffirmation(this.affirmations);
  @override
  List<Object> get props => [affirmations];
}
class OpenStory extends AffirmationEvent {
  final int index;
  OpenStory(this.index);
  @override
  List<Object> get props => [index];
}