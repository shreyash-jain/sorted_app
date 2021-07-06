part of 'recipe_bloc.dart';

abstract class RecipeEvent extends Equatable {
  const RecipeEvent();
}

class LoadRecipes extends RecipeEvent {
  @override
  List<Object> get props => [];
}

class LoadRecipeFullPage extends RecipeEvent {
  final int type;
  final RecipeModel recipe;
  final TaggedRecipe taggedRecipe;

  LoadRecipeFullPage(this.type, this.recipe, this.taggedRecipe);
  @override
  List<Object> get props => [type, recipe, taggedRecipe];
}
