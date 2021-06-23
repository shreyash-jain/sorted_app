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
                  height: 240,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      HomeRecipeWidgetL(
                        recipe: state.taggedVideoRecipe,
                        videoRecipe: state.videoRecipe,
                      ),
                      ...state.recipes
                          .asMap()
                          .entries
                          .map((e) => HomeRecipeWidgetM(
                              recipes: state.recipes,
                              index: e.key,
                              onClick: (blog, index) {}))
                          .toList()
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
