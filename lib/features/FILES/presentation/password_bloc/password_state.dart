part of 'password_bloc.dart';

abstract class PasswordState extends Equatable {
  const PasswordState();
}

class PasswordInitial extends PasswordState {
  @override
  List<Object> get props => [];
}

class PasswordLoaded extends PasswordState {
  final FormFieldBlock item;
  final BlockInfo blockInfo;

  PasswordLoaded(this.item, this.blockInfo);
  @override
  List<Object> get props => [item, blockInfo];
}

class PasswordError extends PasswordState {
  final String message;

  PasswordError({this.message});

  @override
  List<Object> get props => [message];
}
