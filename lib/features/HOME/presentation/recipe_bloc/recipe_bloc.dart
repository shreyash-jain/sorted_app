import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/features/HOME/data/datasources/home_cloud_data_source.dart';
import 'package:sorted/features/HOME/data/models/blog_textbox.dart';
import 'package:sorted/features/HOME/data/models/blogs.dart';
import 'package:sorted/features/HOME/data/models/recipes/recipe.dart';
import 'package:sorted/features/HOME/data/models/recipes/recipe_howto.dart';

import 'package:sorted/features/HOME/data/models/recipes/recipe_nutrition.dart';
import 'package:sorted/features/HOME/data/models/recipes/recipe_step.dart';
import 'package:sorted/features/HOME/data/models/recipes/recipe_to_ingredient.dart';
import 'package:sorted/features/HOME/data/models/recipes/tagged_recipe.dart';
import 'package:sorted/features/HOME/data/models/recipes/video_recipe.dart';
import 'package:sorted/features/HOME/domain/repositories/home_repository.dart';
part 'recipe_event.dart';
part 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final HomeRepository repository;
  RecipeBloc(this.repository) : super(RecipeInitial());

  @override
  Stream<RecipeState> mapEventToState(
    RecipeEvent event,
  ) async* {
    if (event is LoadRecipes) {
      Failure failure;
      List<TaggedRecipe> recipes = [];
      VideoRecipe vRecipe;
      TaggedRecipe vTaggedRecipe;

      var recipesOrError = await repository.getTaggedRecipes(8);
      recipesOrError.fold((l) => failure = l, (r) => recipes = r);
      print("Here 1" + Failure.mapToString(failure));
      var videoRecipeOrError = await repository.getVideoRecipe();
      videoRecipeOrError.fold((l) => failure = l, (r) => vRecipe = r);
      print("Here 2" + Failure.mapToString(failure));
      if (vRecipe != null && vRecipe.id != -1) {
        var vTaggedRecipeOrError =
            await repository.getTaggedRecipesOfId(vRecipe.id);
        vTaggedRecipeOrError.fold((l) => failure = l, (r) => vTaggedRecipe = r);
      } else {
        vTaggedRecipe = TaggedRecipe.empty();
      }

      print("Here 3" + Failure.mapToString(failure));

      if (failure == null)
        yield HomePageRecipesLoaded(recipes, vRecipe, vTaggedRecipe);
      else {
        yield RecipeError(Failure.mapToString(failure));
      }

      // if (failure == null)
      //   yield RecipeLoaded(blogs);
      // else
      //   yield RecipeError(Failure.mapToString(failure));
    } else if (event is LoadRecipeFullPage) {
      Failure failure;
      int type = event.type;
      List<RecipeIngredients> ingredients = [];
      List<RecipeStep> steps = [];
      RecipeModel recipe;

      List<RecipeNutrition> nutritions = [];

      int recipeId =
          (type == 0) ? event.taggedRecipe.recipe_id : event.recipe.id;

      var recipeResult = await repository.getRecipeById(recipeId);

      recipeResult.fold((l) => failure = l, (r) => recipe = r);

      if (failure == null) {
        for (var i = 0; i < recipe.ingredients_name.length; i++) {
          ingredients.add(RecipeIngredients(
              name: recipe.ingredients_name[i],
              unit: recipe.ingredients_units[i],
              quality: recipe.ingredients_quantity[i]));
        }
        for (var i = 0; i < recipe.nutrients_name.length; i++) {
          nutritions.add(RecipeNutrition(
              nutrients: recipe.nutrients_name[i],
              units: recipe.nutrients_units[i],
              value: recipe.nutrients_value[i]));
        }

        for (var i = 0; i < recipe.steps.length; i++) {
          steps.add(RecipeStep(
            description: recipe.steps[i],
            step: i,
          ));
        }

        yield RecipePageLoaded(ingredients, steps, nutritions, recipe);
      } else
        yield RecipeError(Failure.mapToString(failure));
    }
  }
}
