import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/utility/url_preview/url_preview.dart';

class AddLink extends StatefulWidget {
  const AddLink({
    Key key,
    @required this.newMediaLinkAddressController,
   
  });

  final TextEditingController newMediaLinkAddressController;
 

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

  Map<int, String> monthsInYear = {
    1: "Jan",
    2: "Feb",
    3: "Mar",
    4: "Apr",
    5: "May",
    6: "June",
    7: "July",
    8: "Aug",
    9: "Sept",
    10: "Oct",
    11: "Nov",
    12: "Dec",
  };
  Map<int, String> dayInWeek = {
    1: "Monday",
    2: "Tuesday",
    3: "Wednesday",
    4: "Thusday",
    5: "Friday",
    6: "Saturday",
    7: "Sunday"
  };
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
    if (value < 1) {
      int hrs = (value * 24).floor();
      return "$hrs hrs";
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
          mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
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
              onSubmitted: (newValue) => _onUrlChanged(newValue),
              decoration: InputDecoration(
                hintText: 'Enter the url',
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget makeDayTile({DateTime date, BuildContext context, int index}) {
    return Container(
        width: 80,
        margin: EdgeInsets.all(4),
        padding: EdgeInsets.all(2),
        decoration: new BoxDecoration(
            borderRadius: new BorderRadius.all(Radius.circular(12.0)),
            gradient: new LinearGradient(
                colors: [
                  Theme.of(context).scaffoldBackgroundColor.withAlpha(180),
                  Theme.of(context).scaffoldBackgroundColor.withAlpha(40),
                ],
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                stops: [0.5, 0],
                tileMode: TileMode.clamp)),
        child: RichText(
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          text: TextSpan(
            text: date.day.toString() + " ",
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: Gparam.textVerySmall,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w500,
            ),
            children: <TextSpan>[
              TextSpan(
                  text: monthsInYear[date.month].toString() + "\n",
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    height: 1.2,
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).primaryColor,
                    fontSize: Gparam.textSmaller,
                  )),
              TextSpan(
                  text: (index==0|| index==1)?(index==1)?"Tomorrow":"Today":dayInWeek[date.weekday].toString(),
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    height: 1.4,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    fontSize: 12,
                  )),
            ],
          ),
        ));
  }
}
