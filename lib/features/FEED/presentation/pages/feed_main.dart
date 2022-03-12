import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/features/FEED/presentation/bloc/feed_bloc.dart';
import 'package:sorted/features/FEED/presentation/widgets/feed_widget.dart';
import 'package:sorted/features/FEED/presentation/widgets/image_post.dart';
import 'package:sorted/features/HOME/presentation/recipe_bloc/recipe_bloc.dart';
import 'package:sorted/features/HOME/presentation/transformation_bloc/transformation_bloc.dart';
import 'package:sorted/features/HOME/presentation/widgets/recipes/home_recipe.dart';
import 'package:sorted/features/HOME/presentation/widgets/transformation/transformation_widget.m.dart';

class FeedHomePage extends StatefulWidget {
  FeedHomePage({Key key}) : super(key: key);

  @override
  _FeedHomePageState createState() => _FeedHomePageState();
}

class _FeedHomePageState extends State<FeedHomePage> {
  TransformationBloc transBloc;
  RecipeBloc recipeBloc;
  FeedBloc feedBloc;

  @override
  void initState() {
    super.initState();

    feedBloc = FeedBloc(sl())..add(GetUserFeed());
    recipeBloc = sl<RecipeBloc>()..add(LoadRecipes());
    transBloc = sl<TransformationBloc>()..add(LoadTransformation());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(Gparam.widthPadding),
                  child: Row(
                    children: [
                      Icon(
                        Icons.post_add,
                        size: 35,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gtheme.stext("CREATE A POST",
                                size: GFontSize.XS, weight: GFontWeight.B1),
                            SizedBox(
                              height: 4,
                            ),
                            Gtheme.stext("This feature is coming soon",
                                size: GFontSize.XXS, weight: GFontWeight.L),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Divider(color: Colors.grey.shade400),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Gparam.widthPadding, vertical: 10),
                  child: Row(
                    children: [
                      Flexible(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.question_answer_outlined,
                              size: 20,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Gtheme.stext("Add Discussion",
                                size: GFontSize.XXS, weight: GFontWeight.N),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey.shade400,
                  thickness: 2,
                ),
                Container(
                    height: 35,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: [
                        SizedBox(width: Gparam.widthPadding),
                        Container(
                          padding: EdgeInsets.all(4),
                          margin: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  width: 3.0,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                          child: Gtheme.stext(
                              "Add to feed feature is coming soon",
                              size: GFontSize.XXS,
                              weight: GFontWeight.N),
                        ),
                      ],
                    )),
                Row(
                  children: [
                    HomeTransformationWidgetM(
                      transBloc: transBloc,
                    ),
                  ],
                ),
                HomeRecipeWidget(
                  recipeBloc: recipeBloc,
                ),
                BlocProvider(
                  create: (context) => feedBloc,
                  child: BlocBuilder<FeedBloc, FeedState>(
                    builder: (context, state) {
                      if (state is FeedLoaded)
                        return Column(
                          children: [
                            ...state.posts.posts.asMap().entries.map(
                                  (e) => Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Gparam.widthPadding,
                                        vertical: Gparam.widthPadding / 2),
                                    child: FeedWidget(post: e.value),
                                  ),
                                )
                          ],
                        );
                      else
                        return Container(
                          height: 0,
                        );
                    },
                  ),
                ),
                SizedBox(
                  height: 80,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
