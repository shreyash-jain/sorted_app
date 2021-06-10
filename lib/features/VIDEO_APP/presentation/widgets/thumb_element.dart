import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sorted/features/VIDEO_APP/presentation/models/shot.dart';

import 'package:video_trimmer/video_trimmer.dart';

class ThumbElement extends StatelessWidget {
  final Shot shot;
  final onTap, onDelete;

  const ThumbElement({
    Key key,
    @required this.shot,
    @required this.onTap,
    @required this.onDelete,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              height: 70,
              padding: EdgeInsets.all(4),
              child: shot.last_frame == null
                  ? Text(shot.id.toString())
                  : ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Image.file(File(shot.last_frame))),
            ),
            InkWell(
              onTap: onDelete,
              child: Container(
                  child: Icon(
                Icons.cancel,
                color: Colors.red,
                size: 16,
              )),
            ),
          ],
        ),
      ),
    );
  }
}
