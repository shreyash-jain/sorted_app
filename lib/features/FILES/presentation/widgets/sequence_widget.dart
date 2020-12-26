import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_store/flutter_cache_store.dart';
import 'package:intl/intl.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/utility/measure_child.dart';
import 'package:sorted/core/global/widgets/CustomSliderThumbCircle.dart';
import 'package:sorted/core/global/widgets/fade_route.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/core/global/widgets/message_display.dart';
import 'package:sorted/core/global/widgets/text_transition.dart';
import 'package:sorted/features/FILES/data/models/block_form_field.dart';
import 'package:sorted/features/FILES/data/models/block_info.dart';
import 'package:sorted/features/FILES/data/models/block_sequence.dart';
import 'package:sorted/features/FILES/data/models/block_slider.dart';
import 'package:sorted/features/FILES/data/models/block_textbox.dart';
import 'package:sorted/features/FILES/domain/entities/block_heading.dart';
import 'package:sorted/features/FILES/presentation/heading_bloc/heading_bloc.dart';
import 'package:sorted/features/FILES/presentation/image_bloc/image_bloc.dart';
import 'package:sorted/features/FILES/presentation/note_bloc/note_bloc.dart';
import 'package:sorted/features/FILES/presentation/sequence_bloc/sequence_bloc.dart';
import 'package:sorted/features/FILES/presentation/slider_bloc/slider_bloc.dart';

import 'package:sorted/features/FILES/presentation/widgets/textbox_edit.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:zefyr/zefyr.dart';
import 'dart:convert';
import 'package:quill_delta/quill_delta.dart';

class SequenceWidget extends StatefulWidget {
  final BlockInfo blockInfo;
  final NoteBloc noteBloc;
  final Function(BlockInfo blockInfo) updateBlockInfo;
  final Function(BuildContext context, int decoration, SequenceBloc sliderBloc,
      SequenceBlock sliderBlock) openMenu;
  final Function(int decoration) updateDecoration;

  const SequenceWidget({
    Key key,
    this.blockInfo,
    this.updateBlockInfo,
    this.updateDecoration,
    this.noteBloc,
    this.openMenu,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => SequenceWidgetState();
}

class SequenceWidgetState extends State<SequenceWidget> {
  double height = 10;
  TransformationController controller = TransformationController();

  var _focusNode = FocusNode();

  var sController = ScrollController();

  double sliderValue = 0;
  SequenceBloc bloc;
  String toShowDate = "";
  final DateFormat formatter = DateFormat('dd MMM, EEEE');
  Timer timer;
  DateTime selectedDate = DateTime.now();
  bool phase = false;

  @override
  void initState() {
    super.initState();
    print("Load Sequence" + widget.blockInfo.toString());
    bloc = BlocProvider.of<SequenceBloc>(context);
    const oneSec = const Duration(seconds: 6);
    if (bloc.state is SequenceLoaded)
      toShowDate = formatter.format(DateTime.fromMillisecondsSinceEpoch(
          (bloc.state as SequenceLoaded).item.date));
    timer = new Timer.periodic(oneSec, (Timer t) {
      print("h1");
      phase = !phase;
      if (bloc.state is SequenceLoaded) {
        print("h2");
        setState(() {
          if (phase) {
            print("h3");
            toShowDate = formatter.format(DateTime.fromMillisecondsSinceEpoch(
                (bloc.state as SequenceLoaded).item.date));
          } else {
            toShowDate = getDays(DateTime.fromMillisecondsSinceEpoch(
                (bloc.state as SequenceLoaded).item.date));
          }
        });
      }
    });

    bloc..add(GetSequence(widget.blockInfo));
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("sequence build");

    return Center(child:
        BlocBuilder<SequenceBloc, SequenceState>(builder: (context, state) {
      if (state is SequenceError) {
        return MessageDisplay(
          message: state.message,
        );
      } else if (state is SequenceInitial) {
        return Center(
            child: Container(
          height: 0,
          width: 0,
        ));
      } else if (state is SequenceLoaded) {
        if (state.item.decoration == 1)
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
                      BlocProvider.of<SequenceBloc>(context), state.item);
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
                                        if (state.item.title != null &&
                                            state.item.title != "")
                                          Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              state.item.title,
                                              textAlign: TextAlign.start,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
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
                  widget.openMenu(context, 0,
                      BlocProvider.of<SequenceBloc>(context), state.item);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: Gparam.widthPadding,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: Gparam.widthPadding * 2,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: Gparam.widthPadding / 5,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(0)),
                                    color: Theme.of(context).primaryColor),
                                height: 70,
                              ),
                              Container(
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).primaryColor),
                                child: GestureDetector(
                                  child: Icon(
                                    Icons.panorama_fish_eye,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                  ),
                                  onTap: () {},
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: Gparam.widthPadding / 2,
                    ),
                    Container(
                      width: Gparam.width - (Gparam.widthPadding * 4),
                     
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    selectedDate =
                                        (DateTime.fromMillisecondsSinceEpoch(
                                            (bloc.state as SequenceLoaded)
                                                .item
                                                .date));
                                    _selectDate(context);
                                  },
                                  child: TextTransition(
                                    text: toShowDate,
                                    duration: Duration(milliseconds: 400),
                                    textStyle: TextStyle(
                                      fontSize: Gparam.textVerySmall,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  child: Icon(
                                    Icons.more_vert,
                                    size: 20,
                                  ),
                                  onTap: () {
                                    _MenuBottomSheet(context, state.item);
                                  },
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  state.item.title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: Gparam.textSmall,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            if (state.item.content != null &&
                                state.item.content.isNotEmpty)
                              SizedBox(
                                height: Gparam.heightPadding / 2,
                              ),
                            if (state.item.content != null &&
                                state.item.content.isNotEmpty)
                              Column(
                                children: [
                                  Text(
                                    state.item.content,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: Gparam.textSmaller,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                          ]),
                    ),
                  ],
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
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      initialEntryMode: DatePickerEntryMode.input,

      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        bloc.add(UpdateItem(((bloc.state) as SequenceLoaded)
            .item
            .copyWith(date: selectedDate.millisecondsSinceEpoch)));
      });
  }

  String getDays(DateTime dateTime) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = DateTime(now.year, now.month, now.day - 1);
    DateTime tomorrow = DateTime(now.year, now.month, now.day + 1);
    final aDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    if (aDate == today) {
      return "Today";
    } else if (aDate == yesterday) {
      return "Yesterday";
    } else if (aDate == tomorrow) {
      return "Tomorrow";
    } else if (dateTime.isAfter(DateTime.now())) {
      return "In " + dateTime.difference(now).inDays.toString() + " days";
    } else {
      return dateTime.difference(now).inDays.abs().toString() + " days before";
    }
  }

  void _MenuBottomSheet(context, item) {
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
                    _EditDescriptionBottomSheet(context, item);
                    // widget.moveUp(
                    //     widget.todo, widget.position, widget.todoBloc);
                  },
                  leading: Icon(Icons.description),
                  title: Text(
                    (item.content != null && item.content.isNotEmpty)
                        ? 'Edit description'
                        : 'Add description',
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontFamily: "Montserrat",
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

  void _EditDescriptionBottomSheet(context, SequenceBlock item) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.0))),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: TextFormField(
                      maxLines: 3,
                      initialValue: item.content,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (newValue) {
                        //widget.onHeadingChanged(newValue);
                        Navigator.pop(context);
                        bloc.add(UpdateItem(item.copyWith(content: newValue)));
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter description',
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }
}
