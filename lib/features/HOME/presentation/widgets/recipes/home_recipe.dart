import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/routes/router.gr.dart';
import 'package:sorted/features/HOME/presentation/blogs_bloc/blogs_bloc.dart';
import 'package:sorted/features/HOME/presentation/recipe_bloc/recipe_bloc.dart';
import 'package:sorted/features/HOME/presentation/widgets/blogs/blog_widget.m.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sorted/features/HOME/presentation/widgets/heading.dart';
import 'package:sorted/features/HOME/presentation/widgets/recipes/recipe_widget.l.dart';
import 'package:sorted/features/HOME/presentation/widgets/recipes/recipe_widget.m.dart';

class HomeRecipeWidget extends StatelessWidget {
  const HomeRecipeWidget({
    Key key,
    @required this.recipeBloc,
  }) : super(key: key);

  final RecipeBloc recipeBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => recipeBloc,
      child: BlocBuilder<RecipeBloc, RecipeState>(
        builder: (context, state) {
          if (state is RecipeInitial)
            return Container(height: 0, width: 0);
          else if (state is RecipeError) {
            return Center(child: Gtheme.stext(state.message));
          } else if (state is HomePageRecipesLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeHeading(
                  heading: "Recipes",
                  subHeading: "Recommended to reach your health goal",
                ),
                Container(
                  height: 550,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      HomeRecipeWidgetL(
                        recipe: state.taggedVideoRecipe,
                        videoRecipe: state.videoRecipe,
                      ),
                      ...state.recipes.asMap().entries.map((e) {
                        return Column(
                          children: [
                            (2 * e.key < state.recipes.length)
                                ? HomeRecipeWidgetM(
                                    recipes: state.recipes,
                                    index: 2 * e.key,
                                    onClick: (recipes, index) {
                                      context.router.push(RecipeRoute(
                                          type: 0,
                                          taggedRecipe: recipes[2 * e.key]));
                                    })
                                : Container(
                                    height: 0,
                                  ),
                            SizedBox(
                              height: 20,
                            ),
                            (2 * e.key + 1 < state.recipes.length)
                                ? HomeRecipeWidgetM(
                                    recipes: state.recipes,
                                    index: 2 * e.key + 1,
                                    onClick: (recipes, index) {
                                      context.router.push(RecipeRoute(
                                          type: 0,
                                          taggedRecipe: recipes[2 * e.key + 1]));
                                    })
                                : Container(
                                    height: 0,
                                  )
                          ],
                        );
                      }).toList()
                    ],
                  ),
                ),
              ],
            );
          } else
            return Container(height: 0);
        },
      ),
    );
  }
}
