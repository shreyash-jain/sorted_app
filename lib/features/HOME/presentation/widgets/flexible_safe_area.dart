import 'package:cached_network_image/cached_network_image.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/animations/dialog_animation.dart';
import 'package:sorted/core/global/animations/fade_animationTB.dart';
import 'package:sorted/core/global/animations/shimmer.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/widgets/UnicornOutlineButton.dart';
import 'package:sorted/core/routes/router.gr.dart' as rt;
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:sorted/features/HOME/presentation/bloc_affirmation/affirmation_bloc.dart';
import 'package:sorted/features/HOME/presentation/pages/homePage.dart';
import 'package:sorted/features/HOME/presentation/widgets/loaded_affirmation.dart';
import 'package:sorted/features/HOME/presentation/widgets/loading_affirmations.dart';

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

  @override
  void initState() {
    _controller = ScrollController();
    affirmationBloc = sl<AffirmationBloc>();

    _controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
        title: (widget.currentSliverheight < Gparam.height / 4)
            ? Text(
                '',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14.0,
                  color: Theme.of(context).highlightColor,
                  fontWeight: FontWeight.w600,
                ),
              )
            : Text(
                '',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
        background: Container(
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(45.0)),
            gradient: new LinearGradient(
                colors: [
                  Theme.of(context).scaffoldBackgroundColor,
                  Theme.of(context).scaffoldBackgroundColor,
                ],
                stops: [
                  0.2,
                  0.8
                ],
                begin: FractionalOffset.topRight,
                end: FractionalOffset.bottomCenter,
                tileMode: TileMode.clamp),
          ),
          padding: EdgeInsets.only(
            top: Gparam.topPadding / 3,
          ),
          child: FadeAnimationTB(
              1.6,
              Container(
                  child: Stack(
                children: <Widget>[
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: Gparam.width,
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: Gparam.widthPadding),
                              child: Text(
                                "Sort.it",
                                style: TextStyle(
                                    color: Theme.of(context).highlightColor,
                                    fontFamily: 'Montserrat',
                                    fontSize: Gparam.textSmall,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                          ],
                        ),
                        Container(
                            height: 130,
                            width: Gparam.width,
                            margin: EdgeInsets.only(top: 20),
                            child: ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: [
                                SizedBox(
                                  width: Gparam.widthPadding / 2,
                                ),
                                Column(
                                  children: [
                                    UnicornOutlineButton(
                                      strokeWidth: 2,
                                      radius: 100,
                                      gradient: LinearGradient(
                                        colors: [
                                          Theme.of(context).primaryColor,
                                          Theme.of(context).primaryColorLight,
                                          Theme.of(context).accentColor,
                                          Theme.of(context).backgroundColor
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      onPressed: () {
                                        rt.Router.navigator.pushNamed(
                                            rt.Router.challengePageView);
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                              height: 70,
                                              width: 70,
                                              margin: EdgeInsets.all(2),
                                              decoration: new BoxDecoration(
                                                borderRadius:
                                                    new BorderRadius.all(
                                                        Radius.circular(60.0)),
                                                border: null,
                                                boxShadow: [
                                                  BoxShadow(
                                                      offset: Offset(1, 1),
                                                      color: Colors.black
                                                          .withAlpha(40),
                                                      blurRadius: 10)
                                                ],
                                                gradient: new LinearGradient(
                                                    colors: [
                                                      Colors.transparent,
                                                      Colors.transparent,
                                                    ],
                                                    begin: FractionalOffset
                                                        .topCenter,
                                                    end: FractionalOffset
                                                        .bottomCenter,
                                                    stops: [1.0, 0.0],
                                                    tileMode: TileMode.clamp),
                                              ),
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              60.0),
                                                      child: CachedNetworkImage(
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(
                                                          Icons.error,
                                                          color: Colors.grey,
                                                        ),
                                                        imageUrl:
                                                            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/home%2Fcristina-zaragoza-cMVRsfY8R3Q-unsplash.jpg?alt=media&token=95af0462-1040-409b-973b-384fba7662be",
                                                        fit: BoxFit.cover,
                                                        height: 70,
                                                        width: 70,
                                                      )),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Todays\nChallenge",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              letterSpacing: -.3,
                                              fontFamily: 'Montserrat',
                                              fontSize: Gparam.textExtraSmall,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Column(
                                  children: [
                                    UnicornOutlineButton(
                                      strokeWidth: 2,
                                      radius: 100,
                                      gradient: LinearGradient(
                                        colors: [
                                          Theme.of(context).primaryColor,
                                          Theme.of(context).primaryColorLight,
                                          Theme.of(context).accentColor,
                                          Theme.of(context).backgroundColor
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      onPressed: () {},
                                      child: Column(
                                        children: [
                                          Container(
                                              height: 70,
                                              width: 70,
                                              margin: EdgeInsets.all(2),
                                              decoration: new BoxDecoration(
                                                borderRadius:
                                                    new BorderRadius.all(
                                                        Radius.circular(60.0)),
                                                border: null,
                                                boxShadow: [
                                                  BoxShadow(
                                                      offset: Offset(1, 1),
                                                      color: Colors.black
                                                          .withAlpha(40),
                                                      blurRadius: 10)
                                                ],
                                                gradient: new LinearGradient(
                                                    colors: [
                                                      Colors.transparent,
                                                      Colors.transparent,
                                                    ],
                                                    begin: FractionalOffset
                                                        .topCenter,
                                                    end: FractionalOffset
                                                        .bottomCenter,
                                                    stops: [1.0, 0.0],
                                                    tileMode: TileMode.clamp),
                                              ),
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              60.0),
                                                      child: CachedNetworkImage(
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(
                                                          Icons.error,
                                                          color: Colors.grey,
                                                        ),
                                                        imageUrl:
                                                            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/home%2Fmarkus-winkler-OQ48N5FDW1w-unsplash.jpg?alt=media&token=76daf5cd-0df7-46d3-a742-7a8bd170fc5c",
                                                        fit: BoxFit.cover,
                                                        height: 70,
                                                        width: 70,
                                                      )),
                                                  Stack(
                                                    children: [],
                                                  ),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Plan Today",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              letterSpacing: -.3,
                                              fontFamily: 'Montserrat',
                                              fontSize: Gparam.textExtraSmall,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Column(
                                  children: [
                                    BlocProvider(
                                        create: (_) => affirmationBloc,
                                        child:
                                            BlocListener<AffirmationBloc,
                                                    AffirmationState>(
                                                listener: (context, state) {},
                                                child: BlocBuilder<
                                                        AffirmationBloc,
                                                        AffirmationState>(
                                                    builder: (context, state) {
                                                  if (state is InitialState) {
                                                    return GestureDetector(
                                                      onTap: () async {
                                                        print("heeeeeelo");
                                                        //print(affirmationBloc);

                                                        BlocProvider.of<
                                                                    AffirmationBloc>(
                                                                context)
                                                            .add(LoadStories());

                                                        print("heeeeeelo1");
                                                      },
                                                      child:
                                                          UnicornOutlineButton(
                                                        strokeWidth: 2,
                                                        radius: 100,
                                                        gradient:
                                                            LinearGradient(
                                                          colors: [
                                                            Theme.of(context)
                                                                .primaryColor,
                                                            Theme.of(context)
                                                                .primaryColorLight,
                                                            Theme.of(context)
                                                                .accentColor,
                                                            Theme.of(context)
                                                                .backgroundColor
                                                          ],
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .bottomCenter,
                                                        ),
                                                        onPressed: null,
                                                        child: Hero(
                                                            tag: "thumbnail" +
                                                                0.toString(),
                                                            child: Stack(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              children: [
                                                                Container(
                                                                    height: 70,
                                                                    width: 70,
                                                                    margin: EdgeInsets
                                                                        .all(2),
                                                                    decoration:
                                                                        new BoxDecoration(
                                                                      borderRadius: new BorderRadius
                                                                              .all(
                                                                          Radius.circular(
                                                                              60.0)),
                                                                      border:
                                                                          null,
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                            offset: Offset(1,
                                                                                1),
                                                                            color:
                                                                                Colors.black.withAlpha(40),
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
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(60.0),
                                                                            child: CachedNetworkImage(
                                                                              imageUrl: "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/home%2Faffirmation.jpg?alt=media&token=a5e30e61-4501-4479-8223-fab5080a6f25",
                                                                              fit: BoxFit.cover,
                                                                              height: 70,
                                                                              width: 70,
                                                                              errorWidget: (context, url, error) => Icon(
                                                                                Icons.error,
                                                                                color: Colors.grey,
                                                                              ),
                                                                            )),
                                                                      ],
                                                                    )),
                                                                Text("Initial")
                                                              ],
                                                            )),
                                                      ),
                                                    );
                                                  } else if (state
                                                      is LoadingState) {
                                                    return UnicornOutlineButton(
                                                        strokeWidth: 2,
                                                        radius: 100,
                                                        gradient:
                                                            LinearGradient(
                                                          colors: [
                                                            Theme.of(context)
                                                                .primaryColor,
                                                            Theme.of(context)
                                                                .primaryColorLight,
                                                            Theme.of(context)
                                                                .accentColor,
                                                            Theme.of(context)
                                                                .backgroundColor
                                                          ],
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .bottomCenter,
                                                        ),
                                                        onPressed: null,
                                                        child: Stack(
                                                          alignment:
                                                              Alignment.center,
                                                          children: [
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Container(
                                                                    height: 70,
                                                                    width: 70,
                                                                    margin: EdgeInsets
                                                                        .all(2),
                                                                    decoration:
                                                                        new BoxDecoration(
                                                                      borderRadius: new BorderRadius
                                                                              .all(
                                                                          Radius.circular(
                                                                              60.0)),
                                                                      border:
                                                                          null,
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                            offset: Offset(1,
                                                                                1),
                                                                            color:
                                                                                Colors.black.withAlpha(40),
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
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(60.0),
                                                                            child: CachedNetworkImage(
                                                                              imageUrl: "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/home%2Faffirmation.jpg?alt=media&token=a5e30e61-4501-4479-8223-fab5080a6f25",
                                                                              fit: BoxFit.cover,
                                                                              height: 70,
                                                                              width: 70,
                                                                              errorWidget: (context, url, error) => Icon(
                                                                                Icons.error,
                                                                                color: Colors.grey,
                                                                              ),
                                                                            )),
                                                                      ],
                                                                    )),
                                                              ],
                                                            ),
                                                            Container(
                                                              height: 70,
                                                              width: 70,
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            ),
                                                            Text("Loading")
                                                          ],
                                                        ));
                                                  } else if (state is Error) {
                                                    return Container(
                                                      width: 0,
                                                      height: 0,
                                                    );
                                                  } else if (state
                                                      is LoadedState) {
                                                    return UnicornOutlineButton(
                                                      strokeWidth: 2,
                                                      radius: 100,
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Theme.of(context)
                                                              .primaryColor,
                                                          Theme.of(context)
                                                              .primaryColorLight,
                                                          Theme.of(context)
                                                              .accentColor,
                                                          Theme.of(context)
                                                              .backgroundColor
                                                        ],
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter,
                                                      ),
                                                      onPressed: () {
                                                        rt.Router.navigator.pushNamed(
                                                            rt.Router
                                                                .affirmationPageview,
                                                            arguments: rt.AffirmationPVArguments(
                                                                affirmations: (affirmationBloc
                                                                            .state
                                                                        as LoadedState)
                                                                    .affirmations,
                                                                startIndex: 0,
                                                                outerBloc:
                                                                    affirmationBloc));
                                                      },
                                                      child: Hero(
                                                          tag: "thumbnail" +
                                                              0.toString(),
                                                          child: Stack(
                                                            alignment: Alignment
                                                                .center,
                                                            children: [
                                                              Container(
                                                                  height: 70,
                                                                  width: 70,
                                                                  margin:
                                                                      EdgeInsets
                                                                          .all(
                                                                              2),
                                                                  decoration:
                                                                      new BoxDecoration(
                                                                    borderRadius: new BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            60.0)),
                                                                    border:
                                                                        null,
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                          offset: Offset(
                                                                              1,
                                                                              1),
                                                                          color: Colors.black.withAlpha(
                                                                              40),
                                                                          blurRadius:
                                                                              10)
                                                                    ],
                                                                    gradient: new LinearGradient(
                                                                        colors: [
                                                                          Colors
                                                                              .transparent,
                                                                          Colors
                                                                              .transparent,
                                                                        ],
                                                                        begin: FractionalOffset.topCenter,
                                                                        end: FractionalOffset.bottomCenter,
                                                                        stops: [1.0, 0.0],
                                                                        tileMode: TileMode.clamp),
                                                                  ),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      ClipRRect(
                                                                          borderRadius: BorderRadius.circular(
                                                                              60.0),
                                                                          child:
                                                                              CachedNetworkImage(
                                                                            imageUrl:
                                                                                "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/home%2Faffirmation.jpg?alt=media&token=a5e30e61-4501-4479-8223-fab5080a6f25",
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            height:
                                                                                70,
                                                                            errorWidget: (context, url, error) =>
                                                                                Icon(
                                                                              Icons.error,
                                                                              color: Colors.grey,
                                                                            ),
                                                                            width:
                                                                                70,
                                                                          )),
                                                                    ],
                                                                  )),
                                                              Text("Loaded")
                                                            ],
                                                          )),
                                                    );
                                                  }
                                                }))),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          getAffirmationString(DateTime.now()),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              letterSpacing: -.3,
                                              fontFamily: 'Montserrat',
                                              fontSize: Gparam.textExtraSmall,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Column(
                                  children: [
                                    UnicornOutlineButton(
                                      strokeWidth: 2,
                                      radius: 100,
                                      gradient: LinearGradient(
                                        colors: [
                                          Theme.of(context).primaryColor,
                                          Theme.of(context).primaryColorLight,
                                          Theme.of(context).accentColor,
                                          Theme.of(context).backgroundColor
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      onPressed: () {},
                                      child: Column(
                                        children: [
                                          Container(
                                              height: 70,
                                              width: 70,
                                              margin: EdgeInsets.all(2),
                                              decoration: new BoxDecoration(
                                                borderRadius:
                                                    new BorderRadius.all(
                                                        Radius.circular(60.0)),
                                                border: null,
                                                boxShadow: [
                                                  BoxShadow(
                                                      offset: Offset(1, 1),
                                                      color: Colors.black
                                                          .withAlpha(40),
                                                      blurRadius: 10)
                                                ],
                                                gradient: new LinearGradient(
                                                    colors: [
                                                      Colors.transparent,
                                                      Colors.transparent,
                                                    ],
                                                    begin: FractionalOffset
                                                        .topCenter,
                                                    end: FractionalOffset
                                                        .bottomCenter,
                                                    stops: [1.0, 0.0],
                                                    tileMode: TileMode.clamp),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              60.0),
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/home%2Fzac-durant-_6HzPU9Hyfg-unsplash.jpg?alt=media&token=6de62955-2fd1-4a1e-94e4-6fa8256219a2",
                                                        fit: BoxFit.cover,
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(
                                                          Icons.error,
                                                          color: Colors.grey,
                                                        ),
                                                        height: 70,
                                                        width: 70,
                                                      )),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          getMeditationString(DateTime.now()),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              letterSpacing: -.3,
                                              fontFamily: 'Montserrat',
                                              fontSize: Gparam.textExtraSmall,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Column(
                                  children: [
                                    UnicornOutlineButton(
                                      strokeWidth: 2,
                                      radius: 100,
                                      gradient: LinearGradient(
                                        colors: [
                                          Theme.of(context).primaryColor,
                                          Theme.of(context).primaryColorLight,
                                          Theme.of(context).accentColor,
                                          Theme.of(context).backgroundColor
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      onPressed: () {},
                                      child: Column(
                                        children: [
                                          Container(
                                              height: 70,
                                              width: 70,
                                              margin: EdgeInsets.all(2),
                                              decoration: new BoxDecoration(
                                                borderRadius:
                                                    new BorderRadius.all(
                                                        Radius.circular(60.0)),
                                                border: null,
                                                boxShadow: [
                                                  BoxShadow(
                                                      offset: Offset(1, 1),
                                                      color: Colors.black
                                                          .withAlpha(40),
                                                      blurRadius: 10)
                                                ],
                                                gradient: new LinearGradient(
                                                    colors: [
                                                      Colors.transparent,
                                                      Colors.transparent,
                                                    ],
                                                    begin: FractionalOffset
                                                        .topCenter,
                                                    end: FractionalOffset
                                                        .bottomCenter,
                                                    stops: [1.0, 0.0],
                                                    tileMode: TileMode.clamp),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              60.0),
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/home%2Fdane-wetton-t1NEMSm1rgI-unsplash.jpg?alt=media&token=3fc63268-3ae0-46ec-ad66-1817016e063e",
                                                        fit: BoxFit.cover,
                                                        height: 70,
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(
                                                          Icons.error,
                                                          color: Colors.grey,
                                                        ),
                                                        width: 70,
                                                      )),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Quick\nYoga",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              letterSpacing: -.3,
                                              fontFamily: 'Montserrat',
                                              fontSize: Gparam.textExtraSmall,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Column(
                                  children: [
                                    UnicornOutlineButton(
                                      strokeWidth: 2,
                                      radius: 100,
                                      gradient: LinearGradient(
                                        colors: [
                                          Theme.of(context).primaryColor,
                                          Theme.of(context).primaryColorLight,
                                          Theme.of(context).accentColor,
                                          Theme.of(context).backgroundColor
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      onPressed: () {},
                                      child: Column(
                                        children: [
                                          Container(
                                              height: 70,
                                              width: 70,
                                              margin: EdgeInsets.all(2),
                                              decoration: new BoxDecoration(
                                                borderRadius:
                                                    new BorderRadius.all(
                                                        Radius.circular(60.0)),
                                                border: null,
                                                boxShadow: [
                                                  BoxShadow(
                                                      offset: Offset(1, 1),
                                                      color: Colors.black
                                                          .withAlpha(40),
                                                      blurRadius: 10)
                                                ],
                                                gradient: new LinearGradient(
                                                    colors: [
                                                      Colors.transparent,
                                                      Colors.transparent,
                                                    ],
                                                    begin: FractionalOffset
                                                        .topCenter,
                                                    end: FractionalOffset
                                                        .bottomCenter,
                                                    stops: [1.0, 0.0],
                                                    tileMode: TileMode.clamp),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              60.0),
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/home%2Fbruno-nascimento-PHIgYUGQPvU-unsplash.jpg?alt=media&token=ed7a6e91-d275-4748-8608-06e4136faaee",
                                                        fit: BoxFit.cover,
                                                        height: 70,
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(
                                                          Icons.error,
                                                          color: Colors.grey,
                                                        ),
                                                        width: 70,
                                                      )),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Flash\nFitness",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              letterSpacing: -.3,
                                              fontFamily: 'Montserrat',
                                              fontSize: Gparam.textExtraSmall,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Column(
                                  children: [
                                    UnicornOutlineButton(
                                      strokeWidth: 2,
                                      radius: 100,
                                      gradient: LinearGradient(
                                        colors: [
                                          Theme.of(context).primaryColor,
                                          Theme.of(context).primaryColorLight,
                                          Theme.of(context).accentColor,
                                          Theme.of(context).backgroundColor
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      onPressed: () {},
                                      child: Column(
                                        children: [
                                          Container(
                                              height: 70,
                                              width: 70,
                                              margin: EdgeInsets.all(2),
                                              decoration: new BoxDecoration(
                                                borderRadius:
                                                    new BorderRadius.all(
                                                        Radius.circular(60.0)),
                                                border: null,
                                                boxShadow: [
                                                  BoxShadow(
                                                      offset: Offset(1, 1),
                                                      color: Colors.black
                                                          .withAlpha(40),
                                                      blurRadius: 10)
                                                ],
                                                gradient: new LinearGradient(
                                                    colors: [
                                                      Colors.transparent,
                                                      Colors.transparent,
                                                    ],
                                                    begin: FractionalOffset
                                                        .topCenter,
                                                    end: FractionalOffset
                                                        .bottomCenter,
                                                    stops: [1.0, 0.0],
                                                    tileMode: TileMode.clamp),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              60.0),
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/home%2Flaura-johnston-1I4rCoC5oKA-unsplash.jpg?alt=media&token=578f5c4c-f986-4aec-802d-3a4e13e6d7a6",
                                                        fit: BoxFit.cover,
                                                        height: 70,
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(
                                                          Icons.error,
                                                          color: Colors.grey,
                                                        ),
                                                        width: 70,
                                                      )),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(foodString(DateTime.now()),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              letterSpacing: -.3,
                                              fontFamily: 'Montserrat',
                                              fontSize: Gparam.textExtraSmall,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 0,
                                ),
                                Column(
                                  children: [
                                    UnicornOutlineButton(
                                      strokeWidth: 2,
                                      radius: 100,
                                      gradient: LinearGradient(
                                        colors: [
                                          Theme.of(context).primaryColor,
                                          Theme.of(context).primaryColorLight,
                                          Theme.of(context).accentColor,
                                          Theme.of(context).backgroundColor
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      onPressed: () {},
                                      child: Column(
                                        children: [
                                          Container(
                                              height: 70,
                                              width: 70,
                                              margin: EdgeInsets.all(2),
                                              decoration: new BoxDecoration(
                                                borderRadius:
                                                    new BorderRadius.all(
                                                        Radius.circular(60.0)),
                                                border: null,
                                                boxShadow: [
                                                  BoxShadow(
                                                      offset: Offset(1, 1),
                                                      color: Colors.black
                                                          .withAlpha(40),
                                                      blurRadius: 10)
                                                ],
                                                gradient: new LinearGradient(
                                                    colors: [
                                                      Colors.transparent,
                                                      Colors.transparent,
                                                    ],
                                                    begin: FractionalOffset
                                                        .topCenter,
                                                    end: FractionalOffset
                                                        .bottomCenter,
                                                    stops: [1.0, 0.0],
                                                    tileMode: TileMode.clamp),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              60.0),
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/home%2Fvincent-ledvina-FJVpeHCqImU-unsplash.jpg?alt=media&token=89c1cfc9-a806-4348-9cf5-d229d6691a72",
                                                        fit: BoxFit.cover,
                                                        height: 70,
                                                        width: 70,
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(
                                                          Icons.error,
                                                          color: Colors.grey,
                                                        ),
                                                      )),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          "Positivity around\nthe world",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              letterSpacing: -.3,
                                              fontFamily: 'Montserrat',
                                              fontSize:
                                                  Gparam.textVeryExtraSmall,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 0,
                                ),
                                Column(
                                  children: [
                                    UnicornOutlineButton(
                                      strokeWidth: 2,
                                      radius: 100,
                                      gradient: LinearGradient(
                                        colors: [
                                          Theme.of(context).primaryColor,
                                          Theme.of(context).primaryColorLight,
                                          Theme.of(context).accentColor,
                                          Theme.of(context).backgroundColor
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      onPressed: () {},
                                      child: Column(
                                        children: [
                                          Container(
                                              height: 70,
                                              width: 70,
                                              margin: EdgeInsets.all(2),
                                              decoration: new BoxDecoration(
                                                borderRadius:
                                                    new BorderRadius.all(
                                                        Radius.circular(60.0)),
                                                border: null,
                                                boxShadow: [
                                                  BoxShadow(
                                                      offset: Offset(1, 1),
                                                      color: Colors.black
                                                          .withAlpha(40),
                                                      blurRadius: 10)
                                                ],
                                                gradient: new LinearGradient(
                                                    colors: [
                                                      Colors.transparent,
                                                      Colors.transparent,
                                                    ],
                                                    begin: FractionalOffset
                                                        .topCenter,
                                                    end: FractionalOffset
                                                        .bottomCenter,
                                                    stops: [1.0, 0.0],
                                                    tileMode: TileMode.clamp),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              60.0),
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            "https://firebasestorage.googleapis.com/v0/b/sorted-98c02.appspot.com/o/home%2Fgeorge-pagan-iii-bIlaTxx4nCo-unsplash.jpg?alt=media&token=0dbb9d84-8d53-4368-b31f-3e8dd0fd340c",
                                                        fit: BoxFit.cover,
                                                        height: 70,
                                                        width: 70,
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(
                                                          Icons.error,
                                                          color: Colors.grey,
                                                        ),
                                                      )),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Productivity\nBooster",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              letterSpacing: -.3,
                                              fontFamily: 'Montserrat',
                                              fontSize: Gparam.textExtraSmall,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      ]),
                ],
              ))),
        ));
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        showArrow = false;
      });
    }
  }

  String getAffirmationString(DateTime dateTime) {
    if (dateTime.hour > 19 || (dateTime.hour > 0 && dateTime.hour < 3)) {
      return "Bedtime\nAffirmations";
    } else if (dateTime.hour >= 3 && dateTime.hour < 15)
      return "Sunshine\nAffirmations";
    return "Affirmations";
  }

  String getMeditationString(DateTime dateTime) {
    if (dateTime.hour > 19 || (dateTime.hour > 0 && dateTime.hour < 3)) {
      return "Night\nMeditation";
    } else if (dateTime.hour >= 3 && dateTime.hour < 15)
      return "Morning\nMeditation";
    return "Meditation";
  }

  String foodString(DateTime dateTime) {
    if (dateTime.hour > 19 || (dateTime.hour > 0 && dateTime.hour < 3)) {
      return "Dinner\nInspiration";
    } else if (dateTime.hour >= 3 && dateTime.hour < 10)
      return "Breakfast\nInspiration";
    else if (dateTime.hour >= 10 && dateTime.hour < 15)
      return "Lunch\nInspiration";
    else if (dateTime.hour >= 15 && dateTime.hour < 19)
      return "Snack\nInspiration";
    return "Meal Inspiration";
  }
}
