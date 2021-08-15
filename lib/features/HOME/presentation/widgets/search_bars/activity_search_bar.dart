import 'dart:async';

import 'package:auto_route/auto_route.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/features/HOME/presentation/activity_search_bloc/activity_search_bloc.dart';
import 'package:sorted/features/HOME/presentation/widgets/search_bars/search_filter.dart';
import 'package:sorted/features/PLANNER/data/models/activity.dart';

class ActivitySearchBar extends StatefulWidget {
  Function(ActivityModel) onActivitySelect;
  ActivitySearchBar({Key key, this.onActivitySelect}) : super(key: key);

  @override
  _ActivitySearchBarState createState() => _ActivitySearchBarState();
}

class _ActivitySearchBarState extends State<ActivitySearchBar> {
  FloatingSearchBarController controller;
  Timer searchOnStoppedTyping;
  static const historyLength = 5;
  ActivitySearchBloc activitySearchBloc;

  String selectedTerm = "";
  List<int> filterFields = [];

  bool isLoading = false;
  bool showFilterWidget = false;

  @override
  void initState() {
    super.initState();
    activitySearchBloc = new ActivitySearchBloc(sl());
    controller = FloatingSearchBarController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return FloatingSearchBar(
      hint: 'Search exercises, poses, activities...',
      margins: EdgeInsets.all(Gparam.widthPadding / 2),
      controller: controller,
      progress: isLoading,
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      automaticallyImplyBackButton: false,
      height: 50,

      title: Row(
        children: [
          Icon(Icons.search),
          SizedBox(
            width: 12,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Gtheme.stext("Activity Library",
                  size: GFontSize.XXS,
                  color: GColors.B1,
                  weight: GFontWeight.B2),
              SizedBox(
                height: 4,
              ),
              Gtheme.stext("Search exercises, poses, activities...",
                  size: GFontSize.XXXS,
                  color: GColors.B1,
                  weight: GFontWeight.N),
            ],
          ),
        ],
      ),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        _onChangeHandler(query);
      },
      onSubmitted: (query) {
        setState(() {
          selectedTerm = query;
        });
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return BlocProvider(
          create: (context) => activitySearchBloc,
          child: BlocListener<ActivitySearchBloc, ActivitySearchState>(
            listener: (context, state) {
              if (state is ActivitySearchListLoaded) {
                setState(() {
                  filterFields = state.filterFields;
                  isLoading = state.isLoading;
                });
              }
            },
            child: BlocBuilder<ActivitySearchBloc, ActivitySearchState>(
              builder: (context, state) {
                if (state is ActivitySearchInitial) {
                  return ActivityFilterWidget(
                    filterFields: filterFields,
                    onClickFilter: onClickFilter,
                  );
                } else if (state is ActivitySearchListLoaded)
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Material(
                      color: Colors.white,
                      elevation: 4.0,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 44,
                              child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          onClickShowFilters();
                                        },
                                        child: Container(
                                            margin: EdgeInsets.all(12),
                                            child: Row(
                                              children: [
                                                Gtheme.stext("Filters"),
                                                SizedBox(
                                                  width: 2,
                                                ),
                                                Icon(Icons.arrow_drop_down)
                                              ],
                                            ))),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    ...state.filterFields.map((item) {
                                      return Row(
                                        children: [
                                          Icon(
                                            MdiIcons.checkboxMarked,
                                            color: Colors.orange.shade600,
                                            size: 16,
                                          ),
                                          Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 12, horizontal: 6),
                                              child: Gtheme.stext(
                                                  getFilterName(item))),
                                        ],
                                      );
                                    }).toList(),
                                  ]),
                            ),
                            if (showFilterWidget)
                              ActivityFilterWidget(
                                filterFields: state.filterFields,
                                onClickFilter: onClickFilter,
                              ),
                            Divider(
                              color: Colors.black38,
                            ),
                            ...state.activities.map((item) {
                              return InkWell(
                                onTap: () {
                                  if (widget.onActivitySelect != null) {
                                    widget.onActivitySelect(item);
                                    controller.close();
                                  }
                                },
                                child: Container(
                                    padding: EdgeInsets.all(8),
                                    margin: EdgeInsets.all(8),
                                    child: Gtheme.stext(item.exercise_name)),
                              );
                            }).toList(),
                          ]),
                    ),
                  );
                else if (state is ActivitySearchError) {
                  return Center(child: Text(state.message));
                }
              },
            ),
          ),
        );
      },
    );
  }

  _onChangeHandler(value) {
    if (value != null && value != "") {
      const duration = Duration(
          milliseconds:
              300); // set the duration that you want call search() after that.
      if (searchOnStoppedTyping != null) {
        setState(() => searchOnStoppedTyping.cancel()); // clear timer
      }
      setState(() => searchOnStoppedTyping =
          new Timer(duration, () => sendForCheck(value)));
    }
  }

  sendForCheck(value) {
    print('hello world from search . the value is $value');
    activitySearchBloc
        .add(SearchByQuery(filterFields, value, activitySearchBloc.state));
  }

  onClickFilter(bool p1, int p2) {
    print(onClickFilter);
    setState(() {
      if (p1)
        filterFields.add(p2);
      else
        filterFields.removeWhere((element) => element == p2);
    });
  }

  String getFilterName(int id) {
    switch (id) {
      case 1:
        return "Breakfast";
        break;
      case 2:
        return "Lunch";
        break;
      case 3:
        return "Dinner";
        break;
      case 4:
        return "Lose weight";
        break;
      case 5:
        return "Build Muscle";
        break;
      case 6:
        return "Stay Fit";
        break;
      case 7:
        return "Vegetarian";
        break;
      case 8:
        return "Vegan";
        break;
      default:
        return "Sattvik";
    }
  }

  onClickShowFilters() {
    setState(() {
      showFilterWidget = !showFilterWidget;
    });
  }
}

