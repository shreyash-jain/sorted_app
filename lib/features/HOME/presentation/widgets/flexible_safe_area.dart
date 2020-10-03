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
import 'package:sorted/core/routes/router.gr.dart';
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
                    child: CachedNetworkImage(
                      imageUrl: affirmation.imageUrl,
                      fit: BoxFit.cover,
                      height: Gparam.height,
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
        title: (widget.currentSliverheight < Gparam.height / 4)
            ? Text(
                'My feed',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: 'ZillaSlab',
                  fontSize: 18.0,
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
                  0.8
                ],
                begin: FractionalOffset.topRight,
                end: FractionalOffset.bottomCenter,
                tileMode: TileMode.clamp),
          ),
          padding: EdgeInsets.only(
            top: Gparam.topPadding / 1.5,
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
                            create: (_) => affirmationBloc,
                            child:
                                BlocListener<AffirmationBloc, AffirmationState>(
                                    listener: (context, state) {},
                                    child: BlocBuilder<AffirmationBloc,
                                            AffirmationState>(
                                        builder: (context, state) {
                                      if (state is LoadingState) {
                                        return LoadingAffirmationWidget();
                                      } else if (state is Error) {
                                        return Container(
                                          width: 0,
                                          height: 0,
                                        );
                                      } else if (state is LoadedState) {
                                        return LoadedAffirmationWidget(
                                          controller: _controller,
                                          state: state,
                                          showArrow: showArrow,
                                          bloc: affirmationBloc,
                                          popUp: _popupDialog,
                                          onTapAffirmationTile:
                                              onTapAffirmationTile,
                                        );
                                      }
                                    }))),
                        
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

  OverlayEntry onTapAffirmationTile(DayAffirmation affirmation) {
    _popupDialog = _createPopupDialog(affirmation);
    Overlay.of(context).insert(_popupDialog);
    return _popupDialog;
  }
}
