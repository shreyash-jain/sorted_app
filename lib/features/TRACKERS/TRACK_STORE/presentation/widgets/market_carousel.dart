import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/market_banner.dart';
import '../../../../../core/global/constants/constants.dart';
import '../../../../../core/global/animations/shimmer.dart';

class MarketCarousel extends StatelessWidget {
  final List<MarketBanner> markets;
  const MarketCarousel({this.markets});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: markets.length,
      itemBuilder: (_, i) => InkWell(
        onTap: () {
          if (i == 0) {
            // Navigator.of(context).push(
            //   MaterialPageRoute(builder: (context) => LifestylesPage()),
            // );
          }
        },
        child: Container(
          width: Gparam.width * 0.9,
          padding: EdgeInsets.only(left: Gparam.widthPadding),
          margin: EdgeInsets.all(Gparam.widthPadding / 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).backgroundColor,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: CachedNetworkImageProvider(
                markets[i].image_url,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                markets[i].heading,
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Theme.of(context).highlightColor,
                    fontSize: Gparam.textSmaller,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                markets[i].sub_heading,
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Theme.of(context).highlightColor,
                    fontSize: Gparam.textVerySmall,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
