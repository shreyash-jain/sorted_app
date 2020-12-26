part of 'password_bloc.dart';

abstract class PasswordEvent extends Equatable {
  const PasswordEvent();
}

class GetPassword extends PasswordEvent {
  final BlockInfo block;
  GetPassword(this.block);

  @override
  List<Object> get props => [block];
}



