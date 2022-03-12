import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/widgets/image_placeholder_widget.dart';
import 'package:sorted/core/routes/router.gr.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_summary.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_property_model.dart';
import 'package:sorted/features/TRACKERS/presentation/widgets/analysis_header.dart';

class ProfileTrackView extends StatelessWidget {
  final TrackModel track;
  final TrackSummary summary;
  final TrackPropertyModel property;
  final Function() onClick;
  DateFormat formatterDate = DateFormat('dd MMMM');
  DateFormat formatterTime = DateFormat('jm');

  ProfileTrackView(
      {Key key, this.track, this.summary, this.property, this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          if (onClick != null) {
            onClick();
          }
        },
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.symmetric(
                    horizontal: Gparam.widthPadding, vertical: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
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
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Gtheme.stext(track.name,
                                  size: GFontSize.S, weight: GFontWeight.B1),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              child: Gtheme.stext(
                                  (summary == null ||
                                          summary.track_logs.length == 0)
                                      ? "Not filled"
                                      : "Last filled on " +
                                          formatterDate
                                              .format(summary.last_log),
                                  size: GFontSize.XXS,
                                  weight: GFontWeight.L),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    if ((summary != null || summary.track_logs.length > 0))
                      Container(
                        child: Gtheme.stext(
                            getStringFromCurrentValue(
                                property.property_type,
                                property.n_stat_condition,
                                summary.last_log,
                                summary.currentValue),
                            size: GFontSize.XXS,
                            weight: GFontWeight.N),
                      ),
                    SizedBox(
                      height: 8,
                    ),
                    if ((summary != null || summary.track_logs.length > 0))
                      Container(
                        child: Gtheme.stext(
                            getUpdatedStringForCurrentValue(
                              summary.currentValue,
                              property.property_type,
                              property.n_stat_condition,
                            ),
                            size: GFontSize.S,
                            weight: GFontWeight.B),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  String getUpdatedStringForCurrentValue(
      String currentValue, int type, int stat) {
    if (currentValue == null || currentValue == "") return "";
    switch (type) {
      case 2:
        {
          switch (stat) {
            case 0:
              return "$currentValue ${property.n_unit}";
            case 1:
              return "$currentValue ${property.n_unit}";

              break;
            default:
              return "$currentValue";
          }
          break;
        }
      case 3:
        return "$currentValue rated out of 5";
      case 4:
        double val = 0;
        try {
          val = double.parse(currentValue);
        } catch (e) {
          return "$currentValue";
        }
        if (val < 60)
          return "$currentValue mins";
        else
          return _printDuration(Duration(minutes: val.toInt()));
        break;
      default:
        return "$currentValue";
    }
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));

    return "${twoDigits(duration.inHours)}:$twoDigitMinutes Hours";
  }

  String getStringFromCurrentValue(
      int type, int stat, DateTime date, String currentValue) {
    String dateString;
    if (date == null) return "No data";
    dateString = formatterDate.format(date);
    if (date == null)
      dateString = "Never filled";
    else if (isSameDate(DateTime.now(), date))
      dateString = "today";
    else if (isSameDate(DateTime.now().subtract(Duration(days: 1)), date))
      dateString = "yesterday";
    if (type == 1)
      return "Your last log";
    else if (type == 2) {
      switch (stat) {
        case 0:
          return "Last logged value in ${property.n_unit}";
          break;
        case 1:
          return "Total in ${property.n_unit} on $dateString";
        case 2:
          return "Average ${property.n_unit} on $dateString";
          break;
        default:
          return "";
      }
    } else if (type == 3)
      return "Average value for today";
    else if (type == 4)
      return "Total in Hours on $dateString";
    else
      return "";
  }

  bool isSameDate(DateTime thisDate, DateTime other) {
    return thisDate.year == other.year &&
        thisDate.month == other.month &&
        thisDate.day == other.day;
  }
}
