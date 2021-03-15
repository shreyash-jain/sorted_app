import 'package:flutter/material.dart';

class TrackStoryPage extends StatelessWidget {
  final String tag;
  TrackStoryPage({this.tag});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: tag,
        child: Container(
          color: Colors.red,
        ),
      ),
    );
  }
}
