part of 'recipe_search_bloc.dart';

abstract class RecipeSearchState extends Equatable {
  const RecipeSearchState();
}

class RecipeSearchInitial extends RecipeSearchState {
  @override
  List<Object> get props => [];
}

class RecipeSearchListLoaded extends RecipeSearchState {
  final List<RecipeModel> recipes;
  final List<int> filterFields;

  final bool isLoading;

  RecipeSearchListLoaded(this.recipes, this.filterFields, this.isLoading);

  @override
  List<Object> get props => [recipes, isLoading, filterFields];
}

class RecipeSearchError extends RecipeSearchState {
  final String message;

  RecipeSearchError(this.message);
  @override
  List<Object> get props => [message];
}
