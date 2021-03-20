import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class TrackStoryPage extends StatelessWidget {
  final String tag;
  final String url;
  TrackStoryPage({this.tag, @required this.url});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: tag,
        child: Container(
          width: double.infinity,
          child: CachedNetworkImage(
            fit: BoxFit.fill,
            imageUrl: url ?? "",
            progressIndicatorBuilder: (context, url, progress) =>
                CircularProgressIndicator(),
            errorWidget: (_, __, ___) => Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}
