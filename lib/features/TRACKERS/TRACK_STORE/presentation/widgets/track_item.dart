import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/presentation/pages/single_track_page.dart';
import '../../domain/entities/track.dart';
import '../../../../../core/global/constants/constants.dart';

class TrackItem extends StatelessWidget {
  final Track track;

  const TrackItem({this.track});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => SingleTrackPage(
              track: track,
            ),
          ),
        );
      },
      child: Container(
        width: 100,
        height: 170,
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,

              // padding: EdgeInsets.all(8),

              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: CachedNetworkImageProvider(
                    track.icon,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                track.name,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Theme.of(context).highlightColor,
                    fontSize: Gparam.textExtraSmall,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
