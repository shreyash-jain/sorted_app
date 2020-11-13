part of 'link_bloc.dart';

abstract class LinkState extends Equatable {
  const LinkState();
}

class LinkInitial extends LinkState {
  @override
  List<Object> get props => [];
}

class LinkLoaded extends LinkState {
  final LinkModel link;
  final BlockInfo blockInfo;

  LinkLoaded(this.link, this.blockInfo);
  @override
  List<Object> get props => [link, blockInfo];
}

class LinkError extends LinkState {
  final String message;

  LinkError({this.message});

  @override
  List<Object> get props => [message];
}
