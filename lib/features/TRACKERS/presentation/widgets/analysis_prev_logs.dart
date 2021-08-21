import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/widgets/image_placeholder_widget.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_model.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_property_model.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_summary.dart';

class TrackAnalysisPrevLogs extends StatelessWidget {
  final TrackModel track;
  final TrackSummary summary;
  final TrackPropertyModel property;
  DateFormat formatterDate = DateFormat('dd MMMM');
  DateFormat formatterTime = DateFormat('jm');

  TrackAnalysisPrevLogs({Key key, this.track, this.summary, this.property})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: Gparam.heightPadding * 1.5,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Gparam.widthPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    child: Gtheme.stext("📊 Past Logs",
                        size: GFontSize.S, weight: GFontWeight.N),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey.shade300,
              ),
              SizedBox(
                height: 8,
              ),
              if (summary.track_logs.length == 0)
                Container(
                  child: Gtheme.stext("No Data",
                      size: GFontSize.S, weight: GFontWeight.B),
                ),
              if (summary.track_logs.length > 0)
                Container(
                  height: 100,
                  child: ListView.builder(
                    itemCount: summary.track_logs.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    reverse: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 100,
                        margin: EdgeInsets.all(4),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Gtheme.stext(summary.track_logs[index].value,
                                    size: GFontSize.L, weight: GFontWeight.B),
                                Gtheme.stext(" " + property.n_unit,
                                    size: GFontSize.XS, weight: GFontWeight.L),
                                if (property.property_type == 4)
                                  Gtheme.stext(" mins",
                                      size: GFontSize.XS,
                                      weight: GFontWeight.L),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Gtheme.stext(
                                formatterDate
                                    .format(summary.track_logs[index].time),
                                size: GFontSize.XXS,
                                weight: GFontWeight.N),
                            SizedBox(
                              height: 8,
                            ),
                            Gtheme.stext(
                                formatterTime
                                    .format(summary.track_logs[index].time),
                                size: GFontSize.XXXS,
                                weight: GFontWeight.L),
                          ],
                        ),
                      );
                    },
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));

    return "${twoDigits(duration.inHours)}:$twoDigitMinutes Hours";
  }
}
