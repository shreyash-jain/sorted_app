import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';
import '../../domain/entities/track_property.dart';

class PropertyItem extends StatelessWidget {
  TrackProperty trackProperty;
  PropertyItem({@required this.trackProperty});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
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
                      imageUrl: trackProperty?.property_icon_url ?? "",
                      errorWidget: (_, __, ___) => Icon(Icons.error),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    trackProperty.property_name,
                    style: Gtheme.textNormal,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => new Dialog(
                  backgroundColor: Colors.transparent,
                  child: Container(
                    height: Gparam.height / 4,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).highlightColor,
                      ),
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Description",
                          style: Gtheme.textBold,
                        ),
                        SizedBox(
                          height: Gparam.topPadding,
                        ),
                        Text(
                          trackProperty?.property_description ?? "",
                          style: Gtheme.textNormal,
                        ),
                        SizedBox(
                          height: Gparam.topPadding,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            child: Icon(
              Icons.info,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }
}
