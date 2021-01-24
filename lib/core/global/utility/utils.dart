import 'package:flutter/material.dart';

const double baseHeight = 650.0;
const Color mainBlue = const Color.fromRGBO(77, 123, 243, 1.0);

double screenAwareSize(double size, BuildContext context) {
  double drawingHeight =
      MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

  return size * drawingHeight / baseHeight;
}
