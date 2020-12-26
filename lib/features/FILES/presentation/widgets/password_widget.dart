import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_store/flutter_cache_store.dart';
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
import 'package:sorted/features/FILES/presentation/password_bloc/password_bloc.dart';

import 'package:sorted/features/FILES/presentation/widgets/textbox_edit.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:zefyr/zefyr.dart';
import 'dart:convert';
import 'package:quill_delta/quill_delta.dart';

class PasswordWidget extends StatefulWidget {
  final BlockInfo blockInfo;
  final NoteBloc noteBloc;
  final Function(BlockInfo blockInfo) updateBlockInfo;

  final Function(int decoration) updateDecoration;

  const PasswordWidget({
    Key key,
    this.blockInfo,
    this.updateBlockInfo,
    this.updateDecoration,
    this.noteBloc,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => PasswordWidgetState();
}

class PasswordWidgetState extends State<PasswordWidget> {
  double height = 10;
  TransformationController controller = TransformationController();

  var _focusNode = FocusNode();

  var sController = ScrollController();
  bool _obscureText = true;

  String _password;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
    print("Load Heading " + widget.blockInfo.toString());
    BlocProvider.of<PasswordBloc>(context)..add(GetPassword(widget.blockInfo));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("textbox build");

    return Center(child:
        BlocBuilder<PasswordBloc, PasswordState>(builder: (context, state) {
      if (state is PasswordError) {
        return MessageDisplay(
          message: state.message,
        );
      } else if (state is PasswordInitial) {
        return Center(
            child: Container(
          height: 0,
          width: 0,
        ));
      } else if (state is PasswordLoaded) {
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
                                        Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            state.item.field,
                                            textAlign: TextAlign.start,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: Gparam.textSmall,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        TextFormField(
                                          decoration: const InputDecoration(
                                              labelText: 'Password',
                                              icon: const Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 15.0),
                                                  child:
                                                      const Icon(Icons.lock))),
                                          validator: (val) => val.length < 6
                                              ? 'Password too short.'
                                              : null,
                                          onSaved: (val) => _password = val,
                                          obscureText: _obscureText,
                                        ),
                                        new FlatButton(
                                            onPressed: _toggle,
                                            child: new Text(
                                                _obscureText ? "Show" : "Hide"))
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
                onTap: () {},
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      Container(
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
                                      OMIcons.lock,
                                      color: Theme.of(context).highlightColor,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        // border: Border.all(color: Theme.of(context).primaryColor, width: 5),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12.0)),
                                      ),
                                      child: Text(
                                        state.item.field,
                                        textAlign: TextAlign.start,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color: Theme.of(context)
                                                .highlightColor,
                                            fontSize: Gparam.textSmall,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: Gparam.widthPadding / 2),
                              child: Icon(
                                OMIcons.moreVert,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Gparam.widthPadding),
                        child: TextFormField(
                          initialValue: state.item.fieldValue,
                          decoration: InputDecoration(
                              labelText: 'Password',
                              suffixIcon: FlatButton(
                                  onPressed: _toggle,
                                  child: new Text(!_obscureText ? "🙊" : "🙈")),
                              icon: const Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: Text("🔑"))),
                          validator: (val) =>
                              val.length < 6 ? 'Password too short.' : null,
                          onSaved: (val) {
                            _password = val;
                          },
                          obscureText: _obscureText,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
              ));
        else
          return Container();
      }
    }));
  }
}
