part of 'date_bloc.dart';

abstract class DateState extends Equatable {
  const DateState();
}

class DateInitial extends DateState {
  @override
  List<Object> get props => [];
}

class DateLoaded extends DateState {
  final FormFieldBlock item;
  final List<String> dateStrings;
  final DateTime dateTime;

  final BlockInfo blockInfo;

  DateLoaded(this.blockInfo, this.item, this.dateStrings, this.dateTime);
  @override
  List<Object> get props => [item, blockInfo];
}

class DateError extends DateState {
  final String message;

  DateError({this.message});

  @override
  List<Object> get props => [message];
}
