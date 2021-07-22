import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/widgets/image_placeholder_widget.dart';

class ImagePost extends StatelessWidget {
  final String imageUrl;
  final String caption;
  final String senderImageUrl;
  final String senderName;
  final String userDiscription;

  const ImagePost(
      {Key key,
      this.imageUrl,
      this.caption,
      this.senderImageUrl,
      this.senderName,
      this.userDiscription})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: senderImageUrl,
                  width: 40,
                  height: 40,
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
                    Gtheme.stext(senderName,
                        size: GFontSize.XS, weight: GFontWeight.B1),
                    SizedBox(
                      height: 4,
                    ),
                    Gtheme.stext(userDiscription ?? "User",
                        size: GFontSize.XXS, weight: GFontWeight.L),
                  ],
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Gtheme.stext(caption,
                size: GFontSize.XS, weight: GFontWeight.N),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: Gparam.width,
              height: Gparam.width,
              fit: BoxFit.cover,
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
