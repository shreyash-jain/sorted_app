import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/features/FILES/data/models/block_calendar.dart';
import 'package:sorted/features/FILES/data/models/block_calendar_event.dart';
import 'package:sorted/features/FILES/data/models/block_info.dart';
import 'package:sorted/features/FILES/data/models/block_textbox.dart';
import 'package:sorted/features/FILES/domain/repositories/note_repository.dart';
import 'package:sorted/features/FILES/presentation/note_bloc/note_bloc.dart';
import 'package:sorted/features/PLAN/data/models/todo.dart';
import 'package:sorted/features/PLAN/data/models/todo_item.dart';
import 'package:sorted/features/PLAN/domain/repositories/task_repository.dart';
import 'package:sorted/features/PLAN/domain/repositories/todo_repository.dart';
import 'package:zefyr/zefyr.dart';
part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final NoteRepository noteRepository;
  final NoteBloc noteBloc;
  final TaskRepository taskRepository;
  CalendarBloc(this.noteRepository, this.noteBloc, this.taskRepository)
      : super(CalendarInitial());
  @override
  Stream<CalendarState> mapEventToState(
    CalendarEvent event,
  ) async* {
    if (event is GetCalendar) {
      print("UpdateTextbox  " + event.block.id.toString());
      Failure failure;
      CalendarBlock calendarBlock;
      var calendarOrFailure =
          await noteRepository.getCalendarBlock(event.block.itemId);
      calendarOrFailure.fold((l) {
        failure = l;
      }, (r) {
        calendarBlock = r;
      });
      print("heelo  " + calendarBlock.toString());
      List<CalendarEventBlock> thisMonthEvents = [];
      List<CalendarEventBlock> thisDayEvents = [];
      List<DateTime> thisMonthEventDates = [];
      DateTime now = DateTime.now();
      DateTime monthStartDay = DateTime(now.year, now.month);
      var lastDayDateTime = (now.month < 12)
          ? new DateTime(now.year, now.month + 1, 0)
          : new DateTime(now.year + 1, 1, 0);
      DateTime monthEndDay = lastDayDateTime;
      var monthEventsOrFailure = await noteRepository.getCalendarEventsBlock(
          calendarBlock.id, monthStartDay, monthEndDay);
      monthEventsOrFailure.fold((l) {
        failure = l;
      }, (r) {
        thisMonthEvents = r;
      });
      print("evshreyash 1  " + failure.toString());

      thisMonthEvents.forEach((element) {
        thisMonthEventDates.add(
            DateTime(element.date.year, element.date.month, element.date.day));
      });

      DateTime yesterday = now.add(Duration(days: -1));
      DateTime tomorrow = now.add(Duration(days: 0));
      var yesEnd =
          DateTime(yesterday.year, yesterday.month, yesterday.day, 0, 0);
      var tomStart =
          DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 0, 0);

      var dayEventsOrFailure = await noteRepository.getCalendarEventsBlock(
          calendarBlock.id, yesEnd, tomStart);
      dayEventsOrFailure.fold((l) {
        failure = l;
      }, (r) {
        thisDayEvents = r;
      });
      print("evshreyash 2  " + failure.toString());

      print("evshreyash  " +
          failure.toString() +
          thisDayEvents.length.toString());
      if (failure == null)
        yield CalendarLoaded(thisMonthEventDates, event.block, calendarBlock,
            now, thisDayEvents);
    } else if (event is ChangeMonth) {
      DateTime monthDate = event.nextMonthDate;
      Failure failure;
      CalendarLoaded prevState =
          (state is CalendarLoaded) ? (state as CalendarLoaded) : null;
      DateTime monthStartDay = DateTime(monthDate.year, monthDate.month);
      var lastDayDateTime = (monthDate.month < 12)
          ? new DateTime(monthDate.year, monthDate.month + 1, 0)
          : new DateTime(monthDate.year + 1, 1, 0);
      DateTime monthEndDay = lastDayDateTime;
      List<CalendarEventBlock> thisMonthEvents = [];
      var monthEventsOrFailure = await noteRepository.getCalendarEventsBlock(
          prevState.calendarBlock.id, monthStartDay, monthEndDay);
      monthEventsOrFailure.fold((l) {
        failure = l;
      }, (r) {
        thisMonthEvents = r;
      });
      List<DateTime> thisMonthEventDates = [];
      thisMonthEvents.forEach((element) {
        thisMonthEventDates.add(
            DateTime(element.date.year, element.date.month, element.date.day));
      });

      yield CalendarLoaded(
          thisMonthEventDates,
          prevState.blockInfo,
          prevState.calendarBlock,
          prevState.selectedDate,
          prevState.selectedDayEvents);
    } else if (event is SelectDate) {
      print("hhhh0" + event.selectedDate.toString());
      DateTime selectedDate = event.selectedDate;
      Failure failure;
      CalendarLoaded prevState =
          (state is CalendarLoaded) ? (state as CalendarLoaded) : null;
      DateTime yesterday = selectedDate.add(Duration(days: -1));
      DateTime tomorrow = selectedDate.add(Duration(days: 0));
      var yesEnd =
          DateTime(yesterday.year, yesterday.month, yesterday.day, 0, 1);
      print(yesEnd.toString() + "    jjjj");

      var tomStart =
          DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 0, 1);
      print(tomStart.toString() + "    jjjj");
      List<CalendarEventBlock> selectedDayEvents = [];
      var monthEventsOrFailure = await noteRepository.getCalendarEventsBlock(
          prevState.calendarBlock.id, yesEnd, tomStart);
      print("ca;l;ll  " + prevState.calendarBlock.id.toString());
      monthEventsOrFailure.fold((l) {
        failure = l;
      }, (r) {
        selectedDayEvents = r;
      });

      print(selectedDayEvents.length.toString() + " hdhdhdh");

      yield CalendarLoaded(prevState.thisMonthEvents, prevState.blockInfo,
          prevState.calendarBlock, selectedDate, selectedDayEvents);
    } else if (event is AddCalendarEvent) {
      CalendarEventBlock toAddEvent = event.event;
      DateTime now = DateTime.now();

      CalendarLoaded prevState =
          (state is CalendarLoaded) ? (state as CalendarLoaded) : null;
      toAddEvent = toAddEvent.copyWith(
          id: now.millisecondsSinceEpoch,
          savedTs: now.millisecondsSinceEpoch,
          calId: prevState.calendarBlock.id);
      List<CalendarEventBlock> dayEvents = prevState.selectedDayEvents;
      dayEvents.add(toAddEvent);
      List<DateTime> monthDays = prevState.thisMonthEvents;
      monthDays.add(toAddEvent.date);

      yield CalendarLoaded(monthDays, prevState.blockInfo,
          prevState.calendarBlock, prevState.selectedDate, dayEvents);
      noteRepository.addCalendarEventBlock(toAddEvent);
    }
  }

  @override
  Future<void> close() {
    print(" update textbox");

    return super.close();
  }
}
