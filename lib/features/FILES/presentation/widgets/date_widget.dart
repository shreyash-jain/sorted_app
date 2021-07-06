import 'dart:async';

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
import 'package:sorted/core/global/widgets/text_transition.dart';
import 'package:sorted/features/FILES/data/models/block_form_field.dart';
import 'package:sorted/features/FILES/data/models/block_info.dart';
import 'package:sorted/features/FILES/data/models/block_textbox.dart';
import 'package:sorted/features/FILES/domain/entities/block_heading.dart';
import 'package:sorted/features/FILES/presentation/date_bloc/date_bloc.dart';
import 'package:sorted/features/FILES/presentation/heading_bloc/heading_bloc.dart';
import 'package:sorted/features/FILES/presentation/image_bloc/image_bloc.dart';
import 'package:sorted/features/FILES/presentation/note_bloc/note_bloc.dart';

import 'package:sorted/features/FILES/presentation/widgets/textbox_edit.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:zefyr/zefyr.dart';
import 'dart:convert';
import 'package:quill_delta/quill_delta.dart';

class DateWidget extends StatefulWidget {
  final BlockInfo blockInfo;
  final NoteBloc noteBloc;
  final Function(BlockInfo blockInfo) updateBlockInfo;

  final Function(int decoration) updateDecoration;

  const DateWidget({
    Key key,
    this.blockInfo,
    this.updateBlockInfo,
    this.updateDecoration,
    this.noteBloc,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => DateWidgetState();
}

class DateWidgetState extends State<DateWidget> {
  double height = 10;
  TransformationController controller = TransformationController();

  var _focusNode = FocusNode();
  DateTime selectedDate = DateTime.now();
  String dateToShow = "Date";
  int phase = 0;

  var sController = ScrollController();
  DateBloc bloc;
  Timer timer;

  @override
  void initState() {
    super.initState();
    print("Load Heading " + widget.blockInfo.toString());

    bloc = BlocProvider.of<DateBloc>(context);

    const oneSec = const Duration(seconds: 6);

    timer = new Timer.periodic(oneSec, (Timer t) {
      phase = phase + 1;
      if (phase == (bloc.state as DateLoaded).dateStrings.length) phase = 0;
      if (bloc.state is DateLoaded) {
        if (mounted)
          setState(() {
            dateToShow = (bloc.state as DateLoaded).dateStrings[phase];
          });
      }
    });
    bloc..add(GetDate(widget.blockInfo));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("textbox build");

    return Center(
        child: BlocBuilder<DateBloc, DateState>(builder: (context, state) {
      if (state is DateError) {
        return MessageDisplay(
          message: state.message,
        );
      } else if (state is DateInitial) {
        return Center(
            child: Container(
          height: 0,
          width: 0,
        ));
      } else if (state is DateLoaded) {
        if (state.item.decoration == 1)
          return MeasureSize(
              onChange: (Size size) {
                print("child measured");
                if (state.blockInfo.height != size.height)
                  widget.updateBlockInfo(
                      widget.blockInfo.copyWith(height: size.height));
              },
              child: GestureDetector(
                onTap: () {},
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
                                        if (state.item.field != null &&
                                            state.item.field != "")
                                          Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              state.dateStrings[0],
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
        else if (state.item.decoration == 0)
          return MeasureSize(
              onChange: (Size size) {
                print("child measured");
                if (state.blockInfo.height != size.height)
                  widget.updateBlockInfo(
                      widget.blockInfo.copyWith(height: size.height));
              },
              child: GestureDetector(
                onTap: () {
                  _MenuBottomSheet(context, state.item);
                },
                child: Container(
                  color: Theme.of(context).primaryColorLight.withAlpha(10),
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
                                  height: 36,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (state.item.field != null &&
                                        state.item.field != "")
                                      Container(
                                        alignment: Alignment.center,
                                        child: TextTransition(
                                          text: dateToShow,
                                          duration: Duration(milliseconds: 400),
                                          textStyle: TextStyle(
                                              fontFamily: 'Milliard',
                                              fontSize: Gparam.textSmall,
                                              fontWeight: FontWeight.w500),
                                        ),
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

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: (bloc.state is DateLoaded)
          ? ((bloc.state as DateLoaded).dateTime)
          : selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != (bloc.state as DateLoaded).dateTime)
      setState(() {
        selectedDate = picked;
        bloc.add(UpdateDate((bloc.state as DateLoaded)
            .item
            .copyWith(field: picked.toIso8601String())));
      });
  }

  void _MenuBottomSheet(context, FormFieldBlock item) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.0))),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    _selectDate(context);
                    //_EditDescriptionBottomSheet(context, item);
                    // widget.moveUp(
                    //     widget.todo, widget.position, widget.todoBloc);
                  },
                  leading: Icon(Icons.description),
                  title: Text(
                    'Edit date',
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontFamily: "Milliard",
                      height: 1.2,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: Gparam.textSmaller,
                    ),
                  ),
                ),
              ],
            );
          });
        });
  }
}
