import 'package:flutter/material.dart';

class IndicatorOval extends StatelessWidget {
  const IndicatorOval({
    Key key,
    @required this.isActive,
  }) : super(key: key);

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 16.0 : 10.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.black12,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
