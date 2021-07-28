import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sorted/core/global/animations/shimmer.dart';
import 'package:sorted/core/global/constants/constants.dart';

class ClassroomPreview extends StatelessWidget {
  final String coverImageUrl;
  final List<String> topics;
  final Function(String) updateUrl;

  const ClassroomPreview(
      {Key key, this.coverImageUrl, this.topics, this.updateUrl})
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
                              color: Colors.blue.shade50,
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

  onSelectUrl(String p1) {
    updateUrl(p1);
    print(onSelectUrl);
  }
}

class ImagePlaceholderWidget extends StatelessWidget {
  const ImagePlaceholderWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Shimmer(
      period: Duration(milliseconds: 1600),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.grey[200],
          Colors.grey[200],
          Colors.grey[350],
          Colors.grey[200],
          Colors.grey[200]
        ],
        stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
      ),
      child: Container(
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.all(Radius.circular(10.0)),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 1),
                color: Colors.black.withAlpha(80),
                blurRadius: 4)
          ],
          gradient: new LinearGradient(
              colors: [
                Colors.white,
                Colors.white,
              ],
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              stops: [1.0, 0.0],
              tileMode: TileMode.clamp),
        ),
      ),
    ));
  }
}
