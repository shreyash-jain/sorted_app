import 'package:flutter/material.dart';
import 'package:sorted/features/HOME/data/models/recipes/recipe_ingredient.dart';
import 'package:sorted/features/HOME/data/models/recipes/recipe_to_ingredient.dart';

class IngredientTile extends StatelessWidget {
  final RecipeIngredient ingredient;
  final RecipeToIngredient quantity;
  const IngredientTile({Key key, this.ingredient, this.quantity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          child: RichText(
            text: TextSpan(
                text: ingredient.name,
                style: TextStyle(color: Colors.black, fontSize: 18),
                children: <TextSpan>[
                  TextSpan(
                    text: quantity.quality.toString(),
                    style: TextStyle(color: Colors.blueAccent, fontSize: 18),
                  )
                ]),
          ),
        ),
      ],
    );
  }
}
