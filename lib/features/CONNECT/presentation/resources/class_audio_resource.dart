import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sorted/core/global/constants/constants.dart';

class ClassroomAudioResource extends StatefulWidget {
  final String audioUrl;
  final String caption;
  final DateTime date;
  final String title;
  ClassroomAudioResource(
      {Key key, this.audioUrl, this.caption, this.date, this.title})
      : super(key: key);

  @override
  _ClassroomAudioResourceState createState() => _ClassroomAudioResourceState();
}

class _ClassroomAudioResourceState extends State<ClassroomAudioResource> {
  String localFilePath;
  Duration duration;


  @override
  void initState() {
    

    super.initState();
  }

  @override
  Future<void> dispose() async {
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  child: Gtheme.stext(widget.title,
                      weight: GFontWeight.B2, size: GFontSize.S),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  child: Gtheme.stext(DateFormat('MMM dd').format(widget.date),
                      weight: GFontWeight.N, size: GFontSize.XXS),
                ),
                Spacer(),
                Icon(Icons.share)
              ],
            ),
          
            Container(
              height: 12,
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: Gtheme.stext(widget.caption),
            ),
          ],
        ));
  }




}
