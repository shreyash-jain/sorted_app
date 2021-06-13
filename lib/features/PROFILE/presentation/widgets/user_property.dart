import 'package:flutter/material.dart';

class UserPropertyWidget extends StatelessWidget {
  final String prop_name;
  final String prop_value;
  const UserPropertyWidget({
    Key key,
    this.prop_name,
    this.prop_value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              prop_name,
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).highlightColor),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: Text(
            prop_value,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14.0,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
