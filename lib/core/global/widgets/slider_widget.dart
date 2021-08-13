import 'package:flutter/material.dart';
import 'package:sorted/core/global/widgets/CustomSliderThumbRect.dart';

class SliderNumberWidget extends StatefulWidget {
  final double sliderHeight;
  final int min;
  final int max;
  final int precision;
  final fullWidth;
  final String unit;
  final Function(double) onUpdate;
  final double initialValue;

  SliderNumberWidget(
      {this.sliderHeight = 48,
      this.max = 10,
      this.min = 0,
      this.fullWidth = false,
      this.unit,
      this.precision,
      this.onUpdate,
      this.initialValue});

  @override
  _SliderNumberWidgetState createState() => _SliderNumberWidgetState();
}

class _SliderNumberWidgetState extends State<SliderNumberWidget> {
  double _value = 0;

  @override
  void initState() {
    if (widget.initialValue != null &&
        widget.initialValue < widget.max &&
        widget.initialValue > widget.min)
      _value =
          (widget.initialValue - widget.min.toDouble()) / widget.max.toDouble();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double paddingFactor = .2;
    int division = getFromGap(widget.max - widget.min);

    if (this.widget.fullWidth) paddingFactor = .3;

    return Container(
      width: this.widget.fullWidth
          ? double.infinity
          : (this.widget.sliderHeight) * 5.5,
      height: (this.widget.sliderHeight),
      child: Padding(
        padding: EdgeInsets.fromLTRB(this.widget.sliderHeight * paddingFactor,
            2, this.widget.sliderHeight * paddingFactor, 2),
        child: Row(
          children: <Widget>[
            Text(
              '${this.widget.min} ${this.widget.unit ?? ""}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: this.widget.sliderHeight * .3,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontFamily: "Milliard",
              ),
            ),
            SizedBox(
              width: this.widget.sliderHeight * .3,
            ),
            Expanded(
              child: Center(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.grey,
                    inactiveTrackColor: Colors.black.withOpacity(.2),
                    trackHeight: 12.0,
                    thumbColor: Colors.white,
                    valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                    thumbShape: CustomSliderThumbRect(
                      thumbRadius: this.widget.sliderHeight * .4,
                      min: this.widget.min,
                      thumbHeight: this.widget.sliderHeight * 1,
                      max: this.widget.max,
                    ),
                    overlayColor: Colors.black.withOpacity(.4),
                    valueIndicatorColor: Colors.transparent,
                    activeTickMarkColor: Colors.black54,
                    inactiveTickMarkColor: Colors.blue.withOpacity(.7),
                  ),
                  child: Slider(
                      value: _value,
                      label: (_value * (widget.max))
                                  .toStringAsFixed(widget.precision)
                                  .toString() +
                              " " +
                              this.widget.unit ??
                          "",
                      divisions: division,
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
              width: this.widget.sliderHeight * .3,
            ),
            Text(
              '${this.widget.max} ${this.widget.unit ?? ""}',
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
      ),
    );
  }

  int getFromGap(int i) {
    return i * 5;
  }
}
