import 'package:flutter/material.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/domain/entities/track_comment.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../core/global/constants/constants.dart';

class SingleComment extends StatelessWidget {
  final TrackComment trackComment;
  const SingleComment({this.trackComment});
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 200,
      padding: EdgeInsets.only(
          left: Gparam.widthPadding, right: Gparam.widthPadding / 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5000),
                  child: CachedNetworkImage(
                    imageUrl: trackComment?.user_icon ?? "",
                    progressIndicatorBuilder: (_, __, p) =>
                        CircularProgressIndicator(),
                    errorWidget: (_, __, ___) => Icon(Icons.error),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Flexible(
                  child: Text(
                    trackComment?.user_name ?? 'username',
                    style:
                        Gtheme.textBold.copyWith(fontSize: Gparam.textSmaller),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5 + Gparam.topPadding / 4,
          ),
          Text(
            trackComment?.comment ?? "track comment",
            style: Gtheme.textNormal.copyWith(fontSize: Gparam.textSmaller),
          ),
          SizedBox(
            height: 5 + Gparam.topPadding,
          ),
        ],
      ),
    );
  }
}
