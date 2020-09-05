import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sorted/core/global/models/user_details.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/constants.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/flow_bloc/flow_bloc.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/widgets/stackContainerBack.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/widgets/stackContainerFront.dart';

class InteractionPage extends StatefulWidget {
  const InteractionPage(
      {Key key, this.oldState, this.userDetail, this.progress})
      : super(key: key);

  final bool oldState;
  final UserDetail userDetail;
  final double progress;

  @override
  _InteractionPageState createState() => _InteractionPageState();
}

class _InteractionPageState extends State<InteractionPage>
    with TickerProviderStateMixin {
  final controller = TextEditingController();
  double greetingOpacity = 1;
  double downloadingOpacity = 0;
  Alignment imageAlignment = Alignment.center;
  Animation<double> positionAnimation;
  AnimationController positionController;
  Animation<double> scaleAnimation;
  AnimationController scaleController;

  int _startDownloadTimer = 1;
  int _startToLoginTimer = 1;
  Timer _downloadStartTimer, _goToLoginStateTimer;

  String currentItemInDownload = "";

  @override
  void dispose() {
    if (_downloadStartTimer != null) _downloadStartTimer.cancel();
    if (_goToLoginStateTimer != null) _downloadStartTimer.cancel();
    if (scaleController != null) scaleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    startDownloadTimer();
    setScaleAnimation();
  }

  @override
  void didUpdateWidget(InteractionPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.progress < .1) {
      currentItemInDownload = UserIntroStrings.elements[0];
    } else if (widget.progress < .2) {
      currentItemInDownload = UserIntroStrings.elements[1];
    } else if (widget.progress < .3) {
      currentItemInDownload = UserIntroStrings.elements[2];
    } else if (widget.progress < .4) {
      currentItemInDownload = UserIntroStrings.elements[3];
    } else if (widget.progress < .5) {
      currentItemInDownload = UserIntroStrings.elements[4];
    } else if (widget.progress < .8) {
      currentItemInDownload = UserIntroStrings.elements[5];
    }
    if (widget.progress == 1) {
      print("didUpdateWidget");
      currentItemInDownload = "COMPLETED";
      BlocProvider.of<UserIntroductionBloc>(context).add(EndDownload());
    }
  }

  void startDownloadTimer() {
    const oneSec = const Duration(seconds: 1);
    _downloadStartTimer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_startDownloadTimer < 1) {
            doAfterDownloadStartTimer();
            timer.cancel();
          } else {
            _startDownloadTimer = _startDownloadTimer - 1;
          }
        },
      ),
    );
  }

  void doAfterDownloadStartTimer() {
    imageAlignment = Alignment.topCenter;
    greetingOpacity = 0;
    downloadingOpacity = 1;
    scaleController.forward();
    BlocProvider.of<UserIntroductionBloc>(context).add(StartDownload());
  }

  void goToLoginTimerStarter() {
    const oneSec = const Duration(seconds: 1);
    _goToLoginStateTimer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_startToLoginTimer < 1) {
            timer.cancel();
          } else {
            _startToLoginTimer = _startToLoginTimer - 1;
          }
        },
      ),
    );
  }

  void setScaleAnimation() {
    scaleController =
        AnimationController(vsync: this, duration: Duration(seconds: 3))
          ..addStatusListener((status) async {
            if (status == AnimationStatus.completed) {
              //Todo: add event to start download

            }
          });
    scaleAnimation = Tween<double>(begin: 1.0, end: 1.8).animate(
        CurvedAnimation(curve: Curves.easeInOutQuart, parent: scaleController));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          StackConatinerBack(
              imageAlignment: imageAlignment,
              scaleAnimation: scaleAnimation,
              greetingOpacity: greetingOpacity,
              widget: widget),
          StackContainerFront(
            downloadingOpacity: downloadingOpacity,
            widget: widget,
            currentItemInDownload: currentItemInDownload,
          ),
        ],
      ),
    );
  }
}
