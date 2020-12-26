part of 'heading_bloc.dart';

abstract class HeadingEvent extends Equatable {
  const HeadingEvent();
}

class UpdateHeading extends HeadingEvent {
  final BlockInfo block;
  UpdateHeading(this.block);

  @override
  List<Object> get props => [block];
}

class UpdateDecoration extends HeadingEvent {
  final int newDecoration;
  final HeadingBlock headingBlock;
  UpdateDecoration(this.newDecoration, this.headingBlock);

  @override
  List<Object> get props => [newDecoration, headingBlock];
}
