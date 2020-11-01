import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/constants/constants.dart';

class AddGoal extends StatefulWidget {
  const AddGoal({
    Key key,
    @required this.newMediaLinkAddressController,
    @required this.deadlineDouble,
    @required this.onDeadlineChanged,
  });

  final TextEditingController newMediaLinkAddressController;
  final Function(double value) onDeadlineChanged;
  final double deadlineDouble;

  @override
  State<StatefulWidget> createState() => AddGoalState();
}

class AddGoalState extends State<AddGoal> {
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

  String deadlineToStr(double d) {
    int days = d.floor();
    if (days < 30) {
      if (days <= 1)
        return (days).floor().toString() + " day";
      else
        return (days).floor().toString() + " days";
    } else if (days < 360) {
      int m = (days / 30).floor();
      if (m <= 1)
        return (days / 30).floor().toString() + " month";
      else
        return (days / 30).floor().toString() + " months";
    } else {
      days = days * (days - 359);

      return (days / 360).floor().toString() + " years";
    }
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
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0)),
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
                      child: Icon(OMIcons.add),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Add Goal',
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
                          hintText: 'Type goal name',
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
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor)),
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
                        max: 380,
                        onChanged: (value) {
                          setState(() {
                              widget.onDeadlineChanged(value);
                          });
                        

                          //widget.onSliderChange(value);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Gparam.widthPadding / 2),
                      child: TextField(
                        style: TextStyle(
                          fontFamily: 'ZillaSlab',
                          fontSize: Gparam.textMedium,
                        ),
                        decoration: InputDecoration.collapsed(
                          hintText: 'Add description ?',
                          hintStyle: TextStyle(
                            fontSize: Gparam.textSmall,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        controller: widget.newMediaLinkAddressController,
                      ),
                    ),
                  ],
                ),
              ),

              // Padding(
              //   padding: EdgeInsets.only(
              //       left: Gparam.widthPadding / 2,
              //       right: Gparam.widthPadding / 2),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: [
              //       Text('Priority',
              //           style: TextStyle(
              //               fontFamily: 'Montserrat',
              //               fontSize: Gparam.textSmall,
              //               fontWeight: FontWeight.w500,
              //               color: Theme.of(context).primaryColor)),
              //       SliderTheme(
              //         data: SliderTheme.of(context).copyWith(
              //           activeTrackColor: Theme.of(context).accentColor,
              //           inactiveTrackColor: Theme.of(context)
              //               .canvasColor
              //               .withOpacity(.2),
              //           trackShape: RectangularSliderTrackShape(),
              //           trackHeight: 4.0,
              //           overlayShape: RoundSliderOverlayShape(
              //               overlayRadius: 28.0),
              //           tickMarkShape: RoundSliderTickMarkShape(),
              //           valueIndicatorShape:
              //               PaddleSliderValueIndicatorShape(),
              //           thumbColor: Theme.of(context).primaryColor,
              //           thumbShape: RoundSliderThumbShape(
              //               enabledThumbRadius: 12.0),
              //           overlayColor: Colors.red.withAlpha(32),
              //           valueIndicatorColor:
              //               Theme.of(context).accentColor,
              //         ),
              //         child: Slider(
              //           value: _valueBudget,
              //           label: '${_valueBudget.floor()}',
              //           min: 0,
              //           max: 1,
              //           onChanged: (value) {
              //             setState(() {
              //               _valueBudget = value;
              //             });

              //             //widget.onSliderChange(value);
              //           },
              //         ),
              //       ),
              //       Text(priorityToStr(_valueBudget),
              //           style: TextStyle(
              //               fontFamily: 'Montserrat',
              //               fontSize: Gparam.textSmall,
              //               fontWeight: FontWeight.w700,
              //               color: Theme.of(context).primaryColor)),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      );
    }
}
