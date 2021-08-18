import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/widgets/UnicornOutlineButton.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_model.dart';

class StoryCircleWidget extends StatelessWidget {
  final TrackModel track;
  final String storyName;
  final String filePath;
  final int urlType;
  final bool isActive;
  final int storyType;
  final int id;
  final Function(int id, int storyType, TrackModel track) onClick;

  const StoryCircleWidget({
    Key key,
    this.storyName,
    this.filePath,
    this.urlType,
    this.isActive,
    this.storyType,
    this.onClick,
    this.id,
    this.track,
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
                Color(0xFF21739d),
                Theme.of(context).accentColor,
                Color(0xFF21739d)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            onPressed: () {
              if (onClick != null)
                onClick(id ?? 0, storyType ?? 0, track ?? TrackModel(id: -1));
              //
            },
            child: Column(
              children: [
                Container(
                    height: 70,
                    width: 70,
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
                        if (filePath != "")
                          ClipRRect(
                              borderRadius: BorderRadius.circular(0.0),
                              child: (urlType == 0)
                                  ? CachedNetworkImage(
                                      errorWidget: (context, url, error) =>
                                          Icon(
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
                          Center(
                            child: Container(
                              width: 80,
                              height: 80,
                              child: CircularProgressIndicator(
                                color: Color(0xFF21739d),
                              ),
                            ),
                          ),
                      ],
                    )),
              ],
            ),
          ),
          Container(
            width: 80,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(storyName,
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      letterSpacing: -.3,
                      fontFamily: 'Milliard',
                      fontSize: Gparam.textExtraSmall,
                      fontWeight: FontWeight.w500)),
            ),
          ),
        ],
      ),
    );
  }
}
