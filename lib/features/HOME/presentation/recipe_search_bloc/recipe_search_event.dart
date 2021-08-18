part of 'recipe_search_bloc.dart';

abstract class RecipeSearchEvent extends Equatable {
  const RecipeSearchEvent();
}

class SearchByQuery extends RecipeSearchEvent {
  final List<int> fields;
  final String text;
  final RecipeSearchState prevState;

  SearchByQuery(this.fields, this.text, this.prevState);
  @override
  List<Object> get props => [fields, text, prevState];
}
