part of 'slider_bloc.dart';

abstract class SliderEvent extends Equatable {
  const SliderEvent();
}

class LoadSlider extends SliderEvent {
  final BlockInfo block;
  LoadSlider(this.block);

  @override
  List<Object> get props => [block];
}

class UpdateSliderValue extends SliderEvent {
  final SliderBlock newSlider;
  UpdateSliderValue(this.newSlider);

  @override
  List<Object> get props => [newSlider];
}
