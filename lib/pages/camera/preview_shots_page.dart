import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_app/models/shot.dart';
import 'package:video_app/widgets/thumb_element.dart';
import 'package:video_player/video_player.dart';

class PreviewShotsPage extends StatefulWidget {
  final List<Shot> shots;
  final deleteShot;
  const PreviewShotsPage({
    Key key,
    @required this.shots,
    @required this.deleteShot,
  }) : super(key: key);

  @override
  _PreviewShotsPageState createState() => _PreviewShotsPageState();
}

class _PreviewShotsPageState extends State<PreviewShotsPage> {
  VideoPlayerController _controller;
  List<Shot> shots;
  @override
  void initState() {
    shots = [];
    shots.addAll(widget.shots);
    if (shots.isNotEmpty)
      _controller = VideoPlayerController.file(File(shots[0].path))
        ..initialize().then((_) async {
          setState(() {});
          await _controller.setPlaybackSpeed(shots[0].speed);
          _controller.play();
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          child: Column(
            children: [
              Container(
                height: 70,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(100),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: widget.shots
                      .map(
                        (e) => ThumbElement(
                          shot: e,
                          onDelete: () {
                            widget.deleteShot(e);
                            setState(() {
                              shots.remove(e);
                            });
                          },
                          onTap: () async {
                            _controller =
                                VideoPlayerController.file(File(e.path))
                                  ..initialize().then((_) async {
                                    setState(() {});
                                    await _controller.setPlaybackSpeed(e.speed);
                                    _controller.play();
                                  });
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio * 1.5,
                  child: _controller == null || shots.isEmpty
                      ? Center(
                          child: Text(
                            "There is no shot to show!",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : _controller.value.initialized
                          ? Container(
                              child: VideoPlayer(_controller),
                            )
                          : Container(
                              child: Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
