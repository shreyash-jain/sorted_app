import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/features/HOME/data/models/blogs.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:sorted/features/HOME/data/models/recipes/tagged_recipe.dart';
import 'package:sorted/features/HOME/data/models/transformation.dart';
import 'package:sorted/features/HOME/presentation/transformation_bloc/transformation_bloc.dart';
import 'package:sorted/features/HOME/presentation/widgets/heading.dart';

class HomeTransformationWidgetM extends StatefulWidget {
  final TransformationBloc transBloc;
  HomeTransformationWidgetM({Key key, this.transBloc}) : super(key: key);

  @override
  _HomeTransformationWidgetMState createState() =>
      _HomeTransformationWidgetMState();
}

class _HomeTransformationWidgetMState extends State<HomeTransformationWidgetM> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => widget.transBloc,
      child: BlocBuilder<TransformationBloc, TransformationState>(
        builder: (context, state) {
          if (state is HomePageTransformationLoaded)
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeHeading(
                    heading: "Transformation Story",
                    subHeading: "Inspiration of the day",
                  ),
                  Container(
                    height: 300,
                    width: Gparam.width,
                    alignment: Alignment.topLeft,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              left: 8 + 8.0 + Gparam.widthPadding / 2),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                ),
                                child: Container(
                                  color: (Theme.of(context).brightness ==
                                          Brightness.dark)
                                      ? Colors.grey.shade900
                                      : Colors.grey.shade100,
                                  child: CachedNetworkImage(
                                    imageUrl: state.trans.image_url,
                                    fit: BoxFit.cover,
                                    height: 240,
                                    width: 300,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                  ),
                                  child: Container(
                                      width: 300,
                                      height: 60,
                                      color: (Theme.of(context).brightness ==
                                              Brightness.dark)
                                          ? Colors.grey.shade900
                                          : Colors.grey.shade100,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(
                                                top: 8,
                                                left: 8,
                                                right: 8,
                                                bottom: 0),
                                            child: Text(
                                              state.trans.title,
                                              textAlign: TextAlign.start,
                                              maxLines: 2,
                                              overflow: TextOverflow.fade,
                                              style: TextStyle(
                                                  color: (Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark)
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontFamily: 'Milliard',
                                                  fontSize:
                                                      Gparam.textVerySmall,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            height: 300,
                            width: 300,
                            color: (Theme.of(context).brightness ==
                                    Brightness.dark)
                                ? Colors.grey.shade900
                                : Colors.grey.shade100,
                            padding: EdgeInsets.symmetric(
                                horizontal: Gparam.widthPadding / 1.5,
                                vertical: Gparam.heightPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "This is the story of",
                                  textAlign: TextAlign.start,
                                  maxLines: 2,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                      color: (Theme.of(context).brightness ==
                                              Brightness.dark)
                                          ? Colors.white
                                          : Colors.black,
                                      fontFamily: 'Milliard',
                                      fontSize: Gparam.textSmaller,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  state.trans.person,
                                  textAlign: TextAlign.start,
                                  maxLines: 2,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                      color: (Theme.of(context).brightness ==
                                              Brightness.dark)
                                          ? Colors.white
                                          : Colors.black,
                                      fontFamily: 'Milliard',
                                      fontSize: Gparam.textSmall,
                                      fontWeight: FontWeight.w800),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Container(
                                  height: 175,
                                  child: Text(
                                    state.trans.story,
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                        color: (Theme.of(context).brightness ==
                                                Brightness.dark)
                                            ? Colors.white
                                            : Colors.black,
                                        fontFamily: 'Milliard',
                                        fontSize: Gparam.textVerySmall,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Container(
                                  child: Text(
                                    "Read more",
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                        color: (Theme.of(context).brightness ==
                                                Brightness.dark)
                                            ? Colors.white
                                            : Colors.black,
                                        fontFamily: 'Milliard',
                                        fontSize: Gparam.textVerySmall,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ],
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            );
          else
            return Container(
              height: 0,
              width: 0,
            );
        },
      ),
    );
  }
}
