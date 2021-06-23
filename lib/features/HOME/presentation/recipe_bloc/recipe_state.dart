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
