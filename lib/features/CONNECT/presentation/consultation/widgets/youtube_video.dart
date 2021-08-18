
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeVideo extends StatefulWidget {
  final String youtubeUrl;
  YoutubeVideo({Key key, this.youtubeUrl}) : super(key: key);

  @override
  _YoutubeVideoState createState() => _YoutubeVideoState();
}

class _YoutubeVideoState extends State<YoutubeVideo> {
  YoutubePlayerController _controller;
  String videoId;
  @override
  void initState() {
    videoId = YoutubePlayer.convertUrlToId(widget.youtubeUrl);

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        disableDragSeek: true,
        autoPlay: false,
        mute: false,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: YoutubePlayer(
        controller: _controller,
        width: 300,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.black38,
        onReady: () {
          //_controller.addListener(listener);
        },
      ),
    );
  }
}
