
import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';

class OrangeActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function onClick;
  const OrangeActionButton({Key key, this.text, this.onClick, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onClick();
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(5)),
        child: Row(
          children: [
            if (icon != null)
              SizedBox(
                width: 4,
              ),
            if (icon != null)
              Icon(
                icon,
                size: 20,
                color: Colors.black45,
              ),
            if (icon != null)
              SizedBox(
                width: 12,
              ),
            Gtheme.stext(text, size: GFontSize.XS, weight: GFontWeight.N),
            SizedBox(
              width: 12,
            ),
          ],
        ),
      ),
    );
  }
}
