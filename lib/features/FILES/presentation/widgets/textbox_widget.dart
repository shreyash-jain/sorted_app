import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/core/global/utility/measure_child.dart';
import 'package:sorted/core/global/widgets/fade_route.dart';
import 'package:sorted/core/global/widgets/loading_widget.dart';
import 'package:sorted/core/global/widgets/message_display.dart';
import 'package:sorted/features/FILES/data/models/block_info.dart';
import 'package:sorted/features/FILES/data/models/block_textbox.dart';
import 'package:sorted/features/FILES/presentation/note_bloc/note_bloc.dart';

import 'package:sorted/features/FILES/presentation/textbox_bloc/textbox_bloc.dart';
import 'package:sorted/features/FILES/presentation/widgets/textbox_edit.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:zefyr/zefyr.dart';
import 'dart:convert';
import 'package:quill_delta/quill_delta.dart';

class TextboxWidget extends StatefulWidget {
  final BlockInfo blockInfo;
  final NoteBloc noteBloc;
  final Function(BlockInfo blockInfo) updateBlockInfo;
  final Function(int decoration) updateDecoration;

  const TextboxWidget({
    Key key,
    this.blockInfo,
    this.updateBlockInfo,
    this.updateDecoration,
    this.noteBloc,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TextboxWidgetState();
}

class TextboxWidgetState extends State<TextboxWidget> {
  double height = 10;

  NotusDocument document;

  var _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    print("Load Textbox " + widget.blockInfo.toString());
    BlocProvider.of<TextboxBloc>(context)..add(UpdateTextbox(widget.blockInfo));
  }

  NotusDocument _loadDocument(String text) {
    return NotusDocument.fromJson(jsonDecode(text));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("textbox build");
    return Center(child:
        BlocBuilder<TextboxBloc, TextboxState>(builder: (context, state) {
      if (state is TextboxError) {
        return MessageDisplay(
          message: state.message,
        );
      } else if (state is TextboxInitial) {
        return Center(
            child: Container(
          height: 0,
          width: 0,
        ));
      } else if (state is Textboxloaded) {
        document = _loadDocument(state.textboxBlock.text);
        if (state.textboxBlock.decoration == 1)
          return MeasureSize(
              onChange: (Size size) {
                print("child measured");
                if (state.blockInfo.height != size.height)
                  widget.updateBlockInfo(
                      widget.blockInfo.copyWith(height: size.height));
              },
              child: GestureDetector(
                onTap: () {
                  TextboxBlock toSendBlock = state.textboxBlock;
                  Navigator.push(
                      context,
                      FadeRoute(
                          page: TextboxEdit(
                        textboxBlock: toSendBlock,
                        textboxBloc: BlocProvider.of<TextboxBloc>(context),
                      )));
                  print("edit");
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: Gparam.widthPadding,
                                ),
                                Icon(
                                  OMIcons.notes,
                                  color: Theme.of(context).primaryColor,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12.0)),
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withAlpha(0),
                                  ),
                                  child: Text(
                                    state.textboxBlock.title,
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: 'Milliard',
                                        color: Theme.of(context).primaryColor,
                                        fontSize: Gparam.textSmall,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Icon(
                          OMIcons.moreVert,
                          color: Theme.of(context).primaryColor,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0, bottom: 0),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: Gparam.widthPadding),
                        decoration: BoxDecoration(
                          // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                          borderRadius: BorderRadius.all(Radius.circular(2.0)),
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        child: ZefyrView(
                          document: document,
                        ),
                      ),
                    ),
                  ],
                ),
              ));
        else if (state.textboxBlock.decoration == 0)
          return MeasureSize(
              onChange: (Size size) {
                print("child measured");
                if (state.blockInfo.height != size.height)
                  widget.updateBlockInfo(
                      widget.blockInfo.copyWith(height: size.height));
              },
              child: ExpansionTile(
                  initiallyExpanded: true,
                  maintainState: true,
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  tilePadding: EdgeInsets.only(right: 8),
                  backgroundColor:
                      Theme.of(context).scaffoldBackgroundColor.withAlpha(200),
                  title: Container(
                    color: Theme.of(context).primaryColor.withAlpha(200),
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: Gparam.widthPadding,
                                ),
                                Icon(
                                  OMIcons.notes,
                                  color: Theme.of(context).highlightColor,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12.0)),
                                  ),
                                  child: Text(
                                    state.textboxBlock.title,
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: 'Milliard',
                                        color: Theme.of(context).highlightColor,
                                        fontSize: Gparam.textSmall,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(right: Gparam.widthPadding / 2),
                          child: Icon(
                            OMIcons.moreVert,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  children: [
                    GestureDetector(
                      onTap: () {
                        TextboxBlock toSendBlock = state.textboxBlock;
                        Navigator.push(
                            context,
                            FadeRoute(
                                page: TextboxEdit(
                              textboxBlock: toSendBlock,
                              textboxBloc:
                                  BlocProvider.of<TextboxBloc>(context),
                            )));
                        print("edit");
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 0, bottom: 0),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Gparam.widthPadding),
                                  decoration: BoxDecoration(
                                    // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(2.0)),
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                  ),
                                  child: ZefyrView(
                                    document: document,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]));
        else
          return Container();
      }
    }));
  }
}
