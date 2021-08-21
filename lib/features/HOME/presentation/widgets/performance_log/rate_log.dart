import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/widgets/slider_rate_widget.dart';
import 'package:sorted/core/global/widgets/slider_widget.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_summary.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_log.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_property_model.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_property_settings.dart';

class RateLog extends StatefulWidget {
  final TrackPropertyModel property;
  final TrackPropertySettings settings;
  final TrackSummary summary;
  final Function(TrackLog log, TrackSummary prevSummaty) onLog;
  RateLog({Key key, this.property, this.settings, this.summary, this.onLog})
      : super(key: key);

  @override
  _RateLogState createState() => _RateLogState();
}

class _RateLogState extends State<RateLog> {
  double value = 0;
  double initialValue = 0;
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  String unit = "";
  String statCondition = "";
  double myDouble;
  TrackPropertyModel _property;
  TrackPropertySettings _settings;

  @override
  void initState() {
    _property = widget.property;
    _settings = widget.settings;
    super.initState();

    try {
      myDouble = double.parse(widget.summary?.currentValue ?? "0.0");
    } catch (e) {
      myDouble = 0.0;
    }

    if (myDouble is double) // 123.45
      initialValue = myDouble;
    else
      initialValue = 0.0;

    value = initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Gparam.widthPadding),
              child: Gtheme.stext("${widget.property.property_question}",
                  size: GFontSize.XS, weight: GFontWeight.B1),
            ),
            SizedBox(
              height: 20,
            ),
            SliderRatingWidget(
              fullWidth: true,
              sliderHeight: 60,
              precision: widget.property.n_after_decimal,
              unit: "Rate",
              onUpdate: (v) {
                widget.onLog(
                    TrackLog(
                        property_id: _property.id,
                        track_id: _property.track_id,
                        value: (widget.property.r_max +
                                (widget.property.r_min -
                                        widget.property.r_min) *
                                    v)
                            .toStringAsFixed(0),
                        property_type: 3,
                        time: DateTime.now(),
                        id: DateTime.now().millisecondsSinceEpoch),
                    widget.summary);
              },
              min: widget.property.r_min.toInt(),
              max: widget.property.r_max.toInt(),
              minString: widget.property.r_min_string,
              maxString: widget.property.r_max_string,
            ),
          ],
        ),
      ),
    );
  }

  String getStatString(int statCondition) {
    switch (statCondition) {
      case 0:
        return "last logged";
        break;
      case 1:
        return "total today";
        break;
      case 2:
        return "average today";
        break;
      case 3:
        return "maximum today";
        break;
      default:
        return "";
    }
  }
}
