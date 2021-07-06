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
  final List<RecipeIngredient> ingredients;
  final List<RecipeStep> steps;
  final List<RecipeHowTo> howtos;
  final List<RecipeNutrition> nutritions;
  final List<RecipeToIngredient> quanities;
  final TaggedRecipe taggedRecipe;
 
  final RecipeModel recipe;
  final int type;


  RecipePageLoaded(this.ingredients, this.steps, this.howtos, this.nutritions, this.taggedRecipe, this.recipe, this.type, this.quanities);
  @override
  List<Object> get props => [ingredients,steps,howtos,nutritions,taggedRecipe,recipe,type,quanities];
}
