import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/constants/constants.dart';

class AddAttachment extends StatefulWidget {
  const AddAttachment({
    Key key,
    @required this.newMediaLinkAddressController,
    @required this.deadlineDouble,
    @required this.onImageAdd,
    @required this.onLinkAdd,
    @required this.onDocumentAdd,
    @required this.priorityDouble,
  });

  final TextEditingController newMediaLinkAddressController;
  final Function() onImageAdd;
  final Function() onDocumentAdd;
  final Function() onLinkAdd;
  final double deadlineDouble;
  final double priorityDouble;

  @override
  State<StatefulWidget> createState() => AddAttachmentState();
}

class AddAttachmentState extends State<AddAttachment> {
  String priorityToStr(double p) {
    if (p < .3)
      return "Low";
    else if (p < .6)
      return "Medium";
    else if (p < .8)
      return "High";
    else
      return "Very high";
  }

  String deadlineToStr(double value) {
    if (value < .3) {
      int hrs = (value * 24 / 0.3).floor();
      return "within $hrs hrs";
    } else if (value < .6) {
      int days = ((value - 0.3) * 30 / .3).floor();
      return "within $days days";
    } else {
      int days = ((value - 0.6) * 360 / 0.4).floor();
      print(days);
      return "within ${(days / 30).floor()} months";
    }
    // if (days < 30) {
    //   if (days <= 1)
    //     return (days).floor().toString() + " day";
    //   else
    //     return (days).floor().toString() + " days";
    // } else if (days < 360) {
    //   int m = (days / 30).floor();
    //   if (m <= 1)
    //     return (days / 30).floor().toString() + " month";
    //   else
    //     return (days / 30).floor().toString() + " months";
    // } else {
    //   days = days * (days - 359);

    //   return (days / 360).floor().toString() + " years";
    // }
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(Gparam.widthPadding / 2),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.all(Radius.circular(30.0)),
                      gradient: new LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor,
                            (Theme.of(context).brightness == Brightness.dark)
                                ? Theme.of(context).backgroundColor
                                : Theme.of(context).primaryColorLight,
                          ],
                          begin: FractionalOffset.topCenter,
                          end: FractionalOffset.bottomCenter,
                          stops: [.2, .8],
                          tileMode: TileMode.repeated),
                    ),
                    child: Icon(OMIcons.add),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Add Attachment',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: Gparam.textMedium,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).primaryColor)),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0)),
                gradient: new LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor,
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 1.00),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Gparam.widthPadding / 2),
                    child: TextField(
                      autofocus: true,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: Gparam.textSmall,
                      ),
                      decoration: InputDecoration.collapsed(
                        hintText: 'Type attachment title',
                        hintStyle: TextStyle(
                          fontSize: Gparam.textSmall,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      controller: widget.newMediaLinkAddressController,
                    ),
                  ),
                  SizedBox(
                    height: Gparam.heightPadding,
                  ),
                  InkWell(
                    onTap: () {
                      print("image add");
                      widget.onImageAdd();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Gparam.widthPadding / 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(Icons.add_a_photo),
                          SizedBox(
                            width: 8,
                          ),
                          Text("Image",
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: Gparam.textSmall,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Gparam.heightPadding,
                  ),
                  InkWell(
                    onTap: () {
                      print("link");
                      widget.onLinkAdd();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Gparam.widthPadding / 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(Icons.insert_link),
                          SizedBox(
                            width: 8,
                          ),
                          Text("Link",
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: Gparam.textSmall,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Gparam.heightPadding,
                  ),
                  InkWell(
                    onTap: () {
                      widget.onDocumentAdd();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Gparam.widthPadding / 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(Icons.note_add),
                          SizedBox(
                            width: 8,
                          ),
                          Text("Document",
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: Gparam.textSmall,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Gparam.heightPadding / 3,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
