import 'package:flutter/material.dart';

class AnimatedRocket extends AnimatedWidget {
  AnimatedRocket({Key key, Animation<double> animation})
    : super(key: key, listenable: animation);

  @override
    Widget build(BuildContext context) {
      final Animation<double> animation = listenable;
      return Container(
        margin: EdgeInsets.only(top: animation.value),
        child: Image.asset('assets/images/rocket.png')
      );
    }
}

class AnimatedSteam extends AnimatedWidget {
  AnimatedSteam({Key key, Animation<double> animation})
    : super(key: key, listenable: animation);

  @override
    Widget build(BuildContext context) {
      final Animation<double> animation = listenable;
      return Container(
        margin: EdgeInsets.only(top: animation.value),
        child: Image.asset('assets/images/launch_steam.png')
      );
    }
}