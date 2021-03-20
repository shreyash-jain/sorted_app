import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/domain/entities/track.dart';
import 'package:meta/meta.dart';

class AboutTrackPage extends StatelessWidget {
  final Track track;
  const AboutTrackPage({@required this.track});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.only(
            left: Gparam.widthPadding / 2,
          ),
          child: ListView(
            children: [
              SizedBox(
                height: Gparam.topPadding / 4,
              ),
              Container(
                height: 50,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        child: Icon(Icons.arrow_back),
                      ),
                    ),
                    SizedBox(
                      width: Gparam.widthPadding / 2,
                    ),
                    CachedNetworkImage(
                      imageUrl: track?.icon ?? '',
                      progressIndicatorBuilder: (_, __, ___) =>
                          CircularProgressIndicator(),
                      errorWidget: (_, __, ___) => Icon(Icons.error),
                    ),
                    SizedBox(
                      width: Gparam.widthPadding / 4,
                    ),
                    Text(
                      track?.name ?? "Track name",
                      overflow: TextOverflow.ellipsis,
                      style:
                          Gtheme.textBold.copyWith(fontSize: Gparam.textSmall),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Gparam.topPadding,
              ),
              Text(
                'About this track',
                style: Gtheme.textBold.copyWith(fontSize: Gparam.textSmall),
              ),
              SizedBox(
                height: Gparam.topPadding,
              ),
              // Description
              Text(
                "Description",
                style: Gtheme.textBold.copyWith(fontSize: Gparam.textSmaller),
              ),
              SizedBox(
                height: Gparam.topPadding / 4,
              ),
              Text(
                track?.m_description ?? "description of the track",
                style: Gtheme.textNormal.copyWith(fontSize: Gparam.textSmaller),
              ),
              SizedBox(
                height: Gparam.topPadding,
              ),
              // Facts
              Text(
                "Facts",
                style: Gtheme.textBold.copyWith(fontSize: Gparam.textSmaller),
              ),
              SizedBox(
                height: Gparam.topPadding / 4,
              ),
              Text(
                track?.m_facts ?? "Facts about the track",
                style: Gtheme.textNormal.copyWith(fontSize: Gparam.textSmaller),
              ),
              SizedBox(
                height: Gparam.topPadding,
              ),
              // Rewards
              Text(
                "Rewards",
                style: Gtheme.textBold.copyWith(fontSize: Gparam.textSmaller),
              ),
              SizedBox(
                height: Gparam.topPadding / 4,
              ),
              Text(
                track?.m_reward ?? "rewards of the track",
                style: Gtheme.textNormal.copyWith(fontSize: Gparam.textSmaller),
              ),
              SizedBox(
                height: Gparam.topPadding,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
