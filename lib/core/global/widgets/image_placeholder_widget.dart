import 'package:flutter/material.dart';
import 'package:sorted/core/global/animations/shimmer.dart';

class ImagePlaceholderWidget extends StatelessWidget {
  const ImagePlaceholderWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Shimmer(
      period: Duration(milliseconds: 1600),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.grey[200],
          Colors.grey[200],
          Colors.grey[350],
          Colors.grey[200],
          Colors.grey[200]
        ],
        stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
      ),
      child: Container(
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.all(Radius.circular(10.0)),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 1),
                color: Colors.black.withAlpha(80),
                blurRadius: 4)
          ],
          gradient: new LinearGradient(
              colors: [
                Colors.white,
                Colors.white,
              ],
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              stops: [1.0, 0.0],
              tileMode: TileMode.clamp),
        ),
      ),
    ));
  }
}