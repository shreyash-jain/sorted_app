import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/HOME/data/models/class_model.dart';

class ClassDescription extends StatelessWidget {
  final ClassModel classroom;
  const ClassDescription({Key key, this.classroom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Gparam.widthPadding / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: Gtheme.stext(
              classroom.description,
              weight: GFontWeight.L,
            ),
          ),
        ],
      ),
    );
  }
}
