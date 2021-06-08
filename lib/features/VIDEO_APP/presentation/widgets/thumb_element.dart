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
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              child: Text(shot.id.toString()),
            ),
            InkWell(
              onTap: onDelete,
              child: Container(
                child: Text("Delete"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
