
import 'package:flutter/material.dart';
import 'package:sorted/core/global/constants/constants.dart';

class EditDescriptionBottomSheet extends StatefulWidget {
  const EditDescriptionBottomSheet({
    Key key,
    @required this.textController,
    @required this.onTitleChanged,
  });

  final TextEditingController textController;

  final Function(String url) onTitleChanged;

  @override
  State<StatefulWidget> createState() => EditDescriptionBottomSheetState();
}

class EditDescriptionBottomSheetState
    extends State<EditDescriptionBottomSheet> {
  String _url = '';

  _onUrlChanged(String updatedUrl) {
    setState(() {
      _url = updatedUrl;
    });
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
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: widget.textController,
                onSubmitted: (newValue) {
                  print(newValue);
                  widget.onTitleChanged(newValue);
                },
                decoration: InputDecoration(
                  hintText: 'Enter a title if you want ',
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
