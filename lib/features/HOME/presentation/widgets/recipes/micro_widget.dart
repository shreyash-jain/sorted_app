import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/HOME/data/models/recipes/recipe_nutrition.dart';

class MicroNutrientWidget extends StatelessWidget {
  final RecipeNutrition nutrient;
  const MicroNutrientWidget({Key key, this.nutrient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 12,
            width: 12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: getColorofNutrient(nutrient.nutrients),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Gtheme.stext(nutrient.nutrients, weight: GFontWeight.B2),
          SizedBox(
            width: 8,
          ),
          Gtheme.stext(nutrient.value.toStringAsPrecision(4)),
          SizedBox(
            width: 4,
          ),
          Gtheme.stext(nutrient.units),
          SizedBox(
            width: 8,
          ),
        ],
      ),
    );
  }

  Color getColorofNutrient(String unit) {
    switch (unit) {
      case "Energy":
        return Colors.deepPurple;

        break;
      case "Cholesterol":
        return Colors.deepOrangeAccent;

        break;
      case "Sodium":
        return Colors.indigo;

        break;
      case "Potassium":
        return Colors.cyanAccent;

        break;
      case "Zinc":
        return Colors.blueGrey;

        break;
      case "Vitamin A":
        return Colors.grey.shade400;

        break;
      case "Vitamin B1":
        return Colors.limeAccent;

        break;
      case "Vitamin B2":
        return Colors.brown;

        break;
      case "Vitamin B3":
        return Colors.amber;

        break;
      case "Vitamin C":
        return Colors.orange;

        break;
      case "Folic Acid":
        return Colors.green;

        break;
      case "Calcium":
        return Colors.yellow.shade300;

        break;
      case "Iron":
        return Colors.brown.shade600;

        break;
      default:
        return Colors.blue.shade400;
    }
  }
}
