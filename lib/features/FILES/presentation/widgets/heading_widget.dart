import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/utility/measure_child.dart';
import 'package:sorted/core/global/widgets/fade_route.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/core/global/widgets/message_display.dart';
import 'package:sorted/features/FILES/data/models/block_form_field.dart';
import 'package:sorted/features/FILES/data/models/block_info.dart';
import 'package:sorted/features/FILES/data/models/block_textbox.dart';
import 'package:sorted/features/FILES/domain/entities/block_heading.dart';
import 'package:sorted/features/FILES/presentation/heading_bloc/heading_bloc.dart';
import 'package:sorted/features/FILES/presentation/image_bloc/image_bloc.dart';
import 'package:sorted/features/FILES/presentation/note_bloc/note_bloc.dart';

import 'package:sorted/features/FILES/presentation/widgets/textbox_edit.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:zefyr/zefyr.dart';
import 'dart:convert';
import 'package:quill_delta/quill_delta.dart';

class HeadingWidget extends StatefulWidget {
  final BlockInfo blockInfo;
  final NoteBloc noteBloc;
  final Function(BlockInfo blockInfo) updateBlockInfo;
  final Function(BuildContext context, int decoration, HeadingBloc headingBloc,
      HeadingBlock headingBlock) openMenu;
  final Function(int decoration) updateDecoration;

  const HeadingWidget({
    Key key,
    this.blockInfo,
    this.updateBlockInfo,
    this.updateDecoration,
    this.noteBloc,
    this.openMenu,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => HeadingWidgetState();
}

class HeadingWidgetState extends State<HeadingWidget> {
  double height = 10;
  TransformationController controller = TransformationController();

  var _focusNode = FocusNode();

  var sController = ScrollController();

  @override
  void initState() {
    super.initState();
    print("Load Heading " + widget.blockInfo.toString());
    BlocProvider.of<HeadingBloc>(context)..add(UpdateHeading(widget.blockInfo));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("textbox build");

    return Center(child:
        BlocBuilder<HeadingBloc, HeadingState>(builder: (context, state) {
      if (state is HeadingError) {
        return MessageDisplay(
          message: state.message,
        );
      } else if (state is HeadingInitial) {
        return Center(
            child: Container(
          height: 0,
          width: 0,
        ));
      } else if (state is HeadingLoaded) {
        if (state.heading.decoration == 1)
          return MeasureSize(
              onChange: (Size size) {
                print("child measured");
                if (state.blockInfo.height != size.height)
                  widget.updateBlockInfo(
                      widget.blockInfo.copyWith(height: size.height));
              },
              child: GestureDetector(
                onTap: () {
                  widget.openMenu(context, 1,
                      BlocProvider.of<HeadingBloc>(context), state.heading);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                            child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 3,
                                      width: 40,
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withAlpha(40),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (state.heading.heading != null &&
                                            state.heading.heading != "")
                                          Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              state.heading.heading,
                                              textAlign: TextAlign.start,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontFamily: 'Milliard',
                                                  fontSize: Gparam.textSmall,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        if (state.heading.subHeading != null &&
                                            state.heading.subHeading != "")
                                          Text(
                                            state.heading.subHeading,
                                            textAlign: TextAlign.start,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: 'Milliard',
                                                fontSize: Gparam.textVerySmall,
                                                fontWeight: FontWeight.w400),
                                          ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Container(
                                      height: 3,
                                      width: 40,
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withAlpha(40),
                                    ),
                                  ],
                                )))
                      ]),
                ),
              ));
        else if (state.heading.decoration == 0)
          return MeasureSize(
              onChange: (Size size) {
                print("child measured");
                if (state.blockInfo.height != size.height)
                  widget.updateBlockInfo(
                      widget.blockInfo.copyWith(height: size.height));
              },
              child: GestureDetector(
                onTap: () {
                  widget.openMenu(context, 0,
                      BlocProvider.of<HeadingBloc>(context), state.heading);
                },
                child: Container(
                  child: Row(children: [
                    Flexible(
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: Gparam.widthPadding,
                                ),
                                Container(
                                  width: 5,
                                  color: Theme.of(context).primaryColor,
                                  height: (state.heading.subHeading != null &&
                                          state.heading.subHeading != "")
                                      ? 50
                                      : 36,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (state.heading.heading != null &&
                                        state.heading.heading != "")
                                      Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          state.heading.heading,
                                          textAlign: TextAlign.start,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontFamily: 'Milliard',
                                              fontSize: Gparam.textSmall,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    if (state.heading.subHeading != null &&
                                        state.heading.subHeading != "")
                                      Text(
                                        state.heading.subHeading,
                                        textAlign: TextAlign.start,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontFamily: 'Milliard',
                                            fontSize: Gparam.textVerySmall,
                                            fontWeight: FontWeight.w400),
                                      ),
                                  ],
                                ),
                              ],
                            )))
                  ]),
                ),
              ));
        else
          return Container();
      }
    }));
  }
}
