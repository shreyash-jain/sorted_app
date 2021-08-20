import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';

class SearchFilter extends StatelessWidget {
  final String text;
  final int filterId;

  final bool value;
  final Function(bool, int) onClick;
  const SearchFilter(
      {Key key, this.text, this.onClick, this.filterId, this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("ruuunnnner");
        onClick(!value, filterId);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(.1),
            borderRadius: BorderRadius.circular(5)),
        child: Row(
          children: [
            Checkbox(
                value: value,
                activeColor: Colors.orange,
                onChanged: (v) {
                  print("ruuunnnn");
                  onClick(v, filterId);
                }),
            Gtheme.stext(
              text,
              size: GFontSize.XS,
              weight: GFontWeight.N,
            ),
            SizedBox(
              width: 8,
            ),
          ],
        ),
      ),
    );
  }
}
