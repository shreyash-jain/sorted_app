part of 'cover_bloc.dart';

abstract class CoverEvent extends Equatable {
  const CoverEvent();
}

class LoadImages extends CoverEvent {
  @override
  List<Object> get props => [];
}

class UpdateGoals extends CoverEvent {
  final List<GoalModel> goals;
  UpdateGoals(this.goals);

  @override
  List<Object> get props => [goals];
}

class SearchUnsplash extends CoverEvent {
  final String search;
  SearchUnsplash(this.search);

  @override
  List<Object> get props => [search];
}
class TestEvent extends CoverEvent {
  

  @override
  List<Object> get props => [];
}

class StartSearchEvent extends CoverEvent {
  

  @override
  List<Object> get props => [];
}


class UpdateTabs extends CoverEvent {
  final List<PlanTabDetails> tabs;
  UpdateTabs(this.tabs);

  @override
  List<Object> get props => [tabs];
}


