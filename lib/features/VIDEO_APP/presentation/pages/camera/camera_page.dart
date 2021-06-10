import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_ffmpeg/statistics.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/widgets/blend_mask.dart';
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
  bool _isProcessing = false;
  double processStatus = 0;
  double elapsed_time = 0;
  int num_shots = 0;
  int current_shot_id = -1;
  double speed = 1;
  int activeSpeed = 1;
  List<Shot> shots = [];
  Timer _timer;
  int _start = 0;
  Shot currentShot = null;
  double maxSeconds = 14.9;
  String filePath;
  bool isOnionActivated = false;
  final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
  final FlutterFFmpegConfig _flutterFFmpegConfig = new FlutterFFmpegConfig();
  @override
  void initState() {
    _initCamera();
    _flutterFFmpegConfig.enableStatisticsCallback(this.statisticsCallback);
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
    _controller = CameraController(_cameras[0], ResolutionPreset.veryHigh);
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
    _flutterFFmpeg?.cancel();
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
        backgroundColor: Colors.black,
        key: _scaffoldKey,
        extendBody: true,
        body: Stack(
          children: <Widget>[
            _buildCameraPreview(),
            if (isOnionActivated)
              BlendMask(
                  blendMode: BlendMode.multiply, child: _buildOnionSkin()),
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

  Widget _buildOnionSkin() {
    return Container(
      child: Center(
        child: (currentShot != null &&
                currentShot.last_frame != null &&
                currentShot.last_frame.isNotEmpty)
            ? Container(
                decoration: BoxDecoration(
                  color: const Color(0xff7c94b6),
                  image: new DecorationImage(
                    fit: BoxFit.cover,
                    colorFilter:
                        ColorFilter.mode(Colors.transparent, BlendMode.lighten),
                    image: new FileImage(
                      File(currentShot.last_frame),
                    ),
                  ),
                ),
              )
            : Container(
                height: 0,
                width: 0,
              ),
      ),
    );
  }

  Widget _buildOptions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 100,
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: shots
                .map((e) => InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => PreviewShotsPage(
                              id: e.id,
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
                          padding: EdgeInsets.all(2),
                          child: e.last_frame == null
                              ? Text(e.id.toString())
                              : ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  child: Image.file(File(e.last_frame)))),
                    ))
                .toList(),
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
              SizedBox(width: 10),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    Text(
                      "Onion Skin",
                      style: TextStyle(
                          color: Colors.white, fontSize: Gparam.textSmaller),
                    ),
                    Switch(
                      value: isOnionActivated,
                      onChanged: onChangedOnion,
                      activeColor: Colors.black54,
                    )
                  ],
                ),
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

  Function(void Function()) seterState;

  int totalProgress = 0;
  void statisticsCallback(Statistics statistics) {
    print(
        "Statistics: executionId: ${statistics.executionId}, time: ${statistics.time}, size: ${statistics.size}, bitrate: ${statistics.bitrate}, speed: ${statistics.speed}, videoFrameNumber: ${statistics.videoFrameNumber}, videoQuality: ${statistics.videoQuality}, videoFps: ${statistics.videoFps}");

    if (currentShot != null) {
      if (mounted)
        seterState(() {
          totalProgress = (statistics.time) ~/ (currentShot.time_length * 1000);
        });
    }
  }

  Future<String> processShot(File input, int type) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    String rawDocumentPath = appDir.path;
    final outputPath = '$rawDocumentPath/${path.basename(input.absolute.path)}';
    _flutterFFmpegConfig.enableStatisticsCallback(this.statisticsCallback);

    switch (type) {
      case 0:
        {
          String commandToExecute =
              '-y -i ${input.path} -filter:v "setpts=2*PTS" -an $outputPath';
          setState(() {
            _isProcessing = true;
            _showLoadingPopup(context);
          });

          int rc = await _flutterFFmpeg.execute(commandToExecute);

          print("rc  " + rc.toString());
          setState(() {
            _isProcessing = false;
            Navigator.of(context).pop();
          });
          if (rc != 0) return "nan";
          print('video 3 stored');

          break;
        }
      case 1:
        {
          return input.path;
          break;
        }
      case 2:
        {
          String commandToExecute =
              '-y -i ${input.path} -filter:v "setpts=0.5*PTS" -an $outputPath';
          setState(() {
            _isProcessing = true;
            _showLoadingPopup(context);
          });

          int rc = await _flutterFFmpeg.execute(commandToExecute);

          print("rc  " + rc.toString());
          setState(() {
            _isProcessing = false;
            Navigator.of(context).pop();
          });
          if (rc != 0) return "nan";
          print('video 3 stored');

          break;
        }
      case 3:
        {
          String commandToExecute =
              '-y -i ${input.path} -filter:v "setpts=0.25*PTS" -an $outputPath';
          setState(() {
            _isProcessing = true;
            _showLoadingPopup(context);
          });

          int rc = await _flutterFFmpeg.execute(commandToExecute);

          print("rc  " + rc.toString());
          setState(() {
            _isProcessing = false;
            Navigator.of(context).pop();
          });
          if (rc != 0) return "nan";
          print('video 3 stored');

          break;
        }

      default:
    }

    print("output " + outputPath);
    return outputPath;
  }

  void saveLastFrame(String input_tag, String input_file) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    String rawDocumentPath = appDir.path;
    final outputPath = '$rawDocumentPath/$input_tag' + ".jpg";
    print("saveLastFrame" + outputPath);
    String commandToExecute =
        '-sseof -3 -i $input_file -update 1 -q:v 1 $outputPath';
    setState(() {
      _isProcessing = true;
      _showLoadingPopup(context);
    });

    int rc = await _flutterFFmpeg.execute(commandToExecute);
    print("rc 2 " + rc.toString());
    if (rc == 0) {
      setState(() {
        currentShot.last_frame = outputPath;
      });

      print("output jpg " + outputPath);
    }
    Navigator.of(context).pop();
  }

  Future<void> addShot(XFile file, XFile last_frame) async {
    Shot shot = Shot(
      id: num_shots++,
      path: file.path,
      time_length: _start / 1000,
      speed: speed,
      last_frame: last_frame?.path ?? "",
      // thumbnail: last_frame.path,
    );
    currentShot = shot;
    await saveLastFrame(path.basenameWithoutExtension(file.path), file.path);
    processShot(File(file.path), activeSpeed).then((value) {
      if (value != "nan") {
        shot.path = value;
        setState(() {
          shots.add(currentShot);
        });
      } else {
        print("error in conversion");
      }
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

  void _showLoadingPopup(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
            StatefulBuilder(builder: (context, innerSeterState) {
              seterState = innerSeterState;
              return AlertDialog(
                title: Text("Processing"),
                content: LinearProgressIndicator(
                  value: null,
                ),
              );
            }));
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

  void onChangedOnion(bool value) {
    setState(() {
      isOnionActivated = !isOnionActivated;
    });
  }
}
