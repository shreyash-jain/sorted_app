import 'package:flutter/material.dart';
import '../../domain/entities/track.dart';
import '../../../../../core/global/constants/constants.dart';

class TrackItem extends StatelessWidget {
  final Track track;

  const TrackItem({this.track});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.of(context).push(())
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.all(Gparam.widthPadding / 2),
            // padding: EdgeInsets.all(8),
            width: Gparam.width * 0.4,
            height: Gparam.height * 0.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).backgroundColor,
              image: DecorationImage(
                image: NetworkImage(track.m_banner),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Text(
            track.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
