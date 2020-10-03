import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sorted/core/global/constants/constants.dart';

class ExpenseSettings extends StatefulWidget {
  const ExpenseSettings({
    Key key,
   
 
    @required double valueBudget,
    @required this.onSliderChange,
    @required this.onCurrencyChange,
    @required this.currency,
  })  : _valueBudget = valueBudget,
        super(key: key);

 

  final Function(double timeValue) onSliderChange;
  final Function(int currency, String symbol) onCurrencyChange;
  final double _valueBudget;
  final String currency;

  @override
  State<StatefulWidget> createState() => ExpenseSettingsState();
}

class ExpenseSettingsState extends State<ExpenseSettings> {
  @override
  void initState() {
    super.initState();
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
          child: Text('Expense Settings',
              style: TextStyle(
                  fontFamily: 'ZillaSlab',
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
        ),
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
                              (Theme.of(context).brightness == Brightness.dark)
                                  ? Theme.of(context).backgroundColor
                                  : Theme.of(context).primaryColorLight,
                            ],
                            begin: FractionalOffset.topCenter,
                            end: FractionalOffset.bottomCenter,
                            stops: [.2, .8],
                            tileMode: TileMode.repeated),
                      ),
                      child: Icon(OMIcons.payment),
                    ),
                    SizedBox(
                      width: Gparam.widthPadding / 2,
                    ),
                    Text('Currency',
                        style: TextStyle(
                            fontFamily: 'Eastman',
                            fontSize: 16,
                            color: Theme.of(context).primaryColor)),
                    Spacer(),
                  ],
                ),
                SizedBox(
                  height: Gparam.heightPadding,
                ),
                Row(
                  children: <Widget>[
                    ButtonBar(
                      mainAxisSize: MainAxisSize
                          .min, // this will take space as minimum as posible(to center)
                      children: <Widget>[
                        new ButtonTheme(
                          minWidth: 10,
                          height: 45,
                          buttonColor: Colors.transparent,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(60.0),
                                side: BorderSide(
                                    color: (widget.currency == "₹")
                                        ? Theme.of(context).primaryColor
                                        : Colors.transparent)),
                            // color: Theme.of(context).primaryColor,

                            color: Theme.of(context).scaffoldBackgroundColor,

                            child: new Text("₹",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'ZillaSlab',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20)),
                            onPressed: () {
                              widget.onCurrencyChange(1, "₹");
                            },
                          ),
                        ),
                        new ButtonTheme(
                          minWidth: 10,
                          height: 45,
                          buttonColor: Colors.transparent,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(60.0),
                                side: BorderSide(
                                    color: (widget.currency == "\$")
                                        ? Theme.of(context).primaryColor
                                        : Colors.transparent)),
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: new Text("\$",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'ZillaSlab',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20)),
                            onPressed: () {
                              widget.onCurrencyChange(2, "\$");
                            },
                          ),
                        ),
                        new ButtonTheme(
                          minWidth: 10,
                          height: 45,
                          buttonColor: Colors.transparent,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(60.0),
                                side: BorderSide(
                                    color: (widget.currency == "€")
                                        ? Theme.of(context).primaryColor
                                        : Colors.transparent)),
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: new Text("€",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'ZillaSlab',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20)),
                            onPressed: () {
                              widget.onCurrencyChange(3, "€");
                              // setState(() {
                              //   prefs.setString("currency", );
                              //   selected_currency = 3;
                              // });
                            },
                          ),
                        ),
                        new ButtonTheme(
                          minWidth: 10,
                          height: 45,
                          buttonColor: Colors.transparent,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(60.0),
                                side: BorderSide(
                                    color: (widget.currency == "£")
                                        ? Theme.of(context).primaryColor
                                        : Colors.transparent)),
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: new Text( "£",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'ZillaSlab',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20)),
                            onPressed: () {
                              widget.onCurrencyChange(4,  "£");
                              // setState(() {
                              //   prefs.setString("currency", "£");
                              //   selected_currency = 4;
                              // });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
                        child: Icon(OMIcons.money)),
                    SizedBox(
                      width: Gparam.widthPadding / 2,
                    ),
                    Text('Budget',
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
                          "Monthly budget",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: 'Eastman',
                            fontSize: 16.0,
                          ),
                        )),
                    Spacer(),
                    Text(
                      "${widget._valueBudget.floor()}  ${widget.currency}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
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
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                    overlayColor: Colors.red.withAlpha(32),
                    valueIndicatorColor: Theme.of(context).accentColor,
                  ),
                  child: Slider(
                    value: widget._valueBudget,
                    label: '${widget._valueBudget.floor()} ${widget.currency}',
                    min: 0,
                    max: 100000,
                    divisions: 1000,
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
}
