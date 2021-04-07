import 'package:flutter/material.dart';
import '../../../../../../core/global/constants/constants.dart';
import '../../bloc/single_track/single_track_bloc.dart';
import '../../../domain/entities/track.dart';

class PauseDurationDialog extends StatelessWidget {
  Track track;
  final SingleTrackBloc bloc;
  PauseDurationDialog({this.bloc, this.track});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Gparam.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.greenAccent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 50,
              child: Row(
                children: [
                  SizedBox(
                    width: Gparam.widthPadding / 2,
                  ),
                  Text(
                    "Pause temporary",
                    style: Gtheme.textBold,
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                track.u_active_state = 0;
                track.u_pause_open_ts = DateTime.now()
                    .add(Duration(days: 7))
                    .microsecondsSinceEpoch;
                Navigator.pop(context);
                Navigator.pop(context);
                bloc.add(PauseTrackEvent(track: track));
              },
              child: Container(
                height: 40,
                child: Row(
                  children: [
                    SizedBox(
                      width: Gparam.widthPadding,
                    ),
                    Text(
                      "7 days",
                      style: Gtheme.textBold,
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                track.u_active_state = 0;
                track.u_pause_open_ts = DateTime.now()
                    .add(Duration(days: 21))
                    .microsecondsSinceEpoch;
                Navigator.pop(context);
                Navigator.pop(context);
                bloc.add(PauseTrackEvent(track: track));
              },
              child: Container(
                height: 40,
                child: Row(
                  children: [
                    SizedBox(
                      width: Gparam.widthPadding,
                    ),
                    Text(
                      "21 days",
                      style: Gtheme.textBold,
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                track.u_active_state = 0;
                track.u_pause_open_ts = DateTime.now()
                    .add(Duration(days: 90))
                    .microsecondsSinceEpoch;
                Navigator.pop(context);
                Navigator.pop(context);
                bloc.add(PauseTrackEvent(track: track));
              },
              child: Container(
                height: 40,
                child: Row(
                  children: [
                    SizedBox(
                      width: Gparam.widthPadding,
                    ),
                    Text(
                      "3 months",
                      style: Gtheme.textBold,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: Gparam.heightPadding,
            ),
          ],
        ),
      ),
    );
  }
}
