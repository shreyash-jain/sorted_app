part of 'calendar_bloc.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();
}

class CalendarInitial extends CalendarState {
  @override
  List<Object> get props => [];
}

class CalendarLoaded extends CalendarState {
  final CalendarBlock calendarBlock;
  final List<DateTime> thisMonthEvents;
  final List<CalendarEventBlock> selectedDayEvents;
  final DateTime selectedDate;
  final BlockInfo blockInfo;

  CalendarLoaded(this.thisMonthEvents, this.blockInfo, this.calendarBlock,
      this.selectedDate, this.selectedDayEvents);
  @override
  List<Object> get props =>
      [calendarBlock, blockInfo, thisMonthEvents, selectedDate, selectedDayEvents];
}

class CalendarError extends CalendarState {
  final String message;

  CalendarError({this.message});

  @override
  List<Object> get props => [message];
}
