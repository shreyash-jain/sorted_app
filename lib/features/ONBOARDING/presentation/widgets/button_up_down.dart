import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final bool direction;
  final bool isActive;
  final Function() onTapAction;
  const Button({
    @required this.direction,
    @required this.onTapAction,
    Key key,
    this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        if (isActive != null && isActive == false) return null;
        print("pressed");
        onTapAction();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            ! direction ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
            color: direction ? Colors.black : Colors.black54,
            size: 30.0,
          ),
        ],
      ),
    );
  }
}
