import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/widgets/image_placeholder_widget.dart';
import 'package:sorted/core/routes/router.gr.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_model.dart';
import 'package:auto_route/auto_route.dart';

class ProfileTrackView extends StatelessWidget {
  final TrackModel track;
  final String text1;
  final String text2;

  const ProfileTrackView({Key key, this.track, this.text1, this.text2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Gparam.widthPadding / 2),
      margin: EdgeInsets.only(left: 8, right: 8, top: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: track.icon,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: ImagePlaceholderWidget(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gtheme.stext(track.name,
                        size: GFontSize.XS, weight: GFontWeight.B1),
                    SizedBox(
                      height: 4,
                    ),
                    Gtheme.stext(text1 ?? "User",
                        size: GFontSize.S, weight: GFontWeight.L),
                  ],
                ),
              ),
              Spacer(),
              InkWell(
                  onTap: () {
                    context.router.push(AboutTrackRoute(track: track));
                  },
                  child: Icon(Icons.arrow_forward_outlined))
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            child:
                Gtheme.stext(text2, size: GFontSize.XS, weight: GFontWeight.N),
          ),
        ],
      ),
    );
  }
}
