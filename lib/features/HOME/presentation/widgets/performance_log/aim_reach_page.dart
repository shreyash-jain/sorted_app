import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_model.dart';
import 'dart:math';

class GoalCompletedPopup extends StatefulWidget {
  final String text;
  final String title;
  final String imageUrl;

  GoalCompletedPopup({Key key, this.text, this.title, this.imageUrl})
      : super(key: key);

  @override
  _GoalCompletedPopupState createState() => _GoalCompletedPopupState();
}

class _GoalCompletedPopupState extends State<GoalCompletedPopup> {
  ConfettiController _controllerCenter;

  @override
  void initState() {
    super.initState();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 2));
    _controllerCenter.play();
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Gparam.height / 2,
      width: Gparam.width,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.imageUrl != null)
                  CachedNetworkImage(
                    errorWidget: (context, url, error) => Icon(
                      Icons.error,
                      color: Colors.grey,
                    ),
                    imageUrl: widget.imageUrl,
                    fit: BoxFit.cover,
                    height: 100,
                    width: 100,
                  ),
                SizedBox(
                  height: 25,
                ),
                Center(
                    child: Container(
                  child: Gtheme.stext(widget.title,
                      size: GFontSize.S, weight: GFontWeight.L),
                )),
                SizedBox(
                  height: 25,
                ),
                if (widget.text != null)
                  Center(
                      child: Container(
                    padding: EdgeInsets.all(16),
                    child: Gtheme.stext(widget.text),
                  )),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ConfettiWidget(
              confettiController: _controllerCenter,
              blastDirectionality: BlastDirectionality
                  .explosive, // don't specify a direction, blast randomly
              shouldLoop:
                  true, // start again as soon as the animation is finished
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ], // manually specify the colors to be used
              createParticlePath: drawStar, // define a custom shape/path.
            ),
          ),
        ],
      ),
    );
  }

  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }
}
