import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:core';
import 'package:flutter/painting.dart';

import 'package:intl/intl.dart';
import 'package:sa_anicoto/sa_anicoto.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sorted/core/error/exceptions.dart';
import 'package:sorted/core/global/animations/fade_animationLR.dart';

import 'package:sorted/core/global/animations/fade_animationTB.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/routes/router.gr.dart';
import 'package:sorted/features/HOME/presentation/pages/camera_screen.dart';
import 'package:sorted/features/HOME/presentation/widgets/bottom_tab.dart';
import 'package:sorted/features/HOME/presentation/widgets/bottom_tab_tile.dart';
import 'package:sorted/features/HOME/presentation/widgets/flexible_safe_area.dart';
import 'package:sorted/features/HOME/presentation/widgets/side_bar.dart';
import 'package:sorted/features/HOME/presentation/widgets/side_tab.dart';
import 'package:sorted/features/HOME/presentation/widgets/side_tab_tile.dart';
import 'package:sorted/features/HOME/presentation/widgets/user_avatar.dart';

import 'package:supercharged/supercharged.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class AnalysisMain extends StatefulWidget {
  AnalysisMain({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AnalysisMainState createState() => _AnalysisMainState();
}

class _AnalysisMainState extends State<AnalysisMain>
    with TickerProviderStateMixin, AnimationMixin {
  

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  ScrollController nestedScrollController;

  final _cameraKey = GlobalKey<CameraScreenState>();

  @override
  void initState() {
    super.initState();
    
  }

  @override
  void dispose() {
    
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        key: _scaffoldKey,
        body: Stack(
          children: [
           
          ],
        ));
  }

  
}
