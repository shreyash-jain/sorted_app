import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/utility/url_preview/url_preview.dart';

class AddSliderBottomSheet extends StatefulWidget {
  const AddSliderBottomSheet({
    Key key,
    @required this.onTitleChanged,
  });

  final Function(String text) onTitleChanged;

  @override
  State<StatefulWidget> createState() => AddSliderBottomSheetState();
}

class AddSliderBottomSheetState extends State<AddSliderBottomSheet> {
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
              padding: EdgeInsets.all(20),
              child: TextField(
                onSubmitted: (newValue) {
                  widget.onTitleChanged(newValue);
                },
                decoration: InputDecoration(
                  hintText: 'Enter the title',
                ),
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
