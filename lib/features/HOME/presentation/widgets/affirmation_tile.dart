import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/routes/router.gr.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:sorted/features/HOME/presentation/bloc_affirmation/affirmation_bloc.dart';

class AffirmationTile extends StatelessWidget {
  AffirmationTile({
    Key key,
    @required this.context,
    @required OverlayEntry popupDialog,
    @required this.affirmationBloc,
    @required this.index,
    
    @required this.affirmation,
  })  : _popupDialog = popupDialog,
        super(key: key);

  final BuildContext context;

  final OverlayEntry _popupDialog;
  final AffirmationBloc affirmationBloc;
  final int index;
  final DayAffirmation affirmation;

  OverlayEntry updatedPopUp;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // keep the OverlayEntry instance, and insert it into Overlay
     
      onTap: () {
        Router.navigator.pushNamed(Router.affirmationPageview,
            arguments: AffirmationPVArguments(
                affirmations:
                    (affirmationBloc.state as LoadedState).affirmations,
                startIndex: index,
                outerBloc: affirmationBloc));
      },
      child: Hero(
          tag: "thumbnail" + index.toString(),
          child: Column(
            children: [
              Container(
                  height: Gparam.height / 14,
                  width: Gparam.height / 14,
                  margin: EdgeInsets.all(4),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.all(Radius.circular(60.0)),
                    border: (!affirmation.read)
                        ? Border.all(
                            color: Theme.of(context).primaryColor, width: 2.5)
                        : null,
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
                                height: Gparam.height / 17,
                                width: Gparam.height / 17,
                              ))),
                    ],
                  )),
            ],
          )),
    );
  }
}
