
import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';

class SentMessage extends StatelessWidget {
  final String message;
  const SentMessage({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            decoration: new BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            margin: EdgeInsets.symmetric(
                horizontal: Gparam.widthPadding / 2, vertical: 10),
            child: Gtheme.stext(message, size: GFontSize.S),
          ),
        ),
      ],
    );
  }
}
