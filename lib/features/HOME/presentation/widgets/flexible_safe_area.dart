import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/animations/dialog_animation.dart';
import 'package:sorted/core/global/animations/fade_animationTB.dart';
import 'package:sorted/core/global/animations/shimmer.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/routes/router.gr.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:sorted/features/HOME/presentation/bloc_affirmation/affirmation_bloc.dart';
import 'package:sorted/features/HOME/presentation/pages/homePage.dart';

class FlexibleSpaceArea extends StatefulWidget {
  const FlexibleSpaceArea({
    Key key,
    @required this.currentSliverheight,
    @required this.name,
  }) : super(key: key);

  final double currentSliverheight;

  final String name;

  @override
  State<StatefulWidget> createState() => _FlexibleAreaState();
}

class _FlexibleAreaState extends State<FlexibleSpaceArea> {
  OverlayEntry _popupDialog;
  ScrollController _controller;
  AffirmationBloc affirmationBloc;
  bool showArrow = true;
  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

  @override
  void initState() {
    _controller = ScrollController();
    affirmationBloc = AffirmationBloc(sl())..add(LoadStories());
    _controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
        title: (widget.currentSliverheight <Gparam.height/4)
            ? Text(
                'My feed',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: 'ZillaSlab',
                  fontSize:18.0,
                  fontWeight: FontWeight.w600,
                ),
              )
            : Text(
                '',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: 'ZillaSlab',
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
        background: Container(
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(45.0)),
            gradient: new LinearGradient(
                colors: [
                  Theme.of(context).backgroundColor,
                  Theme.of(context).primaryColor,
                ],
                stops: [
                  0.2,
                  0.9
                ],
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                tileMode: TileMode.clamp),
          ),
          padding: EdgeInsets.only(
            top: Gparam.topPadding,
          ),
          child: FadeAnimationTB(
              1.6,
              Container(
                  child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Icon(
                      OMIcons.dashboard,
                      color: Theme.of(context).cardColor.withOpacity(.04),
                      size: Gparam.width / 1.4,
                    ),
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        
                        
                        BlocProvider(
                            create: (_) =>
                                affirmationBloc,
                            child: BlocListener<AffirmationBloc,
                                    AffirmationState>(
                                listener: (context, state) {},
                                child: BlocBuilder<AffirmationBloc,
                                        AffirmationState>(
                                    builder: (context, state) {
                                  if (state is LoadingState) {
                                    return Stack(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                                height: Gparam.height / 8,
                                            width: 5.4 * Gparam.width / 6,
                                            decoration: new BoxDecoration(
                                              
                                              borderRadius:
                                                  new BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20.0),
                                                      bottomLeft:
                                                          Radius.circular(
                                                              20.0)),
                                              
                                            ),
                                            margin: EdgeInsets.only(
                                                top: 0, left: 0),
                                                child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  physics:
                                                      BouncingScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: 6,
                                                  itemBuilder:
                                                      (BuildContext contect,
                                                          int index) {
                                                    if (index == 0) {
                                                      return SizedBox(
                                                          width: Gparam
                                                                  .widthPadding /
                                                              3);
                                                    }
                                                    return Shimmer(
                                                      period: Duration(
                                                          milliseconds: 1600),
                                                      gradient: LinearGradient(
                                                        begin:
                                                            Alignment.topLeft,
                                                        end: Alignment
                                                            .centerRight,
                                                        colors: [
                                                          Colors.grey[200],
                                                          Colors.grey[200],
                                                          Colors.grey[350],
                                                          Colors.grey[200],
                                                          Colors.grey[200]
                                                        ],
                                                        stops: const [
                                                          0.0,
                                                          0.35,
                                                          0.5,
                                                          0.65,
                                                          1.0
                                                        ],
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            height: Gparam.height / 18,
                  width: Gparam.height / 18,
                  margin: EdgeInsets.only(left:8,right:8),
                                                            decoration:
                                                                new BoxDecoration(
                                                              borderRadius:
                                                                  new BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          60.0)),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    offset:
                                                                        Offset(
                                                                            0,
                                                                            1),
                                                                    color: Colors
                                                                        .black
                                                                        .withAlpha(
                                                                            80),
                                                                    blurRadius:
                                                                        4)
                                                              ],
                                                              gradient:
                                                                  new LinearGradient(
                                                                      colors: [
                                                                        Colors
                                                                            .white,
                                                                        Colors
                                                                            .white,
                                                                      ],
                                                                      begin: FractionalOffset
                                                                          .topCenter,
                                                                      end: FractionalOffset
                                                                          .bottomCenter,
                                                                      stops: [
                                                                        1.0,
                                                                        0.0
                                                                      ],
                                                                      tileMode:
                                                                          TileMode
                                                                              .clamp),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                )),
                                          ],
                                        ),
                                      ],
                                    );
                                  } else if (state is Error) {
                                    return Container(
                                      width: 0,
                                      height: 0,
                                    );
                                  } else if (state is LoadedState) {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                            height: Gparam.height / 8,
                                            width: Gparam.width,
                                            decoration: new BoxDecoration(
                                              
                                              borderRadius:
                                                  new BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20.0),
                                                      bottomLeft:
                                                          Radius.circular(
                                                              20.0)),
                                              
                                            ),
                                            margin: EdgeInsets.only(
                                                top: 0, left: 0),
                                            child: Stack(
                                              children: [
                                              
                                                Row(
                                                  children: [
                                                      Padding(
                                                padding:EdgeInsets.only(
                                                  left:Gparam.width/7,right:12),
                                                child: Icon(
                                                  Icons.wb_sunny,color: Colors.black12,size:16,
                                                ),
                                                  ),
                                                    Text(
                                                      "MORNING AFFIRMATIONS",
                                                      style: TextStyle(
                                                          color: (Theme.of(context).brightness==Brightness.light)?Colors.white.withOpacity(.2):Colors.black26,
                                                          fontFamily: 'Eastman',
                                                          
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.normal),
                                                    ),
                                                  ],
                                                ),
                                                ListView.builder(
                                                    padding: EdgeInsets.only(
                                                        top: Gparam
                                                                .heightPadding ),
                                                    controller: _controller,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    physics:
                                                        BouncingScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: state
                                                            .affirmations
                                                            .length +
                                                        1,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      if (index == 0)
                                                        return SizedBox(
                                                          width: Gparam.width/7,
                                                        );
                                                      return buildAffirmationTile(
                                                          index - 1,
                                                          state.affirmations[
                                                              index - 1]);
                                                    }),
                                                if (showArrow)
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.only(
                                                            top: Gparam.heightPadding*1.5),
                                                    child: Align(
                                                        alignment: Alignment
                                                            .topRight,
                                                        child: Shimmer(
                                                            period: Duration(
                                                                milliseconds:
                                                                    1600),
                                                            gradient:
                                                                LinearGradient(
                                                              begin: Alignment
                                                                  .topLeft,
                                                              end: Alignment
                                                                  .centerRight,
                                                              colors: [
                                                                Colors
                                                                    .grey[200],
                                                                Colors
                                                                    .grey[200],
                                                                Colors
                                                                    .grey[850],
                                                                Colors
                                                                    .grey[200],
                                                                Colors.grey[200]
                                                              ],
                                                              stops: const [
                                                                0.0,
                                                                0.35,
                                                                0.5,
                                                                0.65,
                                                                1.0
                                                              ],
                                                            ),
                                                            child: Icon(
                                                                OMIcons.arrowRight,
                                                                size: 40,
                                                                color: Colors
                                                                    .white70))),
                                                  ),
                                              ],
                                            )),
                                      ],
                                    );
                                  }
                                }))),
                       Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: Gparam.width / 6),
                              child: RichText(
                                text: TextSpan(
                                  text: greeting(),
                                  style: TextStyle(
                                      fontFamily: 'ZillaSlab',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: (Theme.of(context).brightness==Brightness.light)?Colors.white60:Colors.black54),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: "  " + widget.name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),       
                      ]),
                ],
              ))),
        ));
  }

  OverlayEntry _createPopupDialog(DayAffirmation affirmation) {
    return OverlayEntry(
      builder: (context) => AnimatedDialog(
        child: _createPopupContent(affirmation),
      ),
    );
  }

  Widget _createPopupContent(DayAffirmation affirmation) => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Stack(
          children: [
            Center(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.network(
                      affirmation.imageUrl,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                            child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes
                              : null,
                        ));
                      },
                      fit: BoxFit.cover,
                      height: Gparam.width,
                      width: Gparam.width,
                    ))),
            Center(child: _createPhotoTitle(affirmation)),
            Align(
                alignment: Alignment.bottomRight,
                child: _createPhotoDescription(affirmation)),
          ],
        ),
      );

  Widget _createPhotoTitle(DayAffirmation affirmation) => Container(
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
        child: Text(affirmation.text,
            style: TextStyle(
                color: Colors.black87,
                fontFamily: 'ZillaSlab',
                fontSize: 24,
                shadows: [
                  Shadow(
                    blurRadius: 60.0,
                    color: Colors.white,
                    offset: Offset(1.0, 1.0),
                  ),
                ],
                fontWeight: FontWeight.normal)),
      );
  Widget _createPhotoDescription(DayAffirmation affirmation) => Container(
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
        child: Text("Image by Unsplash.com",
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
      );

  Widget buildAffirmationTile(int index, DayAffirmation affirmation) {
    return GestureDetector(
          // keep the OverlayEntry instance, and insert it into Overlay
          onLongPress: () {
            print(affirmation.imageUrl);
            _popupDialog = _createPopupDialog(affirmation);
            Overlay.of(context).insert(_popupDialog);
          },
          // remove the OverlayEntry from Overlay, so it would be hidden
          onLongPressEnd: (details) => _popupDialog?.remove(),
          onTap: () {
            Router.navigator.pushNamed(Router.affirmationPageview,
                arguments: AffirmationPVArguments(
                    affirmations: (affirmationBloc.state
                            as LoadedState)
                        .affirmations,
                    startIndex: index,outerBloc:affirmationBloc ));
          },
          child: Hero(
          tag: "thumbnail"+index.toString(),
          child: Column(
            children: [
              Container(
                  height: Gparam.height / 18,
                  width: Gparam.height / 18,
                  margin: EdgeInsets.all(8),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.all(Radius.circular(60.0)),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(1, 1),
                          color: Colors.black.withAlpha(40),
                          blurRadius: 10)
                    ],
                    gradient: new LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                        ],
                        begin: FractionalOffset.topCenter,
                        end: FractionalOffset.bottomCenter,
                        stops: [1.0, 0.0],
                        tileMode: TileMode.clamp),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ColorFiltered(
                          colorFilter: ColorFilter.mode(
                              Theme.of(context).backgroundColor,
                              (affirmation.read)
                                  ? BlendMode.modulate
                                  : BlendMode.dst),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(60.0),
                              child: FadeInImage(
                                placeholder: new AssetImage(
                                    "assets/images/blueCircle.png"),
                                image: new NetworkImage(affirmation.sImageUrl),
                                fit: BoxFit.cover,
                                height: Gparam.height / 18,
                                width: Gparam.height / 18,
                              ))),
                    ],
                  )),
            ],
          )),
    );
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        showArrow = false;
      });
    }
  }
}
