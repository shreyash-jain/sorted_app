import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/widgets/image_placeholder_widget.dart';

class ReceiveMessage extends StatelessWidget {
  final String message;
  final String senderName;
  final String imageUrl;
  const ReceiveMessage({Key key, this.message, this.imageUrl, this.senderName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null && imageUrl != '')
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      placeholder: (context, url) => ImagePlaceholderWidget(),
                      errorWidget: (context, url, error) => Icon(
                        Icons.error,
                        color: Colors.grey,
                      ),
                      width: 35,
                      height: 35,
                    )),
              ),
            Flexible(
              child: Container(
                decoration: new BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.all(4),
                child: Gtheme.stext(message, size: GFontSize.S),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(
              left: (imageUrl != null && imageUrl != '') ? 65 : 16),
          child: Gtheme.stext(senderName,
              size: GFontSize.XXS, weight: GFontWeight.N),
        ),
      ],
    );
  }
}
