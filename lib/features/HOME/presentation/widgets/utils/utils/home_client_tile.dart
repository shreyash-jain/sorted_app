import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/HOME/data/models/client_model.dart';

class HomeClassroomClientTile extends StatelessWidget {
  final ClientModel client;
  final String time;
  const HomeClassroomClientTile({Key key, this.client, this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        padding: EdgeInsets.only(bottom: 0),
        width: Gparam.width - 1.05 * Gparam.widthPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                if (client.imageUrl != "")
                  Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white, width: 3)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: client.imageUrl,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      )),
                if (client.imageUrl != "") SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gtheme.stext(client.name, weight: GFontWeight.B),
                    SizedBox(height: 10),
                    Gtheme.stext(
                      "Joined on " + " 1st June",
                      weight: GFontWeight.B,
                      size: GFontSize.XXS,
                    ),
                  ],
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(5)),
                  child: Gtheme.stext(
                    time,
                    size: GFontSize.XS,
                    weight: GFontWeight.B,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
