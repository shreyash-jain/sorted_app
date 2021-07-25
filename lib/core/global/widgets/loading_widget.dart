import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<LoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 40,
        height: 40,
        child: new FlareActor("assets/animations/logo.flr",
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: "Untitled"),
      ),
    );
  }
}
