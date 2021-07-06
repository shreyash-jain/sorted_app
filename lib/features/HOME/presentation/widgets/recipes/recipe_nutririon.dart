import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/HOME/data/models/recipes/recipe_nutrition.dart';
import 'package:sorted/features/HOME/presentation/widgets/recipes/micro_widget.dart';

class RecipeNutritionWidget extends StatefulWidget {
  final List<RecipeNutrition> nutritions;
  RecipeNutritionWidget({Key key, this.nutritions}) : super(key: key);

  @override
  _RecipeNutritionWidgetState createState() => _RecipeNutritionWidgetState();
}

class _RecipeNutritionWidgetState extends State<RecipeNutritionWidget> {
  Map<String, double> nutritionMap = {};
  List<RecipeNutrition> others = [];
  @override
  void initState() {
    addNutritionsToMap();
    super.initState();
  }

  void addNutritionsToMap() {
    widget.nutritions.forEach((element) {
      if (element.units == "g")
        nutritionMap.addAll({element.nutrients: element.value});
      else
        others.add(element);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        (nutritionMap.isNotEmpty)
            ? PieChart(
                dataMap: nutritionMap,
                animationDuration: Duration(milliseconds: 800),
                chartLegendSpacing: 32,
                chartRadius: MediaQuery.of(context).size.width / 3.2,
                initialAngleInDegree: 0,
                chartType: ChartType.ring,
                ringStrokeWidth: 7,
                centerText: "gram",
                legendOptions: LegendOptions(
                  showLegendsInRow: false,
                  legendPosition: LegendPosition.right,
                  showLegends: true,
                  legendShape: BoxShape.circle,
                  legendTextStyle: TextStyle(
                    fontFamily: "Milliard",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                chartValuesOptions: ChartValuesOptions(
                  showChartValueBackground: false,
                  showChartValues: true,
                  showChartValuesInPercentage: false,
                  showChartValuesOutside: false,
                  decimalPlaces: 1,
                ),
              )
            : Container(height: 0),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 36,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: others.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) return SizedBox(width: Gparam.widthPadding);
              return MicroNutrientWidget(
                nutrient: others[index - 1],
              );
            },
          ),
        )
      ],
    );
  }
}
