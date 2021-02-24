import 'package:flutter/material.dart';
import '../../domain/entities/market_heading.dart';
import '../../../../../core/global/constants/constants.dart';
import '../../../../../core/global/animations/shimmer.dart';
import './market_banner_shimmer.dart';

class MarketHeadingsShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        MarketBannerShimmer(),
        SizedBox(
          height: 30,
        ),
        MarketBannerShimmer(),
        SizedBox(
          height: 30,
        ),
        MarketBannerShimmer(),
      ],
    );
  }
}
