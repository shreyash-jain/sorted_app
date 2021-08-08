import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/CONNECT/presentation/widgets/classroom_preview.dart';

class ClassroomImageResource extends StatelessWidget {
  final String imageUrl;
  final String caption;
  final DateTime date;
  final String title;
  const ClassroomImageResource(
      {Key key, this.imageUrl, this.caption, this.date, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  child: Gtheme.stext(title,
                      weight: GFontWeight.B2, size: GFontSize.S),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  child: Gtheme.stext(DateFormat('MMM dd').format(date),
                      weight: GFontWeight.N, size: GFontSize.XXS),
                ),
                Spacer(),
                Icon(Icons.share)
              ],
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    placeholder: (context, url) => ImagePlaceholderWidget(),
                    errorWidget: (context, url, error) => Icon(
                          Icons.error,
                          color: Colors.grey,
                        ),
                    width: Gparam.width * .9,
                    height: Gparam.width * .75,
                    fit: BoxFit.cover),
              ),
            ),
            Container(
              height: 12,
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: Gtheme.stext(caption),
            ),
          ],
        ));
  }
}
