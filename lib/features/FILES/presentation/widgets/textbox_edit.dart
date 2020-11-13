import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/utility/measure_child.dart';
import 'package:sorted/features/FILES/data/models/block_textbox.dart';
import 'package:sorted/features/FILES/presentation/textbox_bloc/textbox_bloc.dart';
import 'package:sorted/features/FILES/presentation/widgets/textbox_widget.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:zefyr/zefyr.dart';
import 'dart:convert';
import 'package:quill_delta/quill_delta.dart';

class TextboxEdit extends StatefulWidget {
  final TextboxBlock textboxBlock;
  final TextboxBloc textboxBloc;

  const TextboxEdit({
    Key key,
    this.textboxBlock,
    this.textboxBloc,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TextboxEditState();
}

class TextboxEditState extends State<TextboxEdit> {
  ZefyrController _controller;
  double height = 10;
  TextboxBlock currentTextbox;

  NotusDocument document;

  var _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    currentTextbox = widget.textboxBlock;
    document = _loadDocument();

    setState(() {
      _controller = ZefyrController(document);
    });
  }

  @override
  void dispose() {
    //currentTextbox.text = jsonEncode(_controller.document);
    //widget.updateTextbox(currentTextbox);
    widget.textboxBloc.add(UpdateText(
        widget.textboxBlock.copyWith(text: jsonEncode(_controller.document))));
    super.dispose();
  }

  NotusDocument _loadDocument() {
    return NotusDocument.fromJson(jsonDecode(widget.textboxBlock.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.textboxBlock.title)),
      body: ZefyrScaffold(
        child: ZefyrEditor(
          padding: EdgeInsets.all(16),
          controller: _controller,
          focusNode: _focusNode,
        ),
      ),
    );
  }
}
