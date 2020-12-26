part of 'slider_bloc.dart';

abstract class SliderState extends Equatable {
  const SliderState();
}

class SliderInitial extends SliderState {
  @override
  List<Object> get props => [];
}

class SliderLoaded extends SliderState {
  final SliderBlock sliderBlock;

  final BlockInfo blockInfo;

  SliderLoaded(this.sliderBlock, this.blockInfo);
  @override
  List<Object> get props => [sliderBlock, blockInfo];
}

class SliderError extends SliderState {
  final String message;

  SliderError({this.message});

  @override
  List<Object> get props => [message];
}
