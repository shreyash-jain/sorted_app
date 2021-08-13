import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/widgets/slider_widget.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_summary.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_log.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_property_model.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_property_settings.dart';

class TextLog extends StatefulWidget {
  final TrackPropertyModel property;
  final TrackPropertySettings settings;
  final TrackSummary summary;
  final Function(TrackLog log, TrackSummary prevSummaty) onLog;
  TextLog({Key key, this.property, this.settings, this.summary, this.onLog})
      : super(key: key);

  @override
  _TextLogState createState() => _TextLogState();
}

class _TextLogState extends State<TextLog> {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  String lastLogTime = "Log for the first time";
  TrackPropertyModel _property;
  TrackPropertySettings _settings;
  TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    if (widget.summary != null && widget.summary.last_log != null)
      lastLogTime =
          "Last logged at " + formatter.format(widget.summary.last_log);
    super.initState();
    _property = widget.property;
    _settings = widget.settings;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.all(Gparam.widthPadding),
              child: Gtheme.stext(lastLogTime,
                  weight: GFontWeight.B1, size: GFontSize.XXS),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Gparam.widthPadding),
              child: Gtheme.stext(_property.property_question,
                  size: GFontSize.XS, weight: GFontWeight.B1),
            ),
            Padding(
              padding: EdgeInsets.all(Gparam.widthPadding),
              child: TextField(
                controller: _messageController,
                onChanged: (text) {
                  widget.onLog(
                      TrackLog(
                          property_id: _property.id,
                          track_id: _property.track_id,
                          value: text,
                          property_type: 1,
                          time: DateTime.now(),
                          id: DateTime.now().millisecondsSinceEpoch),
                      widget.summary);
                },
                decoration: InputDecoration(
                    hintText: _property.t_hint_text,
                    hintStyle: Gtheme.blackShadowBold28,
                    border: InputBorder.none),
              ),
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
