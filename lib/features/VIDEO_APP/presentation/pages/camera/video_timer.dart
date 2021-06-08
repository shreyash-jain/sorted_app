import 'package:flutter/material.dart';

class VideoTimer extends StatelessWidget {
  final int milliseconds;

  const VideoTimer({Key key, this.milliseconds}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: const Color(0x40000000),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.fiber_manual_record,
                size: 16.0,
                color: Colors.red,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                child: Text(
                  timeFormatter(Duration(milliseconds: milliseconds)),
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String timeFormatter(Duration duration) {
    String seconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    String milliseconds = (duration.inMilliseconds % 1000 / 10)
        .round()
        .toString()
        .padLeft(2, '0');
    print(milliseconds);
    return seconds + ":" + milliseconds;
  }
}
