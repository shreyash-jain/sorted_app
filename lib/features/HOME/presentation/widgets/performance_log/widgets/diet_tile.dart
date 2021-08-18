import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/widgets/image_placeholder_widget.dart';
import 'package:sorted/core/routes/router.gr.dart';
import 'package:sorted/features/HOME/data/models/recipes/recipe.dart';
import 'package:sorted/features/PLANNER/data/models/day_diets.dart';
import 'package:auto_route/auto_route.dart';

class MealTile extends StatelessWidget {
  final DietModel meal;
  const MealTile({Key key, this.meal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.router
            .push(RecipeRoute(recipe: RecipeModel(id: meal.recipeId), type: 1));
      },
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (meal.recipeImage != "")
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: meal.recipeImage,
                  placeholder: (context, url) => ImagePlaceholderWidget(),
                  errorWidget: (context, url, error) => Icon(
                    Icons.error,
                    color: Colors.grey,
                  ),
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(
              width: 20,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gtheme.stext(meal.name,
                      size: GFontSize.S, weight: GFontWeight.B1),
                  SizedBox(
                    height: 3,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Gtheme.stext(meal.servings.toString(),
                          size: GFontSize.XS),
                      SizedBox(
                        width: 6,
                      ),
                      Gtheme.stext(
                          (meal.servings == 1) ? "Serving" : "Servings",
                          size: GFontSize.XXXS,
                          weight: GFontWeight.B1),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  if (meal.calories != 0)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Gtheme.stext(meal.calories.toString(),
                            size: GFontSize.XS),
                        SizedBox(
                          width: 6,
                        ),
                        Gtheme.stext("Cal",
                            size: GFontSize.XXXS, weight: GFontWeight.B1),
                      ],
                    ),
                  SizedBox(
                    height: 6,
                  ),
                ],
              ),
            ),
            Spacer(),
            Icon(
              Icons.forward_sharp,
              color: Colors.grey.shade300,
            )
          ],
        ),
      ),
    );
  }
}
