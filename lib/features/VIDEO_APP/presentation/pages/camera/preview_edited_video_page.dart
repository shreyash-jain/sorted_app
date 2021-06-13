import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sorted/features/VIDEO_APP/presentation/models/shot.dart';
import 'package:sorted/features/VIDEO_APP/presentation/widgets/thumb_element.dart';

import 'package:video_player/video_player.dart';

class PreviewEditedVideoPage extends StatefulWidget {
  final File editedVideo;
  const PreviewEditedVideoPage({
    Key key,
    @required this.editedVideo,
  }) : super(key: key);

  @override
  _PreviewEditedVideoPageState createState() => _PreviewEditedVideoPageState();
}

class _PreviewEditedVideoPageState extends State<PreviewEditedVideoPage> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.file(widget.editedVideo);
    _initializeVideoPlayerFuture =
        _controller.initialize().then((value) => _controller.play());

    super.initState();
  }

  @override
  void dispose() {
    _initializeVideoPlayerFuture = null;
    _controller?.pause()?.then((_) {
      _controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          child: Stack(
            children: [
              Center(
                  child: _controller == null
                      ? Center(
                          child: Text(
                            "There is no shot to show!",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : FutureBuilder(
                          future: _initializeVideoPlayerFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Container(
                                child: VideoPlayer(_controller),
                              );
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          })),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _initializePlay(String videoPath) async {
    _controller = VideoPlayerController.file(File(videoPath));

    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() {
        _controller.play();
      });
    });
  }

  Future<void> _startPlay(String videoPath) async {
    setState(() {
      _initializeVideoPlayerFuture = null;
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      _clearPrevious().then((_) {
        _initializePlay(videoPath);
      });
    });
  }

  Future<bool> _clearPrevious() async {
    await _controller?.pause();
    return true;
  }
}
