import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/HOME/presentation/pages/homePage.dart';
import 'package:sorted/features/HOME/presentation/widgets/animated_fab.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/features/SETTINGS/presentation/pages/settings_page.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/presentation/bloc/track_store_bloc.dart';

class TrackStoreMain extends StatefulWidget {
  @override
  _TrackStoreMainState createState() => _TrackStoreMainState();
}

class _TrackStoreMainState extends State<TrackStoreMain> {
  TrackStoreBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = sl<TrackStoreBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[],
        ),
      ),
      body: Center(
        child: Text("Track Store"),
      ),
    );
  }
}
