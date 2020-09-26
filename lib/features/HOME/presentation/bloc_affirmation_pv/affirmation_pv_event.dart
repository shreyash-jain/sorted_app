part of 'affirmation_pv_bloc.dart';
abstract class AffirmationPVEvent extends Equatable {
  const AffirmationPVEvent();
}
class LoadStories extends AffirmationPVEvent {
  
  @override
  List<Object> get props => [];

}
class Play extends AffirmationPVEvent{
  @override
  
  List<Object> get props => [];


}
class Pause extends AffirmationPVEvent{
  @override
  List<Object> get props => [];
}
class PageChanged extends AffirmationPVEvent{
  final List<DayAffirmation> affirmations;
  final int toPage;
  PageChanged(this.toPage, this.affirmations);
  @override
  List<Object> get props => [toPage,affirmations];
}

class AddToFav extends AffirmationPVEvent{
  final List<DayAffirmation> affirmations;
  final int index;
  AddToFav(this.index,this.affirmations);
  @override
  List<Object> get props => [index,affirmations];
}

class RemoveFromFav extends AffirmationPVEvent{
  final int index;
   final List<DayAffirmation> affirmations;
  RemoveFromFav(this.index, this.affirmations);
  @override
  List<Object> get props => [index,affirmations];
}
class OpenStory extends AffirmationPVEvent {
  final int index;
  OpenStory(this.index);
  @override
  List<Object> get props => [index];
}