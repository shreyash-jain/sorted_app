part of 'activity_search_bloc.dart';

abstract class ActivitySearchEvent extends Equatable {
  const ActivitySearchEvent();
}

class SearchByQuery extends ActivitySearchEvent {
  final List<int> fields;
  final String text;
  final ActivitySearchState prevState;

  SearchByQuery(this.fields, this.text, this.prevState);
  @override
  List<Object> get props => [fields, text, prevState];
}
