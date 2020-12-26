part of 'date_bloc.dart';

abstract class DateEvent extends Equatable {
  const DateEvent();
}

class GetDate extends DateEvent {
  final BlockInfo block;
  GetDate(this.block);

  @override
  List<Object> get props => [block];
}



class UpdateDate extends DateEvent {
  final FormFieldBlock block;
  UpdateDate(this.block);

  @override
  List<Object> get props => [block];
}

