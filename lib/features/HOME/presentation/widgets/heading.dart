import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';

class HomeHeading extends StatelessWidget {
  const HomeHeading({Key key, this.heading, this.subHeading}) : super(key: key);

  final String heading;
  final String subHeading;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(
            horizontal: Gparam.widthPadding, vertical: Gparam.heightPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gtheme.stext(heading,
                color: (Theme.of(context).brightness == Brightness.dark)
                    ? GColors.W
                    : GColors.B,
                size: GFontSize.M,
                weight: GFontWeight.B),
            if (subHeading != null)
              SizedBox(
                height: 4,
              ),
            if (subHeading != null)
              Gtheme.stext(subHeading,
                  color: (Theme.of(context).brightness == Brightness.dark)
                      ? GColors.W
                      : GColors.B,
                  size: GFontSize.XXS,
                  weight: GFontWeight.N),
          ],
        ));
  }
}
