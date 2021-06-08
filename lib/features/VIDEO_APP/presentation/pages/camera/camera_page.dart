import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sorted/features/VIDEO_APP/presentation/models/shot.dart';
import 'package:sorted/features/VIDEO_APP/presentation/pages/camera/preview_shots_page.dart';
import 'package:sorted/features/VIDEO_APP/presentation/widgets/time_multiply.dart';

import 'video_timer.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key key}) : super(key: key);

  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage>
    with AutomaticKeepAliveClientMixin {
  CameraController _controller;
  List<CameraDescription> _cameras;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isRecordingMode = true;
  bool _isRecording = false;
  double elapsed_time = 0;
  int num_shots = 0;
  int current_shot_id = -1;
  double speed = 1;
  int activeSpeed = 1;
  List<Shot> shots = [];
  Timer _timer;
  int _start = 0;
  double maxSeconds = 14.9;
  String filePath;
  @override
  void initState() {
    _initCamera();
    super.initState();
  }

  void startTimer() {
    _start = 0;
    const oneSec = const Duration(milliseconds: 100);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          _start = _start + 100;
          elapsed_time += 0.1 / speed;
          if (elapsed_time >= maxSeconds) {
            stopVideoRecording();
          }
        },
      ),
    );
  }

  void stopTimer() {
    _timer?.cancel();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras[0], ResolutionPreset.medium);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_controller != null) {
      if (!_controller.value.isInitialized) {
        return Container();
      }
    } else {
      return const Center(
        child: SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_controller.value.isInitialized) {
      return Container();
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        key: _scaffoldKey,
        extendBody: true,
        body: Stack(
          children: <Widget>[
            _buildCameraPreview(),
            _buildOptions(),
          ],
        ),
        // bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildCameraPreview() {
    return Container(
      child: Center(
        child: CameraPreview(_controller),
      ),
    );
  }

  Widget _buildOptions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PreviewShotsPage(
                  shots: shots,
                  deleteShot: (Shot shot) {
                    setState(() {
                      elapsed_time -= shot.time_length;
                      if (elapsed_time <= 0) elapsed_time = 0;
                      shots.remove(shot);
                    });
                  },
                ),
              ),
            );
          },
          child: Container(
            height: 60,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(100),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: shots
                  .map((e) => Container(
                        padding: EdgeInsets.all(12),
                        child: Text(e.id.toString()),
                      ))
                  .toList(),
            ),
          ),
        ),
        _buildBottomNavigationBar(),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Column(
      children: [
        Container(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              SizedBox(
                width: 30,
              ),
              TimeMultiply(
                text: "0.5x",
                isActive: activeSpeed == 0,
                onTap: () {
                  if (_isRecording) return;
                  setState(() {
                    activeSpeed = 0;
                    speed = 0.5;
                  });
                },
              ),
              SizedBox(width: 10),
              TimeMultiply(
                isActive: activeSpeed == 1,
                text: "1x",
                onTap: () {
                  if (_isRecording) return;
                  setState(() {
                    activeSpeed = 1;
                    speed = 1;
                  });
                },
              ),
              SizedBox(width: 10),
              TimeMultiply(
                isActive: activeSpeed == 2,
                text: "2x",
                onTap: () {
                  if (_isRecording) return;
                  setState(() {
                    activeSpeed = 2;
                    speed = 2;
                  });
                },
              ),
              SizedBox(width: 10),
              TimeMultiply(
                isActive: activeSpeed == 3,
                text: "4x",
                onTap: () {
                  if (_isRecording) return;
                  setState(() {
                    activeSpeed = 3;
                    speed = 4;
                  });
                },
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(30),
          ),
          height: 80.0,
          margin: EdgeInsets.only(left: 20, bottom: 20, right: 20, top: 7),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: Center(
                  child: VideoTimer(
                    milliseconds: _start,
                  ),
                ),
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 28.0,
                child: IconButton(
                  icon: Icon(
                    _isRecording ? Icons.stop : Icons.videocam,
                    size: 28.0,
                    color: (_isRecording) ? Colors.red : Colors.black,
                  ),
                  onPressed: _onRecordPressed,
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "${elapsed_time.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<String> startVideoRecording() async {
    print('startVideoRecording');
    if (!_controller.value.isInitialized) {
      return null;
    }
    if (elapsed_time >= maxSeconds) return null;
    setState(() {
      _isRecording = true;
    });
    startTimer();

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/media';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${_timestamp()}.mp4';

    if (_controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      await _controller.startVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  Future<XFile> stopVideoRecording() async {
    if (!_controller.value.isRecordingVideo) {
      return null;
    }
    stopTimer();
    setState(() {
      _isRecording = false;
    });

    try {
      XFile file = await _controller.stopVideoRecording();
      XFile last_frame;
      // last_frame = await _controller.takePicture();
      addShot(file, last_frame);
      return file;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  Future<void> addShot(XFile file, XFile last_frame) async {
    Shot shot = Shot(
      id: num_shots++,
      path: file.path,
      time_length: _start / 1000,
      speed: speed,
      last_frame: last_frame?.path ?? "nan",
      // thumbnail: last_frame.path,
    );

    setState(() {
      shots.add(shot);
    });
  }

  void _onRecordPressed() async {
    if (_isRecording) {
      XFile file = await stopVideoRecording();
      if (file == null) {
        print("video not recorded");
        return;
      }
    } else {
      filePath = await startVideoRecording();
    }
  }

  String _timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void logError(String code, String message) =>
      print('Error: $code\nError Message: $message');

  @override
  bool get wantKeepAlive => true;
}
