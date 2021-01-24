import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/utility/utils.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/widgets/card_title.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/widgets/weight_widget.dart/weight_slider.dart';

class WeightCard extends StatelessWidget {
  final int weight;
  final ValueChanged<int> onChanged;
  final ValueChanged<void> onGoBack;

  const WeightCard({Key key, this.weight = 70, this.onChanged, this.onGoBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(
        left: screenAwareSize(12.0, context),
        right: screenAwareSize(12.0, context),
        top: screenAwareSize(0.0, context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
              onTap: () {
                onGoBack(null);
              },
              child: CardTitle("Done", subtitle: "")),
          CardTitle("Weight", subtitle: "(kg)"),
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenAwareSize(16.0, context)),
                child: _drawSlider(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawSlider() {
    return WeightBackground(
      weight: weight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.isTight
              ? Container()
              : WeightSlider(
                  minValue: 30,
                  maxValue: 150,
                  value: weight,
                  onChanged: (val) => onChanged(val),
                  width: constraints.maxWidth,
                );
        },
      ),
    );
  }
}

class WeightBackground extends StatelessWidget {
  final Widget child;
  final int weight;

  const WeightBackground({Key key, this.child, this.weight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: screenAwareSize(100.0, context),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius:
                new BorderRadius.circular(screenAwareSize(50.0, context)),
          ),
          child: child,
        ),
        SvgPicture.asset(
          "assets/images/weight_arrow.svg",
          height: screenAwareSize(10.0, context),
          width: screenAwareSize(18.0, context),
        ),
        Stack(
          children: [
            SvgPicture.asset(
              "assets/images/scale.svg",
              height: screenAwareSize(110.0, context),
              width: screenAwareSize(88.0, context),
            ),
            Positioned(
                top: screenAwareSize(16.0, context),
                width:screenAwareSize(110.0, context), 
                child: Text(
                  weight.toString(),
                  textAlign: TextAlign.center,
                ))
          ],
        ),
      ],
    );
  }
}
