
import 'package:sorted/features/HOME/data/models/recipes/recipe_ingredient.dart';
import 'package:sorted/features/HOME/data/models/recipes/recipe_to_ingredient.dart';

class IngredientAndQuantity {
  final List<RecipeIngredient> ingredient;
  final List<RecipeToIngredient> quantiy;

  IngredientAndQuantity(this.ingredient, this.quantiy);
}
