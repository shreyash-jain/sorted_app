import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sorted/core/global/utility/utils.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/widgets/height_widget/height_slider.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/widgets/height_widget/height_styles.dart';

class HeightPicker extends StatefulWidget {
  final int maxHeight;
  final int minHeight;
  final int height;
  final double widgetHeight;
  final ValueChanged<int> onChange;
  final ValueChanged<BuildContext> onGoBack;

  const HeightPicker(
      {Key key,
      this.height,
      this.widgetHeight,
      this.onChange,
      this.maxHeight = 190,
      this.minHeight = 145,
      this.onGoBack})
      : super(key: key);

  int get totalUnits => maxHeight - minHeight;

  @override
  _HeightPickerState createState() => _HeightPickerState();
}

class _HeightPickerState extends State<HeightPicker> {
  double startDragYOffset;
  int startDragHeight;

  double get _pixelsPerUnit {
    return _drawingHeight / widget.totalUnits;
  }

  double get _sliderPosition {
    double halfOfBottomLabel = labelsFontSize / 2;
    int unitsFromBottom = widget.height - widget.minHeight;
    return halfOfBottomLabel + unitsFromBottom * _pixelsPerUnit;
  }

  ///returns actual input_page.height of slider to be able to slide
  double get _drawingHeight {
    double totalHeight = widget.widgetHeight;
    double marginBottom = marginBottomAdapted(context);
    double marginTop = marginTopAdapted(context);
    return totalHeight - (marginBottom + marginTop + labelsFontSize);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: _onTapDown,
      onVerticalDragStart: _onDragStart,
      onVerticalDragUpdate: _onDragUpdate,
      child: Stack(
        children: <Widget>[
          _drawPersonImage(),
          _drawSlider(),
          _drawLabels(),
        ],
      ),
    );
  }

  _onTapDown(TapDownDetails tapDownDetails) {
    int height = _globalOffsetToHeight(tapDownDetails.globalPosition);
    widget.onChange(_normalizeHeight(height));
  }

  int _normalizeHeight(int height) {
    return math.max(widget.minHeight, math.min(widget.maxHeight, height));
  }

  int _globalOffsetToHeight(Offset globalOffset) {
    RenderBox getBox = context.findRenderObject();
    Offset localPosition = getBox.globalToLocal(globalOffset);
    double dy = localPosition.dy;
    dy = dy - marginTopAdapted(context) - labelsFontSize / 2;
    int height = widget.maxHeight - (dy ~/ _pixelsPerUnit);
    return height;
  }

  _onDragStart(DragStartDetails dragStartDetails) {
    int newHeight = _globalOffsetToHeight(dragStartDetails.globalPosition);
    widget.onChange(newHeight);
    setState(() {
      startDragYOffset = dragStartDetails.globalPosition.dy;
      startDragHeight = newHeight;
    });
  }

  _onDragUpdate(DragUpdateDetails dragUpdateDetails) {
    double currentYOffset = dragUpdateDetails.globalPosition.dy;
    double verticalDifference = startDragYOffset - currentYOffset;
    int diffHeight = verticalDifference ~/ _pixelsPerUnit;
    int height = _normalizeHeight(startDragHeight + diffHeight);
    setState(() => widget.onChange(height));
  }

  Widget _drawSlider() {
    return Positioned(
      child: HeightSlider(height: widget.height),
      left: 0.0,
      right: 0.0,
      bottom: _sliderPosition,
    );
  }

  String convertToFeet(int centimeter) {
    double inch = centimeter / 2.54;

    double foot = inch / 12;
    return "${foot.toInt()} ft ${(inch - foot.floor() * 12).toInt()} \"";
  }

  Widget _drawLabels() {
    int labelsToDisplay = widget.totalUnits ~/ 5 + 1;
    List<Widget> labelsInCM = List.generate(
      labelsToDisplay,
      (idx) {
        return Text(
          "${widget.maxHeight - 5 * idx}",
          style: labelsTextStyle,
        );
      },
    );
    List<Widget> labelsInFeet = List.generate(
      labelsToDisplay,
      (idx) {
        return Text(
          convertToFeet(widget.maxHeight - 5 * idx),
          style: labelsTextStyle,
        );
      },
    );

    return Align(
      alignment: Alignment.centerRight,
      child: IgnorePointer(
        child: Padding(
          padding: EdgeInsets.only(
            right: screenAwareSize(12.0, context),
            bottom: marginBottomAdapted(context),
            top: marginTopAdapted(context),
            left: screenAwareSize(12.0, context),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: labelsInFeet,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
              Column(
                children: labelsInCM,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawPersonImage() {
    double personImageHeight = _sliderPosition + marginBottomAdapted(context);
    return Align(
      alignment: Alignment.bottomCenter,
      child: SvgPicture.asset(
        "assets/images/person.svg",
        height: personImageHeight,
        width: personImageHeight / 3,
      ),
    );
  }
}
