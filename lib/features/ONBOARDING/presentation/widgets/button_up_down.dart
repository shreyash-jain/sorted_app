import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final bool direction;
  final Function() onTapAction;
  const Button({
    @required this.direction,
    @required this.onTapAction,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        print("pressed");
        onTapAction();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            direction ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
            color:  direction ?Colors.white:Colors.white60,
            size: 50.0,
          ),
        ],
      ),
    );
  }
}
