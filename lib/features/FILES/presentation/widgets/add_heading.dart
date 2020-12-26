import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/utility/url_preview/url_preview.dart';

class AddHeadingBottomSheet extends StatefulWidget {
  const AddHeadingBottomSheet({
    Key key,
    @required this.onHeadingChanged,
    @required this.onSubHeadingChanged,
  });

  final Function(String text) onHeadingChanged;
  final Function(String text) onSubHeadingChanged;

  @override
  State<StatefulWidget> createState() => AddHeadingBottomSheetState();
}

class AddHeadingBottomSheetState extends State<AddHeadingBottomSheet> {
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
                  widget.onHeadingChanged(newValue);
                },
                decoration: InputDecoration(
                  hintText: 'Enter the Heading',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                onChanged: (newValue) {
                  widget.onSubHeadingChanged(newValue);
                },
                decoration: InputDecoration(
                  hintText: 'Enter a sub heading if you want ',
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
