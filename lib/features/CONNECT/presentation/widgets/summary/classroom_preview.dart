import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sorted/core/global/animations/shimmer.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/widgets/image_placeholder_widget.dart';

class ClassroomPreview extends StatelessWidget {
  final String coverImageUrl;
  final List<String> topics;

  const ClassroomPreview({Key key, this.coverImageUrl, this.topics})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 200,
          padding: EdgeInsets.all(8),
          child: Stack(
            children: [
              if (coverImageUrl != null && coverImageUrl != "")
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    width: Gparam.width,
                    height: 170,
                    fit: BoxFit.cover,
                    imageUrl: coverImageUrl,
                    placeholder: (context, url) => Center(
                      child: ImagePlaceholderWidget(),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              if (coverImageUrl == null || coverImageUrl == "")
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    width: Gparam.width,
                    height: 170,
                    fit: BoxFit.cover,
                    imageUrl:
                        "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/classrooms%2Fplaceholders%2F19347.jpg?alt=media&token=06651a7f-2dd5-4eef-96f5-5a34210df824",
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    placeholder: (context, url) => Center(
                      child: ImagePlaceholderWidget(),
                    ),
                  ),
                ),
              Positioned(
                bottom: 0,
                left: 10,
                child: Container(
                  height: 25,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: topics.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return SizedBox(width: 0);
                        }

                        return Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                          margin: EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(5)),
                          child: Gtheme.stext(topics[index - 1],
                              size: GFontSize.XS, weight: GFontWeight.N),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
