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
          child: Gtheme.stext(notice, weight: GFontWeight.N),
        ),
        Container(
          height: 12,
        ),
        Row(
          children: [
            Spacer(),
            Container(
              child: Gtheme.stext(DateFormat('MMM dd, ').format(time),
                  weight: GFontWeight.N, size: GFontSize.XXXS),
            ),
            Container(
              child: Gtheme.stext(DateFormat('jm').format(time),
                  weight: GFontWeight.L, size: GFontSize.XXXS),
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
