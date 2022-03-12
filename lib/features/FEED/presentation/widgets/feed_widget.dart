import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/widgets/image_placeholder_widget.dart';
import 'package:sorted/features/FEED/data/models/feed_model.dart';

class FeedWidget extends StatelessWidget {
  final PostModel post;

  const FeedWidget({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (post.senderUrl != null && post.senderUrl != "")
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: CachedNetworkImage(
                    imageUrl: post.senderUrl,
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                      child: ImagePlaceholderWidget(),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              SizedBox(
                width: 8,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gtheme.stext(post.senderName,
                        size: GFontSize.XS, weight: GFontWeight.B1),
                    SizedBox(
                      height: 4,
                    ),
                    Gtheme.stext("Sortit Pro team",
                        size: GFontSize.S, weight: GFontWeight.N),
                  ],
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Gtheme.stext(post.title,
                size: GFontSize.XS, weight: GFontWeight.N),
          ),
          if (post.feedUrl != null && post.feedUrl != "")
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: post.feedUrl,
                width: Gparam.width,
                height: Gparam.width,
                fit: BoxFit.fitWidth,
                placeholder: (context, url) => Center(
                  child: ImagePlaceholderWidget(),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 16,
              ),
              Icon(Icons.thumb_up_alt_outlined),
              SizedBox(
                width: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
