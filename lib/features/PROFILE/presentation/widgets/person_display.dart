import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';

class PersonDisplay extends StatelessWidget {
  final String name;
  final String image_url;
  final VoidCallback onClick;

  const PersonDisplay({
    Key key,
    @required this.name,
    this.image_url,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.topLeft, children: [
      Align(
        alignment: Alignment.topLeft,
        child: Container(
          height: 40,
          margin: EdgeInsets.fromLTRB(25, 0, 15, 6),
          decoration: new BoxDecoration(
              color: (Theme.of(context).brightness == Brightness.dark)
                  ? Colors.grey.shade900
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Row(
            children: [
              SizedBox(
                width: 30,
              ),
              Gtheme.stext(name,
                  color: (Theme.of(context).brightness == Brightness.dark)
                      ? Gcolors.W
                      : Gcolors.B,
                  size: GFontSize.XXS),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
      Column(
        children: [
          Container(
            height: 34,
            width: 34,
            margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade300,
                      spreadRadius: 1.25,
                      blurRadius: 0)
                ]),
            child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10)),
                child: CachedNetworkImage(
                  imageUrl: image_url,
                  fit: BoxFit.cover,
                )),
          ),
        ],
      )
    ]);
  }
}
