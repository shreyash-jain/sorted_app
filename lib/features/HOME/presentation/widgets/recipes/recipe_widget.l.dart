import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/widgets/image_placeholder_widget.dart';
import 'package:sorted/features/HOME/data/models/blogs.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:sorted/features/HOME/data/models/recipes/tagged_recipe.dart';
import 'package:sorted/features/HOME/data/models/recipes/video_recipe.dart';
import 'package:video_player/video_player.dart';

class HomeRecipeWidgetL extends StatefulWidget {
  HomeRecipeWidgetL({Key key, this.recipe, this.onClick, this.videoRecipe})
      : super(key: key);

  final Function(TaggedRecipe recipe) onClick;
  final TaggedRecipe recipe;
  final VideoRecipe videoRecipe;

  @override
  _HomeRecipeWidgetLState createState() => _HomeRecipeWidgetLState();
}

class _HomeRecipeWidgetLState extends State<HomeRecipeWidgetL> {
  VideoPlayerController videoController;

  @override
  void dispose() {
    super.dispose();
    if (videoController != null) videoController.dispose();
  }

  @override
  void initState() {
    super.initState();
    print("hello  " + widget.videoRecipe.video_url.toString());
    initializeVideo();
  }

  initializeVideo() {
    if (widget.videoRecipe.video_url != null &&
        widget.videoRecipe.video_url != '') {
      print("hello 4 " + widget.videoRecipe.video_url.toString());
      videoController = VideoPlayerController.network(
          widget.videoRecipe.video_url,
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true))
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          videoController.play();
          videoController.setVolume(0);

          videoController.setLooping(true);
          print("hello 1 " + widget.videoRecipe.video_url.toString());

          setState(() {});
        });
    } else {
      print("hello  2" + widget.videoRecipe.video_url.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.onClick != null) widget.onClick(widget.recipe);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: Gparam.widthPadding / 2,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      child: Container(
                          width: 254,
                          height: 80,
                          color:
                              (Theme.of(context).brightness == Brightness.dark)
                                  ? Colors.grey.shade900
                                  : Colors.grey.shade100,
                          child: Column(
                            children: [
                              Container(
                                height: 78,
                                padding: EdgeInsets.only(
                                    top: 8, left: 8, right: 8, bottom: 2),
                                child: Text(
                                  widget.videoRecipe.name,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                      color: (Theme.of(context).brightness ==
                                              Brightness.dark)
                                          ? Colors.white
                                          : Colors.black,
                                      fontFamily: 'Milliard',
                                      fontSize: Gparam.textSmall,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          )),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Stack(
                        children: [
                          Container(
                            height: 450,
                            color: Colors.blueGrey,
                            width: 254,
                            child: CachedNetworkImage(
                              imageUrl: widget.recipe.image_url,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                child: ImagePlaceholderWidget(),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                          Container(
                              height: 450,
                              color: Colors.transparent,
                              width: 254,
                              child: (videoController != null &&
                                      videoController.value.isInitialized)
                                  ? new ClipRect(
                                      child: new OverflowBox(
                                          maxWidth: 254,
                                          maxHeight: double.infinity,
                                          alignment: Alignment.center,
                                          child: new FittedBox(
                                              fit: BoxFit.cover,
                                              alignment: Alignment.center,
                                              child: new Container(
                                                  width: videoController
                                                      .value.size.width,
                                                  height: videoController
                                                      .value.size.height,
                                                  child: new VideoPlayer(
                                                      videoController)))))
                                  : Container(
                                      width: 0,
                                      height: 0,
                                    )),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
