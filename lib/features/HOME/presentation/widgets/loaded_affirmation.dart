import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/animations/shimmer.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:sorted/features/HOME/presentation/bloc_affirmation/affirmation_bloc.dart';
import 'package:sorted/features/HOME/presentation/widgets/affirmation_tile.dart';
import 'package:sorted/features/HOME/presentation/widgets/flexible_safe_area.dart';

class LoadedAffirmationWidget extends StatelessWidget {
  const LoadedAffirmationWidget({
    Key key,
    @required ScrollController controller,
    @required this.showArrow,
    @required this.bloc,
    @required this.state,
    @required this.popUp,
  })  : _controller = controller,
        super(key: key);

  final ScrollController _controller;

  final LoadedState state;
  final AffirmationBloc bloc;
  final bool showArrow;
  final OverlayEntry popUp;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0)),
            ),
            margin: EdgeInsets.only(top: 0, left: 0),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state.showAffirmations)
                      Container(
                        height: Gparam.height / 10,
                        width: Gparam.width,
                        margin: EdgeInsets.only(top: 10),
                        child: ListView.builder(
                            controller: _controller,
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: state.affirmations.length + 1,
                            itemBuilder: (BuildContext context, int index) {
                              if (index == 0)
                                return SizedBox(
                                  width: Gparam.widthPadding / 2,
                                );
                              return AffirmationTile(
                                affirmation: state.affirmations[index - 1],
                                affirmationBloc: bloc,
                                context: context,
                                index: index - 1,
                                popupDialog: popUp,
                              );
                            }),
                      ),
                    if (state.showInspiration)
                      Container(
                        height: Gparam.height / 10,
                        width: Gparam.width,
                        padding: EdgeInsets.only(
                            left: Gparam.width / 7,
                            top: Gparam.heightPadding / 2,
                            right: Gparam.widthPadding),
                        child: Column(
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Flexible(
                                    child: RichText(
                                      text: TextSpan(
                                        text: state.inspiration.text,
                                        style: TextStyle(
                                            fontFamily: 'Milliard',
                                            fontSize:
                                                (state.inspiration.text.length >
                                                        100)
                                                    ? 14
                                                    : 18,
                                            fontWeight: FontWeight.w700,
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.light
                                                    ? Colors.white54
                                                    : Colors.black54),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: " - " +
                                                  state.inspiration.auther,
                                              style: TextStyle(
                                                height: 1.3,
                                                fontFamily: 'Eastman',
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.light
                                                    ? Colors.white24
                                                    : Colors.black26,
                                                fontWeight: FontWeight.normal,
                                                fontSize: (state.inspiration
                                                            .text.length >
                                                        100)
                                                    ? 12
                                                    : 14,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                if (showArrow && state.showAffirmations)
                  Padding(
                    padding: EdgeInsets.only(
                        top: Gparam.heightPadding * 2,
                        left: 3.5 * Gparam.width / 4),
                    child: Shimmer(
                        period: Duration(milliseconds: 1600),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.grey[200],
                            Colors.grey[200],
                            Colors.grey[850],
                            Colors.grey[200],
                            Colors.grey[200]
                          ],
                          stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
                        ),
                        child: Icon(OMIcons.arrowRight,
                            size: 40, color: Colors.white70)),
                  ),
              ],
            )),
      ],
    );
  }
}
