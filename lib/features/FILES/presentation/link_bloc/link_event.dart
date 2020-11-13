part of 'link_bloc.dart';

abstract class LinkEvent extends Equatable {
  const LinkEvent();
}

class GetLink extends LinkEvent {
  final BlockInfo block;
  GetLink(this.block);

  @override
  List<Object> get props => [block];
}



