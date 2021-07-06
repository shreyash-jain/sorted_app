import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/widgets/UnicornOutlineButton.dart';

class StoryCircleWidget extends StatelessWidget {
  final String storyName;
  final String filePath;
  final int urlType;
  final bool isActive;
  final int storyType;
  final int id;
  final Function(int id, int storyType) onClick;

  const StoryCircleWidget({
    Key key,
    this.storyName,
    this.filePath,
    this.urlType,
    this.isActive,
    this.storyType,
    this.onClick,
    this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          UnicornOutlineButton(
            strokeWidth: 2,
            radius: 100,
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Color(0xFF307df0),
                Theme.of(context).accentColor,
                Color(0xFF307df0)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            onPressed: () {
              if (onClick != null) onClick(id ?? 0, storyType ?? 0);
              //
            },
            child: Column(
              children: [
                Container(
                    height: 70,
                    width: 70,
                    margin: EdgeInsets.all(2),
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.all(Radius.circular(60.0)),
                      border: null,
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(1, 1),
                            color: Colors.black.withAlpha(40),
                            blurRadius: 10)
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(0.0),
                            child: (urlType == 0)
                                ? CachedNetworkImage(
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.error,
                                      color: Colors.grey,
                                    ),
                                    imageUrl: filePath,
                                    fit: BoxFit.cover,
                                    height: 70,
                                    width: 70,
                                  )
                                : Container(
                                    child: Image(
                                    image: AssetImage(filePath),
                                    height: 70,
                                    width: 70,
                                    fit: BoxFit.cover,
                                  ))),
                        if (isActive ?? false)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: Colors.redAccent, // border color
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(storyName,
                textAlign: TextAlign.center,
                style: TextStyle(
                    letterSpacing: -.3,
                    fontFamily: 'Milliard',
                    fontSize: Gparam.textExtraSmall,
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
