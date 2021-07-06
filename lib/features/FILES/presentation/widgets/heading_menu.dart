import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/utility/url_preview/url_preview.dart';
import 'package:sorted/features/FILES/data/models/block_form_field.dart';
import 'package:sorted/features/FILES/domain/entities/block_heading.dart';
import 'package:sorted/features/FILES/presentation/heading_bloc/heading_bloc.dart';
import 'package:sorted/features/FILES/presentation/todolist_bloc/todolist_bloc.dart';
import 'package:sorted/features/PLAN/data/models/todo_item.dart';

class HeadingMenu extends StatefulWidget {
  final Function(
          int decoration, HeadingBloc headingBloc, HeadingBlock headingBlock)
      changeDecoration;

  final HeadingBloc headingBloc;
  final HeadingBlock headingBlock;

  final int decoration;

  const HeadingMenu({
    Key key,
    this.changeDecoration,
    this.decoration,
    this.headingBloc,
    this.headingBlock,
  });

  @override
  State<StatefulWidget> createState() => HeadingMenuState();
}

class HeadingMenuState extends State<HeadingMenu> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        margin: EdgeInsets.only(
            bottom: 0, left: 0, right: 0, top: Gparam.heightPadding / 2),
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.only(
              topLeft: Radius.circular(12.0), topRight: Radius.circular(12.0)),
          gradient: new LinearGradient(
              colors: [
                Theme.of(context).scaffoldBackgroundColor,
                Theme.of(context).scaffoldBackgroundColor,
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 1.00),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              dense: true,
              subtitle: Text('Decoration'),
            ),
            ListTile(
              dense: true,
              onTap: () {
                Navigator.pop(context);
                if (widget.decoration != 0)
                  widget.changeDecoration(
                      0, widget.headingBloc, widget.headingBlock);
              },
              leading: Icon(Icons.format_align_left),
              title: Text(
                'Side Heading',
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
            Divider(),
            ListTile(
              dense: true,
              onTap: () {
                Navigator.pop(context);
                if (widget.decoration != 1)
                  widget.changeDecoration(
                      1, widget.headingBloc, widget.headingBlock);
              },
              leading: Icon(Icons.format_align_center),
              title: Text(
                'Center Heading',
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
        ),
      ),
    );
  }
}
