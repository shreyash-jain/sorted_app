import 'package:flutter/material.dart';
import 'package:sorted/core/global/widgets/CustomSliderThumbCircle.dart';
import 'package:sorted/core/global/widgets/CustomSliderThumbRect.dart';

class SliderRatingWidget extends StatefulWidget {
  final double sliderHeight;
  final int min;
  final int max;
  final String minString;
  final String maxString;
  final int precision;
  final fullWidth;
  final String unit;
  final Function(double) onUpdate;

  SliderRatingWidget(
      {this.sliderHeight = 48,
      this.max = 10,
      this.min = 0,
      this.fullWidth = false,
      this.unit,
      this.precision,
      this.onUpdate,
      this.minString,
      this.maxString});

  @override
  _SliderRatingWidgetState createState() => _SliderRatingWidgetState();
}

class _SliderRatingWidgetState extends State<SliderRatingWidget> {
  double _value = 0;

  @override
  Widget build(BuildContext context) {
    double paddingFactor = .2;

    if (this.widget.fullWidth) paddingFactor = .3;

    return Container(
      width: this.widget.fullWidth
          ? double.infinity
          : (this.widget.sliderHeight) * 5.5,
      height: (this.widget.sliderHeight) * 2,
      child: Padding(
        padding: EdgeInsets.fromLTRB(this.widget.sliderHeight * paddingFactor,
            2, this.widget.sliderHeight * paddingFactor, 2),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: this.widget.sliderHeight * .1,
                ),
                Expanded(
                  child: Center(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Theme.of(context).primaryColor,
                        inactiveTrackColor: Colors.black.withOpacity(.1),
                        trackHeight: 6.0,
                        thumbColor: Colors.white,
                        valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                        thumbShape: CustomSliderThumbCircle(
                          thumbRadius: this.widget.sliderHeight * .4,
                          min: this.widget.min,
                          max: this.widget.max,
                        ),
                        overlayColor: Theme.of(context).primaryColor,
                        valueIndicatorColor: Colors.grey,
                        activeTickMarkColor: Theme.of(context).primaryColor,
                        inactiveTickMarkColor: Theme.of(context).primaryColor,
                      ),
                      child: Slider(
                          value: _value,
                          label: (_value * (widget.max))
                                      .toStringAsFixed(widget.precision)
                                      .toString() +
                                  " " +
                                  this.widget.unit ??
                              "",
                          divisions: 20,
                          onChanged: (value) {
                            setState(() {
                              _value = value;
                            });
                            widget.onUpdate(_value);
                          }),
                    ),
                  ),
                ),
                SizedBox(
                  width: this.widget.sliderHeight * .1,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Text(
                  '${this.widget.minString}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: this.widget.sliderHeight * .3,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontFamily: "Milliard",
                  ),
                ),
                Spacer(),
                Text(
                  '${this.widget.maxString}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: this.widget.sliderHeight * .3,
                    fontFamily: "Milliard",
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
