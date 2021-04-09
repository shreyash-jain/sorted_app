import 'package:flutter/material.dart';

import '../../../../../../core/global/constants/constants.dart';
import './pause_duration_dialog.dart';
import '../../bloc/single_track/single_track_bloc.dart';
import '../../../domain/entities/track.dart';

class PauseDialog extends StatelessWidget {
  final Track track;
  final SingleTrackBloc bloc;
  PauseDialog({
    @required this.bloc,
    @required this.track,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: Gparam.width * 0.8,
      decoration: BoxDecoration(
        color: Theme.of(context).indicatorColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    backgroundColor: Colors.transparent,
                    child: PauseDurationDialog(
                      track: track,
                      bloc: bloc,
                    ),
                  ),
                );
              },
              child: Container(
                height: 50,
                child: Row(
                  children: [
                    SizedBox(
                      width: Gparam.widthPadding,
                    ),
                    Container(
                      child: Icon(Icons.pause),
                    ),
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
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                bloc.add(
                  UnsubscribeFromTrackEvent(
                    track_id: track.id,
                  ),
                );
              },
              child: Container(
                height: 50,
                child: Row(
                  children: [
                    SizedBox(
                      width: Gparam.widthPadding,
                    ),
                    Container(
                      child: Icon(Icons.remove),
                    ),
                    SizedBox(
                      width: Gparam.widthPadding / 2,
                    ),
                    Text(
                      "Stop tracking",
                      style: Gtheme.textBold,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
