import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:collection/collection.dart';

class AddTask extends StatefulWidget {
  const AddTask({
    Key key,
    @required this.newMediaLinkAddressController,
    @required this.deadlineDouble,
    @required this.onDeadlineChanged,
    @required this.onPriorityChanged,
    @required this.priorityDouble,
    @required this.saveTask,
    @required this.onTitleChanged,
    @required this.valid,
    @required this.validString,
    @required this.tags,
    @required this.onTagsUpdated,
  });

  final TextEditingController newMediaLinkAddressController;
  final Function(double value) onDeadlineChanged;
  final Function(double value) onPriorityChanged;
  final Function(String title) onTitleChanged;
  final Function(List<String> tags) onTagsUpdated;
  final Function() saveTask;
  final double deadlineDouble;
  final List<String> tags;
  final double priorityDouble;
  final int valid;
  final String validString;

  @override
  State<StatefulWidget> createState() => AddTaskState();
}

class AddTaskState extends State<AddTask> {
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
            InkWell(
              onTap: () {
                print("save0");
                widget.saveTask();
              },
              child: Padding(
                padding: EdgeInsets.all(Gparam.widthPadding / 2),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius:
                            new BorderRadius.all(Radius.circular(30.0)),
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
                      child: Icon(OMIcons.add, size: 16),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                        (widget.valid != 0) ? 'Add Task' : '👈 press when done',
                        style: TextStyle(
                            fontFamily: 'Zillaslab',
                            fontSize: Gparam.textSmall,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).primaryColor)),
                  ],
                ),
              ),
            ),
            if (widget.valid != 0)
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: Gparam.widthPadding / 2),
                child: Row(
                  children: [
                    Text(widget.validString,
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).primaryColor)),
                  ],
                ),
              ),
            if (widget.valid != 0)
              SizedBox(
                height: 4,
              ),
            if (widget.tags != null && widget.tags.length > 0)
              Container(
                height: 25,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.tags.length + 1,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return SizedBox(width: Gparam.widthPadding / 2);
                    }

                    return _buildTagCard(
                      index - 1,
                      widget.tags[index - 1],
                    );
                  },
                ),
              ),
            if (widget.tags != null && widget.tags.length == 0)
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: Gparam.widthPadding / 2),
                child: Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'use',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).primaryColor),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' # ',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Theme.of(context).primaryColor),
                          ),
                          TextSpan(
                            text: 'to add ',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColor),
                          ),
                          TextSpan(
                            text: 'tags',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Theme.of(context).primaryColor),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(
              height: 4,
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
                      cursorColor: Theme.of(context).scaffoldBackgroundColor,
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: Gparam.textSmall,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).scaffoldBackgroundColor),
                      onSubmitted: (text) {
                        widget.saveTask();
                      },
                      onChanged: (text) {
                        widget.onTitleChanged(text);
                        print("cool");
                        RegExp exp = new RegExp(r"#(\w+)");
                        List<String> newTags = [];

                        Iterable<Match> matches = exp.allMatches(text);
                        matches.forEach((m) => newTags.add(m.group(0)));
                        Function eq = const ListEquality().equals;
                        if (!eq(newTags, widget.tags)) {
                          widget.onTagsUpdated(newTags);
                        }
                        print(text.allMatches(r"#(\w+)"));
                      },
                      decoration: InputDecoration.collapsed(
                        hintText: 'Type task name',
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
                        Text('Deadline',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: Gparam.textSmaller,
                              fontWeight: FontWeight.w500,
                            )),
                        SizedBox(
                          width: 8,
                        ),
                        Text(deadlineToStr(widget.deadlineDouble),
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: Gparam.textSmaller,
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
                  Padding(
                    padding: EdgeInsets.only(
                        left: Gparam.widthPadding / 2,
                        right: Gparam.widthPadding / 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Priority',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: Gparam.textSmaller,
                              fontWeight: FontWeight.w500,
                            )),
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
                            valueIndicatorShape:
                                PaddleSliderValueIndicatorShape(),
                            thumbColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            thumbShape:
                                RoundSliderThumbShape(enabledThumbRadius: 12.0),
                            overlayColor: Colors.black.withAlpha(32),
                            valueIndicatorColor: Theme.of(context).accentColor,
                          ),
                          child: Slider(
                            value: widget.priorityDouble,
                            label: '${widget.priorityDouble.floor()}',
                            min: 0,
                            max: 1,
                            onChanged: (value) {
                              setState(() {
                                widget.onPriorityChanged(value);
                              });

                              //
                            },
                          ),
                        ),
                        Text(
                            priorityToStr(
                              widget.priorityDouble,
                            ),
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: Gparam.textSmaller,
                                fontWeight: FontWeight.w700,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor)),
                      ],
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

  Color getContrastColor(Color color) {
    double y = (299 * color.red + 587 * color.green + 114 * color.blue) / 1000 ;
    print(y);
    return y >= 128 ? Colors.black : Colors.white;
  }

  Widget _buildTagCard(int i, String tag) {
    return Container(
      margin: EdgeInsets.all(2),
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: new BorderRadius.all(Radius.circular(4.0)),
        gradient: new LinearGradient(
            colors: [
              Colors.primaries[tag.hashCode % (Colors.primaries.length)],
              Colors.primaries[tag.hashCode % (Colors.primaries.length)]
            ],
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            stops: [0.3, 0.8],
            tileMode: TileMode.clamp),
      ),
      child: Text(tag,
          style: TextStyle(
              color: getContrastColor(
                  Colors.primaries[tag.hashCode % (Colors.primaries.length)]),
              fontFamily: 'Montserrat',
              fontSize: Gparam.textVerySmall,
              height: 1.4,
              fontWeight: FontWeight.w500)),
    );
  }
}
