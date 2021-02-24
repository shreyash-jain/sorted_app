import 'package:flutter/material.dart';
import '../../../../../core/global/animations/shimmer.dart';
import '../../../../../core/global/constants/constants.dart';

class MarketBannerShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Gparam.height * 0.25,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 2,
        itemBuilder: (_, i) => Shimmer(
          period: Duration(milliseconds: 1600),
          child: Container(
            width: Gparam.width * 0.5,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
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
      ),
    );
  }
}
