import 'package:flutter/material.dart';
import '../../../../../core/global/constants/constants.dart';
import '../../domain/entities/track.dart';

class SingleTrackPage extends StatelessWidget {
  final Track track;
  SingleTrackPage({this.track});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: [
          SizedBox(
            height: Gparam.topPadding,
          ),
          Container(
            height: Gparam.height * 0.2,
            child: Row(
              children: [
                Container(
                  width: Gparam.height * 0.2,
                  height: Gparam.height * 0.2,
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      SizedBox(
                        height: Gparam.height * 0.03,
                      ),
                      Text('track name'),
                      Text('market heading')
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: Gparam.height * 0.2,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Container(
                  width: Gparam.width * 0.3,
                  child: Column(
                    children: [
                      Text("10K"),
                      Text("people"),
                      Text("Tracking"),
                    ],
                  ),
                ),
                SizedBox(
                  width: Gparam.widthPadding,
                ),
                Container(
                  width: Gparam.width * 0.3,
                  child: Column(
                    children: [
                      Text("3 Months"),
                      Text("Track"),
                      Text("Duration"),
                    ],
                  ),
                ),
                SizedBox(
                  width: Gparam.widthPadding,
                ),
                Container(
                  width: Gparam.width * 0.3,
                  child: Column(
                    children: [
                      Text("10K"),
                      Text("people"),
                      Text("Tracking"),
                    ],
                  ),
                ),
                SizedBox(
                  width: Gparam.widthPadding,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
