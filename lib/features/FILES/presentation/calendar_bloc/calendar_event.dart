part of 'calendar_bloc.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();
}

class GetCalendar extends CalendarEvent {
  final BlockInfo block;
  GetCalendar(this.block);

  @override
  List<Object> get props => [block];
}

class ChangeMonth extends CalendarEvent {
  final DateTime nextMonthDate;
  ChangeMonth(this.nextMonthDate);

  @override
  List<Object> get props => [nextMonthDate];
}

class AddCalendarEvent extends CalendarEvent {
  final CalendarEventBlock event;
  AddCalendarEvent(this.event);

  @override
  List<Object> get props => [event];
}

class SelectDate extends CalendarEvent {
  final DateTime selectedDate;
  SelectDate(this.selectedDate);

  @override
  List<Object> get props => [selectedDate];
}
