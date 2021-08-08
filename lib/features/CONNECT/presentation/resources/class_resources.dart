import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/CONNECT/presentation/resources/class_audio_resource.dart';
import 'package:sorted/features/CONNECT/presentation/resources/class_image_resource.dart';

class ClassResourcesWidget extends StatefulWidget {
  ClassResourcesWidget({Key key}) : super(key: key);

  @override
  _ClassResourcesWidgetState createState() => _ClassResourcesWidgetState();
}

class _ClassResourcesWidgetState extends State<ClassResourcesWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(Gparam.widthPadding / 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Gtheme.stext("Class Resources",
                    size: GFontSize.S, weight: GFontWeight.B2),
                Spacer(),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Divider(
            color: Colors.grey.shade200,
            thickness: 2,
          ),
          Padding(
            padding: EdgeInsets.all(Gparam.widthPadding / 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Gtheme.stext("Added Resouces",
                    size: GFontSize.S, weight: GFontWeight.B2),
                Spacer(),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Gparam.widthPadding / 2),
            child: ClassroomImageResource(
              title: "Child Pose",
              imageUrl:
                  "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/prototype%2Fdownward-facing-dog-Recovered.png?alt=media&token=40419f91-d15e-4429-97ed-b3c28046d97d",
              caption:
                  "The child’s pose is a wonderful remedy for back ache though it is very easy to practice. Sit resting your buttocks on the ankle as you would do in Vajrasana. Stretch your hands upwards with the palm facing front. Now your hands are perfectly aligned to your head. Bend forwards with the head and hands moving forward together. In the final position your head will rest in the cupped knees and the hands will be found stretched forward with the palm touching the ground.",
              date: DateTime.now().add(Duration(days: -5)),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Gparam.widthPadding / 2),
            child: ClassroomAudioResource(
              title: "Monday Pep Talk",
              audioUrl:
                  "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/pep_talks%2FMotivational%20Talk%20%2019.mp3?alt=media&token=33574034-6c32-4187-b0e2-71f54023c3b8",
              caption: "",
              date: DateTime.now().add(Duration(days: -5)),
            ),
          )
        ],
      ),
    );
  }
}
