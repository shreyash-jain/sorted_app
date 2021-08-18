import 'dart:ui';

import 'package:audio_session/audio_session.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

import 'package:rxdart/rxdart.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/CONNECT/presentation/widgets/classroom_preview.dart';
import 'package:sorted/features/HOME/data/models/motivation/pep_talks.dart';
import 'package:sorted/features/HOME/presentation/widgets/utils/audio_player.dart';

class PepTalkPlayer extends StatefulWidget {
  final PepTalkModel talk;
  PepTalkPlayer({Key key, this.talk}) : super(key: key);

  @override
  _PepTalkPlayerState createState() => _PepTalkPlayerState();
}

class _PepTalkPlayerState extends State<PepTalkPlayer> {
  final _player = AudioPlayer();
  LockCachingAudioSource _audioSource;
  double _sigmaX = 5; // from 0-10
  double _sigmaY = 5; // from 0-10
  double _opacity = 0.5; // from 0-1.0
  double _width = 350;
  double _height = 300;
  double _blurWidth = 350 / 2;
  double _blurHeight = 300 / 2;

  @override
  void initState() {
    super.initState();
    _audioSource = LockCachingAudioSource(Uri.parse(widget.talk.fileLink));
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    try {
      print("heeelo $_audioSource");
      await _audioSource.clearCache();
      await _player.setAudioSource(_audioSource);
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  @override
  void dispose() {
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
    _player.dispose();
    super.dispose();
  }

  /// Collects the data useful for displaying in a seek bar, using a handy
  /// feature of rx_dart to combine the 3 streams of interest into one.
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, double, Duration, PositionData>(
          _player.positionStream,
          _audioSource.downloadProgressStream,
          _player.durationStream,
          (position, downloadProgress, reportedDuration) {
        final duration = reportedDuration ?? Duration.zero;
        final bufferedPosition = duration * downloadProgress;
        return PositionData(position, bufferedPosition, duration);
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: widget.talk.imageUrl,
                width: Gparam.width,
                height: Gparam.height,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: ImagePlaceholderWidget(),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.grey.withOpacity(0.1),
                  alignment: Alignment.center,
                  child: Text(''),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Display play/pause button and volume/speed sliders.
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: widget.talk.imageUrl,
                      width: Gparam.width - 20,
                      height: 300,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: ImagePlaceholderWidget(),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  ControlButtons(_player),
                  // Display seek bar. Using StreamBuilder, this widget rebuilds
                  // each time the position, buffered position or duration changes.
                  StreamBuilder<PositionData>(
                    stream: _positionDataStream,
                    builder: (context, snapshot) {
                      final positionData = snapshot.data;
                      return SeekBar(
                        duration: positionData?.duration ?? Duration.zero,
                        position: positionData?.position ?? Duration.zero,
                        bufferedPosition:
                            positionData?.bufferedPosition ?? Duration.zero,
                        onChangeEnd: _player.seek,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Displays the play/pause button and volume/speed sliders.
class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  ControlButtons(this.player);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Opens volume slider dialog
        IconButton(
          icon: Icon(Icons.volume_up),
          onPressed: () {
            showSliderDialog(
              context: context,
              title: "Adjust volume",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              value: player.volume,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            );
          },
        ),

        /// This StreamBuilder rebuilds whenever the player state changes, which
        /// includes the playing/paused state and also the
        /// loading/buffering/ready state. Depending on the state we show the
        /// appropriate button or loading indicator.
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                icon: Icon(Icons.play_arrow),
                iconSize: 64.0,
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: Icon(Icons.pause),
                iconSize: 64.0,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: Icon(Icons.replay),
                iconSize: 64.0,
                onPressed: () => player.seek(Duration.zero),
              );
            }
          },
        ),
        // Opens speed slider dialog
        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              showSliderDialog(
                context: context,
                title: "Adjust speed",
                divisions: 10,
                min: 0.5,
                max: 1.5,
                value: player.speed,
                stream: player.speedStream,
                onChanged: player.setSpeed,
              );
            },
          ),
        ),
      ],
    );
  }
}
