import 'package:flutter/material.dart';
import 'package:sorted/features/ONSTART/presentation/bloc/onstart_bloc.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/presentation/bloc/tab_tracks_bloc.dart';
import '../widgets/track_item_large.dart';
import '../../domain/entities/track.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabTracksPage extends StatefulWidget {
  final List<int> tracks;
  const TabTracksPage({this.tracks});
  @override
  _TabTracksPageState createState() => _TabTracksPageState();
}

class _TabTracksPageState extends State<TabTracksPage> {
  // TabTracksBloc _bloc;

  TabTracksBloc _bloc;

  @override
  void initState() {
    _bloc = sl<TabTracksBloc>();
    _bloc.add(GetTabTracksEvent(tracks: widget.tracks));
    super.initState();
  }

  @override
  void dispose() {
    _bloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocBuilder<TabTracksBloc, TabTracksState>(
        builder: (context, state) {
          if (state is GetTabTracksLoadedState) {
            return ListView.builder(
              itemCount: state.tracksDetail.length,
              itemBuilder: (_, i) =>
                  TrackItemLarge(track: state?.tracksDetail[i]),
            );
          }
          return Text("Loading");
        },
      ),
    );
  }
}
