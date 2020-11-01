import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sorted/core/global/animations/dialog_animation.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/widgets/custom_paints/custom_time_painter.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:sorted/features/HOME/presentation/bloc_affirmation/affirmation_bloc.dart';
import 'package:sorted/features/HOME/presentation/bloc_affirmation_pv/affirmation_pv_bloc.dart';
import 'package:sorted/features/HOME/presentation/pages/camera_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class AffirmationPV extends StatefulWidget {
  const AffirmationPV(
      {Key key, this.affirmations, this.startIndex, this.outerBloc})
      : super(key: key);

  final List<DayAffirmation> affirmations;
  final AffirmationBloc outerBloc;
  final int startIndex;

  @override
  State<StatefulWidget> createState() => AffirmationState(startIndex);
}

class AffirmationState extends State<AffirmationPV>
    with TickerProviderStateMixin {
  PageController controller;
  int timerState = 0; // 0> paused 1>playing
  int currentPage;
  int passedSum = 0, totalSum = 0, remainingSum = 0;
  AffirmationPVBloc bloc;

  var isCameraEnabled = false;
  AnimationController animationController;
  OverlayEntry _popupDialog;
  final _cameraKey = GlobalKey<CameraScreenState>();

  AffirmationState(int startIndex) {
    print("jj");
    controller = PageController(
        viewportFraction: 1.0, initialPage: startIndex, keepPage: false);

    currentPage = startIndex;
  }
  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _indicator(bool isActive, double width) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(vertical: 0.0),
      height: 4.0,
      width: width,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.black45,
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < widget.affirmations.length; i++) {
      list.add(i == currentPage
          ? _indicator(
              true,
              Gparam.width *
                  widget.affirmations[i].waitSeconds.floor() /
                  totalSum)
          : _indicator(
              false,
              Gparam.width *
                  widget.affirmations[i].waitSeconds.floor() /
                  totalSum));
    }
    return list;
  }

  @override
  void initState() {
    bloc = AffirmationPVBloc(sl(), widget.outerBloc)
      ..add(PageChanged(currentPage, widget.affirmations));
    for (int i = 0; i < widget.affirmations.length; i++) {
      totalSum += widget.affirmations[i].waitSeconds;
    }
    print("totlal sum : " + totalSum.toString());

    for (int i = 0; i < currentPage; i++) {
      passedSum += widget.affirmations[i].waitSeconds;
    }
    print("passedSum : " + passedSum.toString());
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: totalSum),
    );
    animationController.addListener(() {
      if (animationController.value == 0) {
        if (mounted)
          setState(() {
            timerState = 0;
            bloc.add(Pause());
            Navigator.pop(context);
          });
      }
      if (1 - animationController.value >
              ((passedSum + widget.affirmations[currentPage].waitSeconds) /
                  totalSum) &&
          timerState == 1) {
        print(1 - animationController.value);
        print(passedSum / totalSum);
        if (controller.hasClients &&
            controller.page != widget.affirmations.length - 1) {
          controller.animateToPage(currentPage + 1,
              duration: Duration(milliseconds: 700), curve: Curves.decelerate);
          //passedSum += widget.affirmations[currentPage].waitSeconds;
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    animationController.dispose();
    super.dispose();
  }

  OverlayEntry _createPopupDialog(String text) {
    return OverlayEntry(
      builder: (context) => AnimatedDialog(
        child: _createPopupContent(text),
      ),
    );
  }

  Widget _createPopupContent(String text) => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Stack(
          children: [
            Center(child: _createCameraTitle(text)),
          ],
        ),
      );

  Widget _createCameraTitle(String text) => Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.all(Radius.circular(20.0)),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 1),
                color: Colors.black.withAlpha(30),
                blurRadius: 20)
          ],
          gradient: new LinearGradient(
              colors: [
                Colors.white54,
                Colors.white.withOpacity(.2),
              ],
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              stops: [1.0, 0.0],
              tileMode: TileMode.clamp),
        ),
        child: Text(text,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black87,
                fontFamily: 'ZillaSlab',
                fontSize: 18,
                shadows: [
                  Shadow(
                    blurRadius: 60.0,
                    color: Colors.white,
                    offset: Offset(1.0, 1.0),
                  ),
                ],
                fontWeight: FontWeight.normal)),
      );

  @override
  Widget build(BuildContext context) {
    return Material(
        child: BlocProvider(
            create: (context) => bloc,
            child: BlocBuilder<AffirmationPVBloc, AffirmationPVState>(
                buildWhen: (previous, current) =>
                    previous.props != current.props,
                builder: (context, state) {
                  if (state is LoadedPVState)
                    return SafeArea(child: new LayoutBuilder(builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return Stack(
                        children: [
                          if (isCameraEnabled)
                            Center(
                              child: Container(
                                height: Gparam.height,
                                width: Gparam.width,
                                child: CameraScreen(
                                  key: _cameraKey,
                                ),
                              ),
                            ),
                          Center(
                              child: PageView.builder(
                                  scrollDirection: Axis.horizontal,
                                  controller: controller,
                                  onPageChanged: (int page) {
                                    currentPage = page;
                                    setState(() {
                                      passedSum = 0;
                                      for (int i = 0; i < currentPage; i++) {
                                        passedSum +=
                                            state.affirmations[i].waitSeconds;
                                        print("passed updated : " +
                                            (passedSum / totalSum).toString());
                                      }
                                    });

                                    if (timerState == 1)
                                      animationController.reverse(
                                          from: animationController.value == 0.0
                                              ? 1.0
                                              : 1 - ((passedSum) / totalSum));
                                    bloc.add(PageChanged(
                                        currentPage, state.affirmations));
                                  },
                                  itemCount: state.affirmations.length,
                                  itemBuilder: (context, position) {
                                    return Stack(
                                      children: [
                                        if (!isCameraEnabled)
                                          Center(
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          0.0),
                                                  child: CachedNetworkImage(
                                                    imageUrl: widget
                                                        .affirmations[position]
                                                        .imageUrl,
                                                    fit: BoxFit.cover,
                                                    height: Gparam.height,
                                                    width: Gparam.width,
                                                  ))),
                                        if (!isCameraEnabled)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 200.0),
                                            child: AnimatedContainer(
                                                alignment: Alignment.center,
                                                curve: Curves.fastOutSlowIn,
                                                margin: EdgeInsets.all(20),
                                                duration:
                                                    Duration(milliseconds: 400),
                                                child: Icon(
                                                  Icons.format_quote,
                                                  color: Colors.black12,
                                                  size: 200,
                                                )),
                                          ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: Gparam.heightPadding * 2,
                                              left: Gparam.widthPadding),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(60.0),
                                              child: FadeInImage(
                                                placeholder: new AssetImage(
                                                    "assets/images/blueCircle.png"),
                                                image: new NetworkImage(widget
                                                    .affirmations[position]
                                                    .thumbnailUrl),
                                                fit: BoxFit.fill,
                                                width: 40,
                                              )),
                                        ),
                                        AnimatedContainer(
                                            alignment: (isCameraEnabled)
                                                ? Alignment.bottomCenter
                                                : Alignment.center,
                                            curve: Curves.easeIn,
                                            padding: EdgeInsets.only(
                                                bottom: (isCameraEnabled)
                                                    ? 120
                                                    : 0),
                                            duration:
                                                Duration(milliseconds: 700),
                                            child: _createPhotoTitle(
                                                widget.affirmations[position])),
                                        if (!isCameraEnabled)
                                          Align(
                                              alignment: Alignment.bottomRight,
                                              child: _createPhotoDescription(
                                                  widget
                                                      .affirmations[position])),
                                      ],
                                    );
                                  })),
                          SafeArea(child: new LayoutBuilder(builder:
                              (BuildContext context,
                                  BoxConstraints constraints) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _buildPageIndicator(),
                            );
                          })),
                          SafeArea(child: new LayoutBuilder(builder:
                              (BuildContext context,
                                  BoxConstraints constraints) {
                            // constraints variable has the size info
                            return Container(
                              width: Gparam.width,
                              height: 4,
                              child: CustomPaint(
                                painter: CustomTimerPainter(
                                  animation: animationController,
                                  backgroundColor: Colors.transparent,
                                  color: Colors.black26,
                                ),
                              ),
                            );
                          })),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: 80.0, left: Gparam.widthPadding),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: AnimatedBuilder(
                                  animation: animationController,
                                  builder: (context, child) {
                                    return FloatingActionButton.extended(
                                        heroTag: "autoPlay",
                                        backgroundColor: Colors.black26,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12))),
                                        elevation: 0,
                                        onPressed: () {
                                          if (animationController.isAnimating) {
                                            animationController.stop();

                                            bloc.add(Pause());

                                            setState(() {
                                              timerState = 0;
                                            });
                                          } else {
                                            passedSum = 0;
                                            for (int i = 0;
                                                i < currentPage;
                                                i++) {
                                              passedSum += widget
                                                  .affirmations[i].waitSeconds;
                                            }
                                            bloc.add(Play());
                                            setState(() {
                                              timerState = 1;
                                            });

                                            animationController.reverse(
                                                from: 1 -
                                                    ((passedSum) / totalSum));
                                          }
                                        },
                                        icon: Icon(
                                            timerState == 1
                                                ? Icons.pause
                                                : Icons.play_arrow,
                                            color: Colors.white),
                                        label: Text(
                                          timerState == 1 ? "Pause" : "Play",
                                          style: TextStyle(color: Colors.white),
                                        ));
                                  }),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: 80.0, right: Gparam.widthPadding),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: AnimatedBuilder(
                                  animation: animationController,
                                  builder: (context, child) {
                                    return FloatingActionButton(
                                      heroTag: "favourite",
                                      backgroundColor: Colors.black26,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12))),
                                      elevation: 0,
                                      onPressed: () {
                                        if (!state
                                            .affirmations[currentPage].isFav) {
                                          bloc.add(AddToFav(
                                              currentPage, state.affirmations));
                                          setState(() {});
                                        } else {
                                          bloc.add(RemoveFromFav(
                                              currentPage, state.affirmations));
                                          setState(() {});
                                        }
                                      },
                                      child: Icon(
                                          state.affirmations[currentPage].isFav
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: Colors.white),
                                    );
                                  }),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding:
                                  EdgeInsets.only(top: Gparam.heightPadding),
                              child: AnimatedContainer(
                                width: Gparam.width / 2.5,
                                height: Gparam.height / 20,
                                decoration: BoxDecoration(
                                  borderRadius: new BorderRadius.all(
                                      Radius.circular(10.0)),
                                  gradient: new LinearGradient(
                                      colors: [
                                        Colors.black12,
                                        Colors.black26,
                                      ],
                                      begin: FractionalOffset.topCenter,
                                      end: FractionalOffset.bottomCenter,
                                      stops: [1.0, 0.0],
                                      tileMode: TileMode.clamp),
                                ),
                                alignment: Alignment.topRight,
                                curve: Curves.fastOutSlowIn,
                                margin: EdgeInsets.all(20),
                                duration: Duration(milliseconds: 400),
                                child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        isCameraEnabled = !isCameraEnabled;
                                      });
                                      if (isCameraEnabled) {
                                        _popupDialog = _createPopupDialog(
                                            "Powerful affirmations are those you say out loud when you are in front of your mirror\nMirror reflects back to you the feelings you have about yourself.");
                                        Overlay.of(context)
                                            .insert(_popupDialog);
                                        Future.delayed(
                                            const Duration(seconds: 5),
                                            () => "1").then((value) {
                                          _popupDialog?.remove();
                                        });
                                      }
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Icon(
                                              isCameraEnabled
                                                  ? Icons.arrow_back
                                                  : Icons.camera_front,
                                              color: Colors.white70,
                                              size: Gparam.height / 30,
                                            ),
                                            Text(
                                                isCameraEnabled
                                                    ? "Image View"
                                                    : "Mirror View",
                                                style: TextStyle(
                                                    color: Colors.white
                                                        .withAlpha(220),
                                                    fontFamily: 'Eastman',
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ],
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                          ),
                        ],
                      );
                    }));
                  else if (state is LoadingPVState) {}
                })));
  }

  Widget _createPhotoTitle(DayAffirmation affirmation) => Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.all(16),
        child: Stack(
          children: [
            Text(affirmation.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white.withAlpha(230),
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    height: 1.4,
                    shadows: [
                      Shadow(
                        blurRadius: 5.0,
                        color: Colors.black45,
                        offset: Offset(0.0, 0.0),
                      ),
                    ],
                    fontWeight: FontWeight.w800)),
            Text(affirmation.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white.withAlpha(230),
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    height: 1.4,
                    shadows: [
                      Shadow(
                        blurRadius: 5.0,
                        color: Colors.black87,
                        offset: Offset(0.0, 0.0),
                      ),
                    ],
                    fontWeight: FontWeight.w800)),
          ],
        ),
      );
  Widget _createPhotoDescription(DayAffirmation affirmation) => GestureDetector(
        onTap: () {
          launchURL(affirmation.profileLink);
        },
        child: Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: new BorderRadius.all(Radius.circular(20.0)),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 1),
                  color: Colors.black.withAlpha(30),
                  blurRadius: 20)
            ],
          ),
          child:
              Text("Image by ${affirmation.photoGrapherName} on Unsplash.com",
                  style: TextStyle(
                      color: Colors.white60,
                      fontFamily: 'ZillaSlab',
                      fontSize: 14,
                      shadows: [
                        Shadow(
                          blurRadius: 60.0,
                          color: Colors.white,
                          offset: Offset(1.0, 1.0),
                        ),
                      ],
                      fontWeight: FontWeight.normal)),
        ),
      );
}
