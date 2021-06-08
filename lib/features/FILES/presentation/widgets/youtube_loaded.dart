import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/utility/measure_child.dart';
import 'package:sorted/core/global/widgets/fade_route.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/core/global/widgets/message_display.dart';
import 'package:sorted/features/FILES/data/models/block_info.dart';
import 'package:sorted/features/FILES/data/models/block_textbox.dart';
import 'package:sorted/features/FILES/presentation/image_bloc/image_bloc.dart';
import 'package:sorted/features/FILES/presentation/note_bloc/note_bloc.dart';

import 'package:sorted/features/FILES/presentation/widgets/textbox_edit.dart';
import 'package:sorted/features/FILES/presentation/youtube_bloc/todolist_bloc.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:zefyr/zefyr.dart';
import 'dart:convert';
import 'package:quill_delta/quill_delta.dart';

class YoutubeLoadedWidget extends StatefulWidget {
  final YoutubeLoaded state;
  final Function(YoutubeMetaData videoData) loadVideoData;

  const YoutubeLoadedWidget({
    Key key,
    this.state,
    this.loadVideoData,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => YoutubeLoadedWidgetState();
}

class YoutubeLoadedWidgetState extends State<YoutubeLoadedWidget> {
  double height = 10;
  TransformationController controller = TransformationController();
  YoutubePlayerController _controller;
  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  bool _isPlayerReady = false;

  var _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: widget.state.item.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    )..addListener(listener);

    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
      print("listener rgt");
      widget.loadVideoData(_videoMetaData);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("textbox build");
    return Center(
      child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: YoutubePlayerBuilder(
              player: YoutubePlayer(
                controller: _controller,
              ),
              builder: (context, player) {
                return YoutubePlayer(
                  controller: _controller,
                  progressIndicatorColor: Colors.red,
                  showVideoProgressIndicator: true,
                  onReady: () {
                    print("listener wt");
                    print(_controller.metadata);
                    widget.loadVideoData(_controller.metadata);
                  },
                );
              })),
    );
  }
}
