import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleapis/cloudsearch/v1.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/core/global/widgets/message_display.dart';
import 'package:sorted/features/CONNECT/presentation/workout/activity_tile_view.dart';
import 'package:sorted/features/HOME/data/models/recipes/recipe.dart';
import 'package:sorted/features/HOME/presentation/home_stories_bloc/home_stories_bloc.dart';
import 'package:sorted/features/HOME/presentation/track_log_bloc/track_log_bloc.dart';
import 'package:sorted/features/HOME/presentation/widgets/performance_log/widgets/activity_log_view.dart';
import 'package:sorted/features/HOME/presentation/widgets/performance_log/widgets/activity_tile.dart';
import 'package:sorted/features/HOME/presentation/widgets/performance_log/widgets/diet_tile.dart';
import 'package:sorted/features/HOME/presentation/widgets/search_bars/activity_search_bar.dart';
import 'package:sorted/features/HOME/presentation/widgets/search_bars/recipe_search_bar.dart';
import 'package:sorted/features/PLANNER/data/models/activity.dart';
import 'package:sorted/features/PLANNER/data/models/day_diets.dart';
import 'package:sorted/features/PLANNER/data/models/day_workout.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/activity_log.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/activity_summary.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/diet_log.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/diet_summary.dart';
import 'package:sorted/features/TRACKERS/COMMON/performance_track_data/track_data.dart';
import 'package:sorted/features/TRACKERS/COMMON/performance_track_data/track_property_data.dart';
import 'package:sorted/features/TRACKERS/presentation/widgets/diet_analysis_heat_map.dart';

class DietLogPage extends StatefulWidget {
  final HomeStoriesBloc homeBloc;
  final DietLogSummary summary;
  DietLogPage({Key key, this.homeBloc, this.summary}) : super(key: key);

  @override
  _DietLogPageState createState() => _DietLogPageState();
}

class _DietLogPageState extends State<DietLogPage> {
  PerformanceLogBloc performanceLogBloc;
  int daySlot = 0;
  FloatingSearchBarController searchController;

  @override
  void initState() {
    searchController = FloatingSearchBarController();
    performanceLogBloc =
        PerformanceLogBloc(sl(), sl(), homeStoriesBloc: widget.homeBloc)
          ..add(LoadDietlogStory(widget.summary));
     sl<FirebaseAnalytics>()
        .logEvent(name: 'TrackAnalysisView', parameters: {"trackId": "1"});

    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(children: [
            BlocProvider(
              create: (context) => performanceLogBloc,
              child: BlocBuilder<PerformanceLogBloc, PerformanceLogState>(
                builder: (context, state) {
                  if (state is DietLogLoaded)
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 60,
                          ),
                          Padding(
                            padding: EdgeInsets.all(Gparam.widthPadding),
                            child: Row(
                              children: [
                                Gtheme.stext("Cal taken today  ",
                                    size: GFontSize.S, weight: GFontWeight.N),
                                Gtheme.stext(
                                    state.totalCalTakenToday.toString(),
                                    size: GFontSize.L,
                                    weight: GFontWeight.B2),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                daySlot = 0;
                                if (searchController.isClosed)
                                  searchController.open();
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Gparam.widthPadding,
                                  vertical: Gparam.widthPadding / 2),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Gtheme.stext("BreakFast"),
                                  Icon(Icons.add)
                                ],
                              ),
                            ),
                          ),
                          Divider(color: Colors.grey),
                          ...state.todayDiets
                              .where((element) => element.daySlot == 0)
                              .toList()
                              .asMap()
                              .entries
                              .map((e) => Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Gparam.widthPadding,
                                        vertical: 8),
                                    child: MealTile(meal: e.value),
                                  )),
                          InkWell(
                            onTap: () {
                              setState(() {
                                daySlot = 1;
                                if (searchController.isClosed)
                                  searchController.open();
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Gparam.widthPadding,
                                  vertical: Gparam.widthPadding / 2),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Gtheme.stext("Lunch"),
                                  Icon(Icons.add)
                                ],
                              ),
                            ),
                          ),
                          Divider(color: Colors.grey),
                          ...state.todayDiets
                              .where((element) => element.daySlot == 1)
                              .toList()
                              .asMap()
                              .entries
                              .map((e) => Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Gparam.widthPadding,
                                        vertical: 8),
                                    child: MealTile(meal: e.value),
                                  )),
                          InkWell(
                            onTap: () {
                              setState(() {
                                daySlot = 2;
                                if (searchController.isClosed)
                                  searchController.open();
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Gparam.widthPadding,
                                  vertical: Gparam.widthPadding / 2),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Gtheme.stext("Dinner"),
                                  Icon(Icons.add)
                                ],
                              ),
                            ),
                          ),
                          Divider(color: Colors.grey),
                          ...state.todayDiets
                              .where((element) => element.daySlot == 2)
                              .toList()
                              .asMap()
                              .entries
                              .map((e) => Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Gparam.widthPadding,
                                        vertical: 8),
                                    child: MealTile(meal: e.value),
                                  )),
                          DietListAnalysis(logs: [state.summary.diets])
                        ],
                      ),
                    );
                  else if (state is PerformanceLogError) {
                    return MessageDisplay(message: state.message);
                  } else if (state is PerformanceLogInitial) {
                    return Center(
                      child: LoadingWidget(),
                    );
                  } else
                    return Container(
                      height: 0,
                    );
                },
              ),
            ),
            RecipeSearchBar(
              onRecipeSelect: onRecipeSelect,
              searchController: searchController,
            )
          ]),
        ),
      ),
    );
  }

  onRecipeSelect(RecipeModel p1) {
    print("print activity ${p1.name}");
    int localDaySlot = daySlot;
    setState(() {
      daySlot = -1;
      if (searchController.isOpen) searchController.close();
    });
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            _buildPopupDialog(context, p1, localDaySlot));
  }

  Widget _buildPopupDialog(
      BuildContext context, RecipeModel recipe, int localDaySlot) {
    int calories = 0;
    if (recipe.nutrients_name.length > 0)
      calories = recipe.nutrients_value[0].toInt();
    DietModel meal = DietModel(
        recipeId: recipe.id,
        recipeImage: recipe.image_url,
        name: recipe.name,
        servingUnit: "Servings",
        daySlot: localDaySlot,
        servings: 1,
        calories: calories);

    return StatefulBuilder(builder: (context, setPopupState) {
      return new AlertDialog(
        insetPadding: EdgeInsets.all(24),
        contentPadding: EdgeInsets.all(20),
        title: Column(
          children: [
            Gtheme.stext('Diet Log'),
            Divider(
              color: Colors.grey,
            )
          ],
        ),
        content: Container(
          height: 300,
          width: double.maxFinite,
          child: Column(
            children: [
              MealTile(
                meal: meal,
              ),
              SizedBox(
                height: 30,
              ),
              MaterialButton(
                onPressed: () {
                  DietLog newLog = DietLog(
                      id: DateTime.now().microsecondsSinceEpoch,
                      dietId: meal.recipeId,
                      time: DateTime.now(),
                      servings: meal.servings.toDouble(),
                      calories: meal.calories.toDouble(),
                      daySlot: localDaySlot);

                  performanceLogBloc.add(AddDietLog(newLog, recipe));

                  Navigator.of(context).pop();
                },
                color: Colors.blueGrey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                child: Gtheme.stext("SAVE", color: GColors.W),
              )
            ],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            textColor: Theme.of(context).primaryColor,
            child: const Text('Close'),
          ),
        ],
      );
    });
  }
}
