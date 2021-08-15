part of 'recipe_bloc.dart';

abstract class RecipeState extends Equatable {
  const RecipeState();
}

class RecipeInitial extends RecipeState {
  @override
  List<Object> get props => [];
}

class HomePageRecipesLoaded extends RecipeState {
  final List<TaggedRecipe> recipes;
  final VideoRecipe videoRecipe;
  final TaggedRecipe taggedVideoRecipe;

  HomePageRecipesLoaded(this.recipes, this.videoRecipe, this.taggedVideoRecipe);

  List<Object> get props => [recipes, videoRecipe, taggedVideoRecipe];
}

class RecipeError extends RecipeState {
  final String message;

  RecipeError(this.message);
  @override
  List<Object> get props => [message];
}

class RecipePageLoaded extends RecipeState {
  final List<RecipeIngredients> ingredients;
  final List<RecipeStep> steps;

  final List<RecipeNutrition> nutritions;


  final RecipeModel recipe;


  RecipePageLoaded(this.ingredients, this.steps, this.nutritions, this.recipe,
  );
  @override
  List<Object> get props =>
      [ingredients, steps, nutritions, recipe];
}
