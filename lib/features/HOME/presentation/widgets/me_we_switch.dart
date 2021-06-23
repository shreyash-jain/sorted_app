import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';

class MeWeButton extends StatelessWidget {
  final bool isMe;
  final Function(bool isMe) onChanged;
  const MeWeButton({Key key, this.isMe, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Transform.scale(
            scale: 2,
            child: Container(
              width: 60,
              child: Switch(
                value: isMe,
                onChanged: onChanged,
                activeColor: (Theme.of(context).brightness == Brightness.dark)
                    ? Colors.grey.shade700
                    : Colors.grey.shade300,
                activeTrackColor:
                    (Theme.of(context).brightness == Brightness.dark)
                        ? Colors.grey.shade900
                        : Colors.grey.shade100,
                activeThumbImage: AssetImage("assets/images/me.png"),
                inactiveThumbImage: AssetImage("assets/images/we.png"),
                inactiveThumbColor:
                    (Theme.of(context).brightness == Brightness.dark)
                        ? Colors.black
                        : Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
