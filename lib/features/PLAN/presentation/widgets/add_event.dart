import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/constants/constants.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({
    Key key,
    @required this.newMediaLinkAddressController,
    @required this.deadlineDouble,
    @required this.onDeadlineChanged,
    @required this.onPriorityChanged,
    @required this.priorityDouble,
  });

  final TextEditingController newMediaLinkAddressController;
  final Function(double value) onDeadlineChanged;
  final Function(double value) onPriorityChanged;
  final double deadlineDouble;
  final double priorityDouble;

  @override
  State<StatefulWidget> createState() => AddEventState();
}

class AddEventState extends State<AddEvent> {
  int hrs = 1;
  int mins = 0;
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
  List<Widget> entriesHrs = [];
  List<Widget> entriesMins = [];
  Map<int, String> dayInWeek = {
    1: "Monday",
    2: "Tuesday",
    3: "Wednesday",
    4: "Thusday",
    5: "Friday",
    6: "Saturday",
    7: "Sunday"
  };
  List<String> hrsList = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12"
  ];

  List<String> minsList = [
    "00",
    "30",
  ];
  List<String> emojiTimeList = [
    '🕛',
    '🕧',
    '🕐',
    '🕜',
    '🕑',
    '🕝',
    '🕒',
    '🕞',
    '🕓',
    '🕟',
    '🕔',
    '🕠',
    '🕕',
    '🕡',
    '🕖',
    '🕢',
    '🕗',
    '🕣',
    '🕘',
    '🕤',
    '🕙',
    '🕥',
    '🕚',
    '🕦',
  ];

  void initState() {
    if (mounted)
      entriesHrs = List<Widget>.generate(
        12,
        (i) => Container(
          height: 30,
          margin: EdgeInsets.symmetric(horizontal: Gparam.widthPadding / 2),
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.all(Radius.circular(12.0)),
            gradient: new LinearGradient(
                colors: [
                  Colors.black26,
                  Colors.black45,
                ],
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                stops: [1.0, 0.0],
                tileMode: TileMode.clamp),
          ),
          child: Center(
            child: Text(
              hrsList[i],
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: Gparam.textSmaller,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      );
    if (mounted)
      entriesMins = List<Widget>.generate(
        2,
        (i) => Container(
          height: 30,
          margin: EdgeInsets.only(right: Gparam.widthPadding / 2),
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.all(Radius.circular(12.0)),
            gradient: new LinearGradient(
                colors: [
                  Colors.black26,
                  Colors.black45,
                ],
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                stops: [1.0, 0.0],
                tileMode: TileMode.clamp),
          ),
          child: Center(
            child: Text(
              minsList[i],
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: Gparam.textSmaller,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );

    super.initState();
  }

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
                  Text('Add Event',
                      style: TextStyle(
                          fontFamily: 'Zillaslab',
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
                        hintText: 'Type event name',
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
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Gparam.widthPadding / 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text('Date of event',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: Gparam.textSmall,
                              fontWeight: FontWeight.w500,
                            )),
                        SizedBox(
                          width: 8,
                        ),
                        Text(deadlineToStr(widget.deadlineDouble),
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: Gparam.textSmall,
                                fontWeight: FontWeight.w500,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 50,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 30,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0)
                            return SizedBox(
                              width: Gparam.widthPadding / 3,
                            );
                          return makeDayTile(
                            date: DateTime.now().add(Duration(days: index - 1)),
                            context: context,
                            index: index - 1,
                          );
                        }),
                  ),
                  SizedBox(
                    height: Gparam.heightPadding,
                  ),
                  Row(
                    children: [
                      SizedBox(
                    width: Gparam.widthPadding/2,
                  ),
                       Container(
                        height: 40,
                        width:40,
                        child: Text(getTimeEmoji(widget.deadlineDouble),
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 32,
                                fontWeight: FontWeight.w500,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor)),
                      ),
                      Container(
                        height: 40,
                        width: 80,
                        child: ListWheelScrollView(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          children: entriesHrs,
                          perspective:
                              RenderListWheelViewport.defaultPerspective,
                          diameterRatio:
                              RenderListWheelViewport.defaultPerspective,
                          itemExtent: 40,
                          physics: FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (value) {
                            setState(() {
                              print(value);
                            });
                            hrs = value;

                            
                          },
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 80,
                        child: ListWheelScrollView(
                          children: entriesMins,
                          perspective:
                              RenderListWheelViewport.defaultPerspective,
                          diameterRatio:
                              RenderListWheelViewport.defaultPerspective,
                          physics: FixedExtentScrollPhysics(),
                          itemExtent: 40,
                          onSelectedItemChanged: (value) {
                            setState(() {
                               mins = value;
                            });
                           
                            print(value);
                          },
                        ),
                      ),
                     
                    ],
                  ),
                  SizedBox(
                    height: Gparam.heightPadding,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Gparam.widthPadding / 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text('Duration of event',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: Gparam.textSmall,
                              fontWeight: FontWeight.w500,
                            )),
                        SizedBox(
                          width: 8,
                        ),
                        Text(deadlineToStr(widget.deadlineDouble),
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: Gparam.textSmall,
                                fontWeight: FontWeight.w500,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor)),
                      ],
                    ),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(.5),
                      inactiveTrackColor:
                          Theme.of(context).canvasColor.withOpacity(.2),
                      trackShape: RectangularSliderTrackShape(),
                      trackHeight: 4.0,
                      overlayShape:
                          RoundSliderOverlayShape(overlayRadius: 28.0),
                      tickMarkShape: RoundSliderTickMarkShape(),
                      valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                      thumbColor: Theme.of(context).scaffoldBackgroundColor,
                      thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 12.0),
                      overlayColor: Colors.black.withAlpha(32),
                      valueIndicatorColor: Theme.of(context).accentColor,
                    ),
                    child: Slider(
                      value: widget.deadlineDouble,
                      label: '${widget.deadlineDouble.floor()}',
                      min: 0,
                      max: 1,
                      onChanged: (value) {
                        setState(() {
                          widget.onDeadlineChanged(value);
                        });

                        //widget.onSliderChange(value);
                      },
                    ),
                  ),
                ],
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
                  text: (index == 0 || index == 1)
                      ? (index == 1) ? "Tomorrow" : "Today"
                      : dayInWeek[date.weekday].toString(),
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

  String getTimeEmoji(double deadlineDouble) {
    
    if (mins == 00) {
      if (hrs == 11)
        return emojiTimeList[0];
      else {
        return emojiTimeList[(hrs + 1) * 2];
      }
    }

    else {
      if (hrs == 11)
        return emojiTimeList[1];
      else {
        return emojiTimeList[((hrs + 1) * 2)+1];
      }


    }
  }
}
