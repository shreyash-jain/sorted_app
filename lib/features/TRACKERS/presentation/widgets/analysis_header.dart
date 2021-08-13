import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/widgets/image_placeholder_widget.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_model.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_property_model.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_summary.dart';

class TrackAnalysisHeader extends StatelessWidget {
  final TrackModel track;
  final TrackPropertyModel property;
  final TrackSummary summary;
  DateFormat formatterDate = DateFormat('dd MMMM');
  DateFormat formatterTime = DateFormat('jm');
  TrackAnalysisHeader({Key key, this.track, this.summary, this.property})
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: track.icon,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: ImagePlaceholderWidget(),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Container(
                    child: Gtheme.stext(track.name,
                        size: GFontSize.L, weight: GFontWeight.B1),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                child: Gtheme.stext(property.property_question,
                    size: GFontSize.XS, weight: GFontWeight.N),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                child: Gtheme.stext(
                    (summary == null || summary.track_logs.length == 0)
                        ? "Not filled"
                        : "Last filled on " +
                            formatterDate.format(summary.last_log),
                    size: GFontSize.S,
                    weight: GFontWeight.L),
              ),
              SizedBox(
                height: 16,
              ),
              if ((summary != null || summary.track_logs.length > 0))
                Container(
                  child: Gtheme.stext(
                      getStringFromCurrentValue(
                          property.property_type, property.n_stat_condition),
                      size: GFontSize.S,
                      weight: GFontWeight.B),
                ),
              SizedBox(
                height: 8,
              ),
              if ((summary != null || summary.track_logs.length > 0))
                Container(
                  child: Gtheme.stext(summary.currentValue,
                      size: GFontSize.L, weight: GFontWeight.B),
                ),
            ],
          ),
        ),
      ],
    );
  }

  String getStringFromCurrentValue(int type, int stat) {
    if (type == 1)
      return "Your last log";
    else if (type == 2) {
      switch (stat) {
        case 0:
          return "Last logged value in ${property.n_unit}";
          break;
        case 1:
          return "Total ${property.n_unit} today";
        case 2:
          return "Average ${property.n_unit} today";
          break;
        default:
          return "";
      }
    } else if (type == 3)
      return "Average value for today";
    else if (type == 4)
      return "Today's total duration";
    else
      return "";
  }
}