class ActivityFilterWidget extends StatelessWidget {
  const ActivityFilterWidget({
    Key key,
    @required this.filterFields,
    this.onClickFilter,
  }) : super(key: key);

  final List<int> filterFields;
  final Function(bool, int) onClickFilter;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Material(
        color: Colors.white,
        elevation: 4.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                color: Colors.white,
                child: Column(children: [
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: Gparam.widthPadding / 2),
                        child: Gtheme.stext("Search Filters",
                            weight: GFontWeight.B1),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: Gparam.widthPadding),
                        child: Gtheme.stext("By Level",
                            weight: GFontWeight.B1, size: GFontSize.XXS),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Container(
                    height: 34,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        SearchFilter(
                          text: "Beginner",
                          onClick: onClickFilter,
                          value: filterFields.contains(1),
                          filterId: 1,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SearchFilter(
                          text: "Intermediate",
                          onClick: onClickFilter,
                          value: filterFields.contains(2),
                          filterId: 2,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SearchFilter(
                          text: "Advanced",
                          onClick: onClickFilter,
                          value: filterFields.contains(3),
                          filterId: 3,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: Gparam.widthPadding),
                        child: Gtheme.stext("By Fitness Goal",
                            weight: GFontWeight.B1, size: GFontSize.XXS),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Container(
                    height: 34,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        SearchFilter(
                          text: "Lose weight",
                          onClick: onClickFilter,
                          value: filterFields.contains(4),
                          filterId: 4,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SearchFilter(
                          text: "Build Muscle",
                          onClick: onClickFilter,
                          value: filterFields.contains(5),
                          filterId: 5,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SearchFilter(
                            text: "Stay Fit",
                            value: filterFields.contains(6),
                            onClick: onClickFilter,
                            filterId: 6),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: Gparam.widthPadding),
                        child: Gtheme.stext("By Muscles",
                            weight: GFontWeight.B1, size: GFontSize.XXS),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Container(
                    height: 34,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        SearchFilter(
                          text: "Upper Body",
                          onClick: onClickFilter,
                          value: filterFields.contains(7),
                          filterId: 7,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SearchFilter(
                          text: "Lower Body",
                          onClick: onClickFilter,
                          value: filterFields.contains(8),
                          filterId: 8,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SearchFilter(
                          text: "Legs",
                          onClick: onClickFilter,
                          value: filterFields.contains(8),
                          filterId: 8,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SearchFilter(
                            text: "Abs",
                            value: filterFields.contains(9),
                            onClick: onClickFilter,
                            filterId: 9),
                        SizedBox(
                          width: 10,
                        ),
                        SearchFilter(
                            text: "Glutes",
                            value: filterFields.contains(9),
                            onClick: onClickFilter,
                            filterId: 10),
                        SizedBox(
                          width: 10,
                        ),
                        SearchFilter(
                            text: "Chest",
                            value: filterFields.contains(9),
                            onClick: onClickFilter,
                            filterId: 11),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ])),
            SizedBox(
              height: 26,
            ),
          ],
        ),
      ),
    );
  }
}
