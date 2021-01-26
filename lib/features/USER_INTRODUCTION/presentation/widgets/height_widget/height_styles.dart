
import 'package:flutter/material.dart';
import 'package:sorted/core/global/utility/utils.dart';



double marginBottomAdapted(BuildContext context) =>
    screenAwareSize(marginBottom, context);

double marginTopAdapted(BuildContext context) =>
    screenAwareSize(marginTop, context);

double circleSizeAdapted(BuildContext context) =>
    screenAwareSize(circleSize, context);

const TextStyle labelsTextStyle = const TextStyle(
  color: labelsGrey,
  fontSize: labelsFontSize,
);

const double circleSize = 32.0;
const double marginBottom = circleSize / 2;
const double marginTop = 26.0;
const double selectedLabelFontSize = 18.0;
const double labelsFontSize = 13.0;
const Color labelsGrey = const Color.fromRGBO(255, 255, 255, 1.0);