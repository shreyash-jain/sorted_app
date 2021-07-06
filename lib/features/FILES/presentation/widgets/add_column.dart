import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/utility/url_preview/url_preview.dart';
import 'package:sorted/features/FILES/data/models/block_column.dart';
import 'package:sorted/features/FILES/presentation/table_bloc/table_bloc.dart';

class AddColumnBottomSheet extends StatefulWidget {
  const AddColumnBottomSheet({
    Key key,
    @required this.onHeadingChanged,
    this.columnBlock,
    this.onTypeChanged,
  });

  final Function(String text) onHeadingChanged;

  final Function(int type) onTypeChanged;
  final ColumnBlock columnBlock;

  @override
  State<StatefulWidget> createState() => AddColumnBottomSheetState();
}

class AddColumnBottomSheetState extends State<AddColumnBottomSheet> {
  TextEditingController titleController = TextEditingController();
  @override
  void initState() {
    titleController.text = widget.columnBlock.title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        margin: EdgeInsets.only(
            bottom: 0, left: 0, right: 0, top: Gparam.heightPadding),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Gparam.widthPadding),
              child: TextField(
                controller: titleController,
                onSubmitted: (newValue) {
                  widget.onHeadingChanged(newValue);
                },
                decoration: InputDecoration(
                  hintText: 'Enter the column title',
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: Gparam.widthPadding),
                  child: Text(
                    'Property',
                    style: TextStyle(
                      fontFamily: 'Milliard',
                      fontSize: Gparam.textSmaller,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              height: 35,
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [
                  SizedBox(
                    width: Gparam.widthPadding,
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.onTypeChanged(0);
                    },
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 3.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
                      decoration: new BoxDecoration(
                          borderRadius:
                              new BorderRadius.all(Radius.circular((8))),
                          color: (widget.columnBlock.type == 0)
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).scaffoldBackgroundColor),
                      height: 40,
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Text",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Milliard',
                                fontSize: Gparam.textSmaller,
                                shadows: [
                                  Shadow(
                                    blurRadius: 20.0,
                                    color: Colors.white,
                                    offset: Offset(1.0, 1.0),
                                  ),
                                ],
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.onTypeChanged(1);
                    },
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 3.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
                      decoration: new BoxDecoration(
                          borderRadius:
                              new BorderRadius.all(Radius.circular((8))),
                          color: (widget.columnBlock.type == 1)
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).scaffoldBackgroundColor),
                      height: 40,
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Number",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Milliard',
                                fontSize: Gparam.textSmaller,
                                shadows: [
                                  Shadow(
                                    blurRadius: 20.0,
                                    color: Colors.white,
                                    offset: Offset(1.0, 1.0),
                                  ),
                                ],
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.onTypeChanged(2);
                    },
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 3.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
                      decoration: new BoxDecoration(
                          borderRadius:
                              new BorderRadius.all(Radius.circular((8))),
                          color: (widget.columnBlock.type == 2)
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).scaffoldBackgroundColor),
                      height: 40,
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Date",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Milliard',
                                fontSize: Gparam.textSmaller,
                                shadows: [
                                  Shadow(
                                    blurRadius: 20.0,
                                    color: Colors.white,
                                    offset: Offset(1.0, 1.0),
                                  ),
                                ],
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.onTypeChanged(3);
                    },
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 3.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
                      decoration: new BoxDecoration(
                          borderRadius:
                              new BorderRadius.all(Radius.circular((8))),
                          color: (widget.columnBlock.type == 3)
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).scaffoldBackgroundColor),
                      height: 40,
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Web Link",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Milliard',
                                fontSize: Gparam.textSmaller,
                                shadows: [
                                  Shadow(
                                    blurRadius: 20.0,
                                    color: Colors.white,
                                    offset: Offset(1.0, 1.0),
                                  ),
                                ],
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.onTypeChanged(4);
                    },
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 3.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
                      decoration: new BoxDecoration(
                          borderRadius:
                              new BorderRadius.all(Radius.circular((8))),
                          color: (widget.columnBlock.type == 4)
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).scaffoldBackgroundColor),
                      height: 40,
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Checkbox",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Milliard',
                                fontSize: Gparam.textSmaller,
                                shadows: [
                                  Shadow(
                                    blurRadius: 20.0,
                                    color: Colors.white,
                                    offset: Offset(1.0, 1.0),
                                  ),
                                ],
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.onTypeChanged(5);
                    },
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 3.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
                      decoration: new BoxDecoration(
                          borderRadius:
                              new BorderRadius.all(Radius.circular((8))),
                          color: (widget.columnBlock.type == 5)
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).scaffoldBackgroundColor),
                      height: 40,
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Email",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Milliard',
                                fontSize: Gparam.textSmaller,
                                shadows: [
                                  Shadow(
                                    blurRadius: 20.0,
                                    color: Colors.white,
                                    offset: Offset(1.0, 1.0),
                                  ),
                                ],
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.onTypeChanged(6);
                    },
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 3.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
                      decoration: new BoxDecoration(
                          borderRadius:
                              new BorderRadius.all(Radius.circular((8))),
                          color: (widget.columnBlock.type == 6)
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).scaffoldBackgroundColor),
                      height: 30,
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Phone",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Milliard',
                                fontSize: Gparam.textSmaller,
                                shadows: [
                                  Shadow(
                                    blurRadius: 20.0,
                                    color: Colors.white,
                                    offset: Offset(1.0, 1.0),
                                  ),
                                ],
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Gparam.heightPadding,
            )
          ],
        ),
      ),
    );
  }
}
