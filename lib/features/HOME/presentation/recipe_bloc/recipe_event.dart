part of 'recipe_bloc.dart';

abstract class RecipeEvent extends Equatable {
  const RecipeEvent();
}

class LoadRecipes extends RecipeEvent {
  @override
  List<Object> get props => [];
}

