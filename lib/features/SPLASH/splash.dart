import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("splash");
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Container(
      width: 70,
      height: 70,
      child: new FlareActor("assets/animations/Sorted_Logo.flr",
          alignment: Alignment.center,
          fit: BoxFit.contain,
          animation: "Untitled"),
    )
      ),
    );
  }
}
