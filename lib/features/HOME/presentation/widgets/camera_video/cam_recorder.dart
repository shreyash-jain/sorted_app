import 'package:flutter/material.dart';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

//import './play_video.dart';

class CamRenderer extends StatefulWidget {
  CameraController controller;

  CamRenderer(this.controller);

  @override
  _CamRendererState createState() => _CamRendererState();
}

class _CamRendererState extends State<CamRenderer> {
  String path;
  File filePath;

  int intervalTime = 10; // 30 seconds

  DateTime dateTimeStart;
  Duration totalVideoDuration = Duration(seconds: 0);

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CameraPreview(
            widget.controller
          ),
          Positioned(
            bottom: 5.0,
            left: 5.0,
            child: RaisedButton(
              child: Text('Stop'),
              onPressed: () {
                if( widget.controller.value.isRecordingVideo || widget.controller.value.isRecordingPaused ) {
                  print('Stop recording');
                  widget.controller.stopVideoRecording().then(
                    (_) {
                      print('###########################');
                      print('Video recording stopped');
                      totalVideoDuration = Duration(seconds: 0);
                      print(path);
                      filePath = File(path);
                      print(filePath);
                      print('###########################');
                    }
                  );
                } else {  
                  print('No active video recording to stop');
                }
              },
            ),
          ),
          Positioned(
            bottom: 5.0,
            right: 5.0,
            child: GestureDetector(
              child: Container(
                color: Colors.white,
                child: SizedBox(
                  child: Center(
                    child: Text(
                      'Record',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.red
                      ),
                    )
                  ),
                  height: 40.0,
                  width: 60.0,
                ),
              ),
              onLongPressStart: (data ) {
                print('#######################################################');
                print('onLongPressStart');

                if( ! widget.controller.value.isRecordingVideo ) {
                  print('When user long presses and holds for the first time');
                  dateTimeStart = DateTime.now();
                  print('Video start time: $dateTimeStart');
                  getTemporaryDirectory().then(
                    (dir) {
                      path = dir.path + '$dateTimeStart.mp4';
                      print('Starting video recording');
                      widget.controller.startVideoRecording(path).then(
                        (_) {
                          print('**************');
                          print('Video recording started');
                          print('Video file name: $path');
                          print('**************');
                        }
                      );
                    }
                  );
                }
                
                print('Before resuming the video');
                print('Total video duration: ${totalVideoDuration.inSeconds} s');
                if( ( widget.controller.value.isRecordingVideo || widget.controller.value.isRecordingPaused ) ) {
                  if( totalVideoDuration.inSeconds <= intervalTime ) {
                    print('Resuming');
                    widget.controller.resumeVideoRecording().then(
                      (_) {
                        print('**************');
                        print('Video recording resumed');
                        dateTimeStart = DateTime.now();
                        print('Current time: $dateTimeStart');
                        print('**************');
                      }
                    );
                  } else {
                    print('Total video duration is greater than 30s');
                    print('Total video duration: ${totalVideoDuration.inSeconds} s');
                    print('Stopping');
                    print('Debug>>');
                    print(widget.controller.value.isRecordingVideo);
                    print(widget.controller.value.isRecordingPaused);
                    widget.controller.stopVideoRecording().then(
                      (_) {
                        print('**************');
                        print('Video recording is stopped');
                        totalVideoDuration = Duration(seconds: 0);
                        print(path);
                        filePath = File(path);
                        print(filePath);
                        print('**************');
                      }
                    ).catchError( (err) {
                      print('**************');
                      print('Error while stopping the video');
                      totalVideoDuration = Duration(seconds: 0);
                      print(err.toString());
                      print('**************');
                    });
                  }
                } 
                print('#######################################################');
              },
              onLongPressEnd: (data) {
                print('#######################################################');
                print('onLongPressEnd');
                if( widget.controller.value.isRecordingVideo || widget.controller.value.isRecordingPaused ) {
                  print('Pausing');
                  widget.controller.pauseVideoRecording().then(
                    (_) {
                      print('**************');
                      print('Video recording is paused');
                      DateTime currentTime = DateTime.now();
                      print('Current time: $currentTime');
                      int tempTotalDuration = totalVideoDuration.inSeconds;
                      print('Previous total duration: $tempTotalDuration');
                      totalVideoDuration = currentTime.difference(dateTimeStart);
                      print('Intermediate total duration: ${totalVideoDuration.inSeconds} s');
                      totalVideoDuration = Duration(seconds: totalVideoDuration.inSeconds + tempTotalDuration );
                      print('Total Video duration : ${totalVideoDuration.inSeconds} s');
                      print('**************');
                    }
                  );
                }
                print('#######################################################');
              },
            ),
          ),
          Positioned(
            left: 5.0,
            top: 25.0,
            child: RaisedButton(
              child: Text('View'),
              onPressed: () {
                if( filePath != null ) {
                  //Navigator.push(
                  //  context, 
                  //  MaterialPageRoute(
                  //    builder: (context) => VideoPlayerApp(filePath)
                  //  )
                  //); 
                }
              },
            ),
          )
        ],
      ),
    );
  }
}