import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/widgets/image_placeholder_widget.dart';
import 'package:sorted/core/routes/router.gr.dart';
import 'package:sorted/features/HOME/presentation/track_log_bloc/track_log_bloc.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/activity_summary.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_summary.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_property_model.dart';
import 'package:sorted/features/TRACKERS/presentation/widgets/analysis_header.dart';

class ProfileTrackActivityView extends StatelessWidget {
  final TrackModel track;

  final Function() onClick;
  DateFormat formatterDate = DateFormat('dd MMMM');
  DateFormat formatterTime = DateFormat('jm');

  ProfileTrackActivityView({Key key, this.track, this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: () {
      if (onClick != null) {
        onClick();
      }
    }, child: BlocBuilder<PerformanceLogBloc, PerformanceLogState>(
      builder: (context, state) {
        if (state is ActivityLogLoaded)
          return Container(
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
                                    (state.summary == null ||
                                            state.summary.activities.length ==
                                                0)
                                        ? "Not filled"
                                        : "Last filled on " +
                                            formatterDate
                                                .format(state.summary.last_log),
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
                      if ((state.summary != null ||
                          state.summary.activities.length > 0))
                        Container(
                          child: Gtheme.stext("Total cal burnt today",
                              size: GFontSize.XXS, weight: GFontWeight.N),
                        ),
                      SizedBox(
                        height: 8,
                      ),
                      if ((state.summary != null ||
                          state.summary.activities.length > 0))
                        Container(
                          child: Gtheme.stext(
                              state.totalCalBurntToday.toString() + " Cal",
                              size: GFontSize.S,
                              weight: GFontWeight.B),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        else
          return Container(height: 0);
      },
    ));
  }

  bool isSameDate(DateTime thisDate, DateTime other) {
    return thisDate.year == other.year &&
        thisDate.month == other.month &&
        thisDate.day == other.day;
  }
}
