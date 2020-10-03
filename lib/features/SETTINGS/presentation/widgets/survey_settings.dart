import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sorted/core/global/constants/constants.dart';

class SurveySettings extends StatefulWidget {
  const SurveySettings({
    Key key,
    @required this.autofill,
    @required double valueSurveyTime,
    @required this.onSliderChange,
  })  : _valueSurveyTime = valueSurveyTime,
        super(key: key);

  final bool autofill;
  final Function(double timeValue) onSliderChange;
  final double _valueSurveyTime;

  @override
  State<StatefulWidget> createState() => SurveySettingsState();
}

class SurveySettingsState extends State<SurveySettings> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: Gparam.widthPadding,
              top: Gparam.heightPadding * 2,
              bottom: Gparam.heightPadding,
              right: Gparam.widthPadding),
          child: Text('Survey Settings',
              style: TextStyle(
                  fontFamily: 'ZillaSlab',
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
        ),
        buildCardWidget(
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
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
                  child: Icon(OMIcons.autorenew),
                ),
                SizedBox(
                  width: Gparam.widthPadding / 2,
                ),
                Text('Auto-Fill',
                    style: TextStyle(
                        fontFamily: 'Eastman',
                        fontSize: 16,
                        color: Theme.of(context).primaryColor)),
                Spacer(),
                Row(
                  children: <Widget>[
                    Container(
                      width: 60,
                      child: Switch(
                        value: widget.autofill,
                        onChanged: (value) async {

                          
                        },
                        activeColor:
                            (Theme.of(context).brightness == Brightness.dark)
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).primaryColor,
                        activeTrackColor:
                            (Theme.of(context).brightness == Brightness.dark)
                                ? Theme.of(context).backgroundColor
                                : Theme.of(context).primaryColorLight,
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                      ),
                    ),
                  ],
                )
              ],
            ),
            context),
        buildCardWidget(
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius:
                              new BorderRadius.all(Radius.circular(30.0)),
                          gradient: new LinearGradient(
                              colors: [
                                Theme.of(context).primaryColor,
                                (Theme.of(context).brightness ==
                                        Brightness.dark)
                                    ? Theme.of(context).backgroundColor
                                    : Theme.of(context).primaryColorLight,
                              ],
                              begin: FractionalOffset.topCenter,
                              end: FractionalOffset.bottomCenter,
                              stops: [.2, .8],
                              tileMode: TileMode.repeated),
                        ),
                        child: Icon(OMIcons.timelapse)),
                    SizedBox(
                      width: Gparam.widthPadding / 2,
                    ),
                    Text('Survey Time',
                        style: TextStyle(
                            fontFamily: 'Eastman',
                            fontSize: 16,
                            color: Theme.of(context).primaryColor)),
                  ],
                ),
                SizedBox(
                  height: Gparam.heightPadding,
                ),
                Row(
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: 0, left: 00),
                        padding: EdgeInsets.all(8),
                        alignment: Alignment.centerLeft,
                        decoration: new BoxDecoration(),
                        child: Text(
                          "General filling time",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: 'Eastman',
                            fontSize: 16.0,
                          ),
                        )),
                    Spacer(),
                    Text(
                      "${widget._valueSurveyTime.floor()} mins",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'ZillaSlab',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(
                      width: Gparam.widthPadding / 2,
                    ),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Theme.of(context).accentColor,
                    inactiveTrackColor:
                        Theme.of(context).canvasColor.withOpacity(.2),
                    trackShape: RectangularSliderTrackShape(),
                    trackHeight: 4.0,
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                    tickMarkShape: RoundSliderTickMarkShape(),
                    valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                    thumbColor: Theme.of(context).primaryColor,
                    valueIndicatorColor: Theme.of(context).accentColor,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                    overlayColor: Colors.red.withAlpha(32),
                  ),
                  child: Slider(
                    value: widget._valueSurveyTime,
                    label: '${widget._valueSurveyTime.floor()} mins',
                    min: 10,
                    max: 60,
                    divisions: 5,
                    onChanged: (value) {
                      widget.onSliderChange(value);
                    },
                  ),
                ),
                SizedBox(
                  height: Gparam.heightPadding / 2,
                ),
              ],
            ),
            context),
      ],
    );
  }

  Widget buildCardWidget(Widget child, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).dialogBackgroundColor.withOpacity(.3),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                offset: Offset(1, 1),
                color: (Theme.of(context).brightness == Brightness.light)
                    ? Colors.black.withAlpha(10)
                    : Theme.of(context).primaryColor.withAlpha(20),
                blurRadius: 1)
          ]),
      margin: EdgeInsets.only(
          left: Gparam.widthPadding,
          right: Gparam.widthPadding,
          top: Gparam.heightPadding / 2),
      padding: EdgeInsets.all(Gparam.widthPadding / 2),
      child: child,
    );
  }
}
