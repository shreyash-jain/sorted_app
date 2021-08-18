import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/features/HOME/data/models/recipes/recipe.dart';

import 'package:sorted/features/HOME/data/models/recipes/recipe_step.dart';
import 'package:sorted/features/HOME/data/models/recipes/recipe_to_ingredient.dart';
import 'package:sorted/features/HOME/data/models/recipes/tagged_recipe.dart';
import 'package:sorted/features/HOME/domain/repositories/home_repository.dart';
import 'package:sorted/features/HOME/presentation/recipe_bloc/recipe_bloc.dart';
import 'package:sorted/features/HOME/presentation/widgets/recipes/ingredient_tile.dart';
import 'package:sorted/features/HOME/presentation/widgets/recipes/recipe_nutririon.dart';
import 'package:timelines/timelines.dart';

class RecipePage extends StatefulWidget {
  final int type;
  final RecipeModel recipe;
  final TaggedRecipe taggedRecipe;
  RecipePage({Key key, this.type, this.recipe, this.taggedRecipe})
      : super(key: key);

  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  RecipeBloc recipeBloc;
  Map<String, double> dataMap = {};
  bool isReadMore = false;
  @override
  void initState() {
    recipeBloc = new RecipeBloc(sl<HomeRepository>())
      ..add(
          LoadRecipeFullPage(widget.type, widget.recipe, widget.taggedRecipe));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) => recipeBloc,
          child: Container(
            child: BlocBuilder<RecipeBloc, RecipeState>(
              builder: (context, state) {
                if (state is RecipePageLoaded)
                  return SingleChildScrollView(
                      child: Column(
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.all(Gparam.widthPadding),
                              child: Gtheme.stext(state.recipe.name,
                                  weight: GFontWeight.B, size: GFontSize.M),
                            ),
                          ),
                        ],
                      ),
                      if (state.recipe.image_url != null &&
                          state.recipe.image_url != "")
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Gparam.widthPadding),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                  imageUrl: state.recipe.image_url,
                                  errorWidget: (c, s, d) =>
                                      Icon(Icons.error_outline),
                                  width: Gparam.width - 2 * Gparam.widthPadding,
                                  height:
                                      (Gparam.width - 2 * Gparam.widthPadding) *
                                          .9,
                                  fit: BoxFit.cover)),
                        ),
                      SizedBox(
                        height: 16,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isReadMore = !isReadMore;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Gparam.widthPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.recipe.description,
                                overflow: TextOverflow.ellipsis,
                                maxLines: (isReadMore) ? 20 : 3,
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontFamily: 'Milliard',
                                    fontSize: Gparam.textSmall,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                isReadMore ? "show less" : "read more",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontFamily: 'Milliard',
                                    fontSize: Gparam.textSmaller,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (state.recipe.nutrients_name.length != 0)
                        SizedBox(
                          height: 16,
                        ),
                      if (state.ingredients.length != 0)
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Gparam.widthPadding),
                              child: Gtheme.stext("Ingredients",
                                  weight: GFontWeight.B, size: GFontSize.S),
                            ),
                          ],
                        ),
                      if (state.ingredients.length != 0)
                        SizedBox(
                          height: 16,
                        ),
                      if (state.ingredients.length != 0)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0),
                          child: Container(
                            height: 50,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                SizedBox(width: Gparam.widthPadding),
                                ...state.ingredients.asMap().entries.map((e) {
                                  return Column(
                                    children: [
                                      IngredientTile(
                                        ingredient: e.value,
                                      )
                                    ],
                                  );
                                }).toList()
                              ],
                            ),
                          ),
                        ),
                      SizedBox(
                        height: 24,
                      ),
                      if (state.recipe.nutrients_name.length != 0)
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Gparam.widthPadding),
                              child: Gtheme.stext("Nutrition Info",
                                  weight: GFontWeight.B, size: GFontSize.S),
                            ),
                          ],
                        ),
                      if (state.recipe.nutrients_name.length != 0)
                        SizedBox(
                          height: 16,
                        ),
                      if (state.recipe.nutrients_name.length != 0)
                        RecipeNutritionWidget(nutritions: state.nutritions),
                      SizedBox(
                        height: 24,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Gparam.widthPadding),
                            child: Gtheme.stext("Steps to make",
                                weight: GFontWeight.B, size: GFontSize.S),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: Gparam.widthPadding),
                        child: Wrap(
                          children: [
                            ...getSteps(state.steps),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  ));
                else if (state is RecipeInitial) {
                  return Center(child: LoadingWidget());
                } else
                  return Container(
                    height: 0,
                  );
              },
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getIngredients(List<RecipeIngredients> ingredients) {
    List<Widget> items = [];
    for (var i = 0; i < ingredients.length; i++) {
      items.add(IngredientTile(
        ingredient: ingredients[i],
      ));
    }
    return items;
  }

  List<Widget> getSteps(List<RecipeStep> steps) {
    List<Widget> items = [];
    for (var i = 0; i < steps.length; i++) {
      items.add(Container(
        padding: EdgeInsets.all(4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OutlinedDotIndicator(
              color: Color(0xffe6e7e9),
              backgroundColor: Color(0xffc2c5c9),
              borderWidth: 2.5,
            ),
            SizedBox(width: 14),
            Flexible(child: Gtheme.stext(steps[i].description.toString()))
          ],
        ),
      ));
    }
    return items;
  }
}

enum _TimelineStatus {
  done,
  sync,
  inProgress,
  todo,
}

extension on _TimelineStatus {
  bool get isInProgress => this == _TimelineStatus.inProgress;
}

const kTileHeight = 50.0;
