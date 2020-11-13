import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/utility/url_preview/url_preview.dart';

class AddLink extends StatefulWidget {
  const AddLink({
    Key key,
    @required this.newMediaLinkAddressController,
    @required this.onUrlChanged,
    @required this.onTitleChanged,
  });

  final TextEditingController newMediaLinkAddressController;
  final Function(String url) onUrlChanged;
  final Function(String url) onTitleChanged;

  @override
  State<StatefulWidget> createState() => AddLinkState();
}

class AddLinkState extends State<AddLink> {
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
            if (_url != "")
              SimpleUrlPreview(
                url: _url,
                textColor: Theme.of(context).scaffoldBackgroundColor,
                bgColor: Theme.of(context).primaryColor,
                isClosable: true,
                titleLines: 2,
                descriptionLines: 3,
                imageLoaderColor: Colors.white,
                previewHeight: 150,
                previewContainerPadding: EdgeInsets.all(10),
                onTap: () => print('Hello Flutter URL Preview'),
              ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                onSubmitted: (newValue) {
                  if (newValue.startsWith('https://') ||
                      newValue.startsWith('http://'))
                    _onUrlChanged(newValue);
                  else {
                    newValue = "https://" + newValue;
                    _onUrlChanged(newValue);
                  }
                  print("newValue");
                  widget.onUrlChanged(newValue);
                  print("newValue1");
                  print(newValue);
                },
                decoration: InputDecoration(
                  hintText: 'Enter the url',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
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
