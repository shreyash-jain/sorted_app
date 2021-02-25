import 'package:flutter/material.dart';
import '../../domain/entities/market_heading.dart';
import '../../../../../core/global/constants/constants.dart';

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
          padding:
              EdgeInsets.only(top: 0, left: Gparam.widthPadding / 2, bottom: 5),
          child: Row(
            children: [
              Text(
                marketHeading.name,
                style: TextStyle(
                    fontFamily: 'Montserrat',
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
            itemCount: marketHeading.tracksDetail.length,
            itemBuilder: (_, i) => TrackItem(
              track: marketHeading.tracksDetail[i],
            ),
          ),
        ),
      ],
    );
  }
}
