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
          padding: const EdgeInsets.only(top: 20, left: 20, bottom: 5),
          child: Row(
            children: [
              Icon(Icons.home),
              SizedBox(
                width: Gparam.widthPadding,
              ),
              Text(
                marketHeading.name,
                style: TextStyle(
                    fontSize: Gparam.textSmall, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Container(
          height: Gparam.height * 0.3,
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
