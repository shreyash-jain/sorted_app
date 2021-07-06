import 'package:flutter/material.dart';
import '../../domain/entities/market_heading.dart';
import '../../../../../core/global/constants/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'track_item.dart';

class BuildMarketHeading extends StatelessWidget {
  final MarketHeading marketHeading;

  const BuildMarketHeading({this.marketHeading});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: 0, left: Gparam.widthPadding / 1.2, bottom: 15),
          child: Row(
            children: [
              Container(
                height: 25,
                width: 25,
                child: CachedNetworkImage(
                  imageUrl: marketHeading.icon_url,
                  errorWidget: (_, __, ___) => Icon(Icons.error),
                ),
              ),
              SizedBox(
                width: Gparam.widthPadding / 3,
              ),
              Text(
                marketHeading.name,
                style: TextStyle(
                    fontFamily: 'Milliard',
                    color: Theme.of(context).highlightColor,
                    fontSize: Gparam.textSmall,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        Container(
          height: 170,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: marketHeading.tracksDetail.length + 1,
            itemBuilder: (_, i) => (i == 0)
                ? SizedBox(
                    width: Gparam.widthPadding / 2,
                  )
                : TrackItem(
                    track: marketHeading.tracksDetail[i - 1],
                    marketHeading: marketHeading),
          ),
        ),
      ],
    );
  }
}
