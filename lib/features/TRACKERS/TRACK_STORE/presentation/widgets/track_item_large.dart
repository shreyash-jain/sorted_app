import 'package:flutter/material.dart';
import '../../domain/entities/track.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sorted/core/global/utility/utils.dart';
import 'package:sorted/core/global/constants/constants.dart';
import './../pages/single_track_page.dart';

class TrackItemLarge extends StatelessWidget {
  final Track track;
  const TrackItemLarge({this.track});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Gparam.widthPadding * 0.8,
        vertical: Gparam.heightPadding * 0.4,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Gparam.widthPadding / 2,
        vertical: Gparam.heightPadding / 2,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).highlightColor,
          width: 0.7,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: SizedBox(
          height: 50,
          width: 50,
          child: CachedNetworkImage(
            imageUrl: track?.icon ?? "",
            errorWidget: (_, __, ___) => Icon(Icons.error),
          ),
        ),
        title: Text(
          track?.name ?? '',
          style: TextStyle(
            fontFamily: 'Milliard',
            color: Theme.of(context).highlightColor,
            fontSize: Gparam.textSmaller,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(fromLevelToDifficulty(track.m_level)),
            // Text(fromLevelToDifficulty(track.m_level)),
            Text(
              fromLevelToDifficulty(track.m_level),
              style: TextStyle(
                fontFamily: 'Milliard',
                color: Theme.of(context).highlightColor,
                fontSize: Gparam.textVerySmall,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              "${track.m_num_subs} tracking this",
              style: TextStyle(
                fontFamily: 'Milliard',
                color: Theme.of(context).highlightColor,
                fontSize: Gparam.textVerySmall,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => SingleTrackPage(
                track: track,
              ),
            ),
          );
        },
      ),
    );
  }
}
