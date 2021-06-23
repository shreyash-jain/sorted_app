import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/features/HOME/data/models/blog_textbox.dart';
import 'package:sorted/features/HOME/data/models/blogs.dart';
import 'package:sorted/features/HOME/data/models/tagged_recipe.dart';
import 'package:sorted/features/HOME/data/models/video_recipe.dart';
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
      print("Video here  " + vRecipe.id.toString());
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
    }
  }
}
