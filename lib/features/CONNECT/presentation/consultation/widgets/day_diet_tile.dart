import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/HOME/presentation/widgets/performance_log/widgets/diet_tile.dart';
import 'package:sorted/features/PLANNER/data/models/day_diets.dart';

class DayDietWidget extends StatelessWidget {
  final DayDiet dayDiet;
  const DayDietWidget({Key key, this.dayDiet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      iconColor: Theme.of(context).primaryColor,
      initiallyExpanded: true,
      tilePadding: EdgeInsets.only(right: Gparam.widthPadding),
      childrenPadding: EdgeInsets.all(0),
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: Gparam.widthPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Gtheme.stext(dayDiet.dayName,
                    size: GFontSize.XS, weight: GFontWeight.N),
              ],
            ),
          ],
        ),
      ),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Gparam.widthPadding),
                child: Gtheme.stext("Breakfast",
                    size: GFontSize.XXS, weight: GFontWeight.B1),
              ),
              ...dayDiet.dayBreakfastDiets
                  .asMap()
                  .entries
                  .map(
                    (e) => Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Gparam.widthPadding,
                          vertical: Gparam.widthPadding / 2),
                      child: MealTile(
                        meal: e.value,
                      ),
                    ),
                  )
                  .toList(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Gparam.widthPadding),
                child: Gtheme.stext("Lunch",
                    size: GFontSize.XXS, weight: GFontWeight.B1),
              ),
              ...dayDiet.dayLunchDiets
                  .asMap()
                  .entries
                  .map(
                    (e) => Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Gparam.widthPadding,
                          vertical: Gparam.widthPadding / 2),
                      child: MealTile(
                        meal: e.value,
                      ),
                    ),
                  )
                  .toList(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Gparam.widthPadding),
                child: Gtheme.stext("Dinner",
                    size: GFontSize.XXS, weight: GFontWeight.B1),
              ),
              ...dayDiet.dayDinnerDiets
                  .asMap()
                  .entries
                  .map(
                    (e) => Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Gparam.widthPadding,
                          vertical: Gparam.widthPadding / 2),
                      child: MealTile(
                        meal: e.value,
                      ),
                    ),
                  )
                  .toList(),
            ],
          ),
        ),
      ],
    );
  }
}
