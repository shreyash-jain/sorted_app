import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sorted/features/VIDEO_APP/presentation/pages/camera/camera_page.dart';
import 'package:sorted/features/VIDEO_APP/presentation/pages/trimming/trimmer_view.dart';
import 'package:sorted/features/VIDEO_APP/presentation/widgets/custom_button.dart';

import 'package:video_trimmer/video_trimmer.dart';

class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  final Trimmer _trimmer = Trimmer();

  ImagePicker imagePicker;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Row(
          children: [
            Expanded(child: Container()),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Container()),
                Text(
                  "New Video",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                CustomButton(
                  icon: Icons.folder,
                  text: "Choose from library",
                  bgColor: Colors.deepPurple,
                  borderColor: Colors.deepPurple,
                  width: 300,
                  onTap: _selectFromLibrary,
                ),
                SizedBox(
                  height: 15,
                ),
                CustomButton(
                  icon: Icons.folder,
                  text: "Record new video",
                  bgColor: Colors.black,
                  borderColor: Colors.deepPurple,
                  width: 300,
                  onTap: _recordFromCamera,
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }

  void _selectFromLibrary() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowCompression: false,
    );
    if (result != null) {
      File file = File(result.files.single.path);
      await _trimmer.loadVideo(videoFile: file);
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) {
          return TrimmerView(_trimmer);
        }),
      );
    }
  }

  void _recordFromCamera() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CameraPage(),
      ),
    );
  }
}
