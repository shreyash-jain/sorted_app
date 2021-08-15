import 'package:flutter/material.dart';

import 'package:sorted/features/HOME/data/models/recipes/recipe_to_ingredient.dart';
import 'package:sorted/core/global/utility/utils.dart';

class IngredientTile extends StatelessWidget {
  final RecipeIngredients ingredient;
  const IngredientTile({Key key, this.ingredient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black.withAlpha(6)),
          padding: EdgeInsets.all(8),
          child: RichText(
            text: TextSpan(
                text: ingredient.name.capitalize(),
                style: TextStyle(color: Colors.black, fontSize: 18),
                children: <TextSpan>[
                  if (ingredient.unit != "" && (ingredient.quality != 0))
                    TextSpan(
                      text: " " + ingredient.quality.toString(),
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  if (ingredient.unit != "" && (ingredient.quality != 0))
                    TextSpan(
                      text: " " + ingredient.unit.toString(),
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    )
                ]),
          ),
        ),
      ],
    );
  }
}
