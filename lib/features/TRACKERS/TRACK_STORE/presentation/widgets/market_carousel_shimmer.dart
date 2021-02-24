import 'package:flutter/material.dart';
import '../../../../../core/global/constants/constants.dart';
import '../../../../../core/global/animations/shimmer.dart';

class MarketCarouselShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 3,
      itemBuilder: (_, i) => Shimmer(
        period: Duration(milliseconds: 1600),
        child: Container(
          width: Gparam.width * 0.9,
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.blueAccent,
          ),
        ),
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
      ),
    );
  }
}
