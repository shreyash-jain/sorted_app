import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sorted/core/global/constants/constants.dart';

class ClassNoticeTile extends StatelessWidget {
  final String notice;
  final String subText;
  final DateTime time;
  const ClassNoticeTile({Key key, this.notice, this.subText, this.time})
      : super(key: key);

  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.topLeft,
          child: Gtheme.stext(notice, weight: GFontWeight.L),
        ),
        Container(
          height: 12,
        ),
        Row(
          children: [
            OutlinedButton(
              onPressed: () {},
              child: Gtheme.stext(subText,
                  weight: GFontWeight.B1, size: GFontSize.XXS),
            ),
            Spacer(),
            Container(
              child: Gtheme.stext(DateFormat('MMM dd, ').format(time),
                  weight: GFontWeight.L, size: GFontSize.XXXS),
            ),
            Container(
              child: Gtheme.stext(DateFormat(' HH:mm').format(time),
                  weight: GFontWeight.N, size: GFontSize.XXXS),
            ),
          ],
        ),
        Divider(
          color: Colors.grey.shade300,
        )
      ],
    );
  }
}
