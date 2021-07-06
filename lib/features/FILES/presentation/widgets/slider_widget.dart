import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/utility/measure_child.dart';
import 'package:sorted/core/global/widgets/CustomSliderThumbCircle.dart';
import 'package:sorted/core/global/widgets/fade_route.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/core/global/widgets/message_display.dart';
import 'package:sorted/features/FILES/data/models/block_form_field.dart';
import 'package:sorted/features/FILES/data/models/block_info.dart';
import 'package:sorted/features/FILES/data/models/block_slider.dart';
import 'package:sorted/features/FILES/data/models/block_textbox.dart';
import 'package:sorted/features/FILES/domain/entities/block_heading.dart';
import 'package:sorted/features/FILES/presentation/heading_bloc/heading_bloc.dart';
import 'package:sorted/features/FILES/presentation/image_bloc/image_bloc.dart';
import 'package:sorted/features/FILES/presentation/note_bloc/note_bloc.dart';
import 'package:sorted/features/FILES/presentation/slider_bloc/slider_bloc.dart';

import 'package:sorted/features/FILES/presentation/widgets/textbox_edit.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:zefyr/zefyr.dart';
import 'dart:convert';
import 'package:quill_delta/quill_delta.dart';

class SliderWidget extends StatefulWidget {
  final BlockInfo blockInfo;
  final NoteBloc noteBloc;
  final Function(BlockInfo blockInfo) updateBlockInfo;
  final Function(BuildContext context, int decoration, SliderBloc sliderBloc,
      SliderBlock sliderBlock) openMenu;
  final Function(int decoration) updateDecoration;

  const SliderWidget({
    Key key,
    this.blockInfo,
    this.updateBlockInfo,
    this.updateDecoration,
    this.noteBloc,
    this.openMenu,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => SliderWidgetState();
}

class SliderWidgetState extends State<SliderWidget> {
  double height = 10;
  TransformationController controller = TransformationController();

  var _focusNode = FocusNode();

  var sController = ScrollController();

  double sliderValue = 0;
  SliderBloc bloc;

  @override
  void initState() {
    super.initState();
    print("Load Heading " + widget.blockInfo.toString());
    bloc = BlocProvider.of<SliderBloc>(context);
    bloc..add(LoadSlider(widget.blockInfo));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("textbox build");

    return Center(
        child: BlocBuilder<SliderBloc, SliderState>(builder: (context, state) {
      if (state is SliderError) {
        return MessageDisplay(
          message: state.message,
        );
      } else if (state is SliderInitial) {
        return Center(
            child: Container(
          height: 0,
          width: 0,
        ));
      } else if (state is SliderLoaded) {
        if (state.sliderBlock.decoration == 1)
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
                      BlocProvider.of<SliderBloc>(context), state.sliderBlock);
                },
                child: Container(
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
                                        if (state.sliderBlock.title != null &&
                                            state.sliderBlock.title != "")
                                          Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              state.sliderBlock.title,
                                              textAlign: TextAlign.start,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontFamily: 'Milliard',
                                                  fontSize: Gparam.textSmall,
                                                  fontWeight: FontWeight.w500),
                                            ),
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
        else if (state.sliderBlock.decoration == 0)
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
                      BlocProvider.of<SliderBloc>(context), state.sliderBlock);
                },
                child: Container(
                  child: Column(children: [
                    SizedBox(
                      height: Gparam.heightPadding,
                    ),
                    Row(
                      children: [
                        SizedBox(width: Gparam.widthPadding),
                        Text(
                          state.sliderBlock.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: Gparam.textSmaller,
                            fontFamily: 'Milliard',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      child: Padding(
                        padding: EdgeInsets.only(top: 0, left: 0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              state.sliderBlock.minItem,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Milliard',
                              ),
                            ),
                            SizedBox(
                              width: 1,
                            ),
                            Expanded(
                              child: Center(
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor:
                                        Theme.of(context).primaryColorDark,
                                    inactiveTrackColor:
                                        Colors.grey.withOpacity(.2),

                                    trackHeight: 20.0,
                                    thumbColor: Theme.of(context).buttonColor,
                                    thumbShape: CustomSliderThumbCircleText(
                                      thumbRadius: 26,
                                      min: state.sliderBlock.min.floor(),
                                      max: state.sliderBlock.max.floor(),
                                    ),

                                    overlayColor: Colors.black.withOpacity(.4),
                                    //valueIndicatorColor: Colors.white,
                                    activeTickMarkColor:
                                        Theme.of(context).primaryColor,
                                    valueIndicatorTextStyle: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Milliard',
                                    ),
                                    inactiveTickMarkColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                  ),
                                  child: Slider(
                                      value: state.sliderBlock.value,
                                      divisions: (state.sliderBlock.max -
                                              state.sliderBlock.min)
                                          .floor(),
                                      onChanged: (value) {
                                        bloc.add(UpdateSliderValue(state
                                            .sliderBlock
                                            .copyWith(value: value)));
                                        setState(() {});
                                      }),
                                ),
                              ),
                            ),
                            Text(
                              state.sliderBlock.maxItem,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Milliard',
                              ),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
              ));
        else
          return Container();
      }
    }));
  }
}
