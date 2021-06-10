import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sorted/features/VIDEO_APP/presentation/models/shot.dart';
import 'package:sorted/features/VIDEO_APP/presentation/widgets/thumb_element.dart';

import 'package:video_player/video_player.dart';

class PreviewShotsPage extends StatefulWidget {
  final int id;
  final List<Shot> shots;
  final deleteShot;
  const PreviewShotsPage({
    Key key,
    @required this.shots,
    @required this.deleteShot,
    @required this.id,
  }) : super(key: key);

  @override
  _PreviewShotsPageState createState() => _PreviewShotsPageState();
}

class _PreviewShotsPageState extends State<PreviewShotsPage> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  List<Shot> shots;
  @override
  void initState() {
    shots = [];
    shots.addAll(widget.shots);
    Shot clickedShot;
    if (shots.isNotEmpty) {
      clickedShot = shots.firstWhere((element) => element.id == widget.id,
          orElse: () => Shot(id: -1));

      if (clickedShot.id != -1) {
        _controller = VideoPlayerController.file(File(clickedShot.path));
        _initializeVideoPlayerFuture =
            _controller.initialize().then((value) => _controller.play());
      }
    }
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
                  child: _controller == null || shots.isEmpty
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
              Container(
                height: 110,
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
                            print(e.path + "path1");
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PreviewShotsPage(
                                    id: e.id,
                                    shots: shots,
                                    deleteShot: widget.deleteShot),
                              ),
                            );

                            
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
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
