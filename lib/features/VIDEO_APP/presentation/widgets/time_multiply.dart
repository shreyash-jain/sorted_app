import 'package:flutter/material.dart';

class TimeMultiply extends StatelessWidget {
  final String text;
  final Function onTap;
  final isActive;
  const TimeMultiply({
    Key key,
    @required this.text,
    @required this.onTap,
    @required this.isActive,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isActive ? Colors.amber : Colors.black,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white),
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
