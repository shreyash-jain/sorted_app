import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_property_model.dart';

class FeatureItem extends StatelessWidget {
  final String text;
  final String icon_url;
  FeatureItem({
    @required this.text,
    @required this.icon_url,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      margin: EdgeInsets.only(top: 10, right: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).highlightColor,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: 85,
                height: 85,
                padding: EdgeInsets.all(10),
                child: CachedNetworkImage(
                  imageUrl: icon_url ?? "",
                  errorWidget: (_, __, ___) => Icon(Icons.error),
                ),
              ),
            ),
            Expanded(
              child: Text(
                text ?? 'Text',
                style: Gtheme.textNormal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
