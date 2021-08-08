import 'dart:async';
import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:sorted/features/CONNECT/domain/repositories/connect_repository.dart';
import 'package:sorted/features/CONNECT/presentation/class_summary_bloc/class_summary_bloc.dart';
import 'package:sorted/features/CONNECT/presentation/widgets/summary/timetable_day_widget_view.dart';
import 'package:sorted/features/HOME/data/models/class_model.dart';
part 'class_timetable_event.dart';
part 'class_timetable_state.dart';

class ClassTimetableBloc
    extends Bloc<ClassTimetableEvent, ClassTimetableState> {
  final ClassSummaryBloc classSummaryBloc;
  final ConnectRepository repository;
  ClassTimetableBloc(this.classSummaryBloc, this.repository)
      : super(TimetableInitial());
  final DateFormat formatter = DateFormat('jm');
  @override
  Stream<ClassTimetableState> mapEventToState(
    ClassTimetableEvent event,
  ) async* {
    if (event is GetTimetable) {
      ClassModel classroom = event.classroom;
      List<WeekdayClass> days = makeTimetableFromClassroom(classroom);
      yield TimetableLoaded(days, classroom);
    }

    
  }

  List<String> checkIfTimetableisActive(ClassModel classroom) {
    List<String> days = [];
    if ((classroom.mon == 1)) days.add('Mon');
    if (classroom.tue == 1) days.add('Tue');
    if (classroom.wed == 1) days.add('Wed');
    if (classroom.thu == 1) days.add('Thu');
    if (classroom.fri == 1) days.add('Fri');
    if (classroom.sat == 1) days.add('Sat');
    if (classroom.sun == 1) days.add('Sun');
    return days;
  }

  ClassModel makeClassFromId(int id, ClassModel classroom,
      {bool toggle, DateTime fromTime, DateTime toTime}) {
    switch (id) {
      case 0:
        if (toggle != null)
          classroom = classroom.copyWith(mon: 1 - classroom.mon);
        if (fromTime != null) {
          print("monStart: fromTime $fromTime");
          classroom = classroom.copyWith(monStart: fromTime);
        }
        if (toTime != null) {
          print("monStart: fromTime $toTime");
          classroom = classroom.copyWith(monEnd: toTime);
        }
        return classroom;
        break;
      case 1:
        if (toggle != null)
          classroom = classroom.copyWith(tue: 1 - classroom.tue);
        if (fromTime != null)
          classroom = classroom.copyWith(tueStart: fromTime);
        if (toTime != null) classroom = classroom.copyWith(tueEnd: toTime);
        return classroom;
        break;
      case 2:
        if (toggle != null)
          classroom = classroom.copyWith(wed: 1 - classroom.wed);
        if (fromTime != null)
          classroom = classroom.copyWith(wedStart: fromTime);
        if (toTime != null) classroom = classroom.copyWith(wedEnd: toTime);
        return classroom;
        break;
      case 3:
        if (toggle != null)
          classroom = classroom.copyWith(thu: 1 - classroom.thu);
        if (fromTime != null)
          classroom = classroom.copyWith(thuStart: fromTime);
        if (toTime != null) classroom = classroom.copyWith(thuEnd: toTime);
        return classroom;
        break;
      case 4:
        if (toggle != null)
          classroom = classroom.copyWith(fri: 1 - classroom.fri);
        if (fromTime != null)
          classroom = classroom.copyWith(friStart: fromTime);
        if (toTime != null) classroom = classroom.copyWith(friEnd: toTime);
        return classroom;
      case 5:
        if (toggle != null)
          classroom = classroom.copyWith(sat: 1 - classroom.sat);
        if (fromTime != null)
          classroom = classroom.copyWith(satStart: fromTime);
        if (toTime != null) classroom = classroom.copyWith(satEnd: toTime);
        return classroom;
      case 6:
        if (toggle != null)
          classroom = classroom.copyWith(sun: 1 - classroom.sun);
        if (fromTime != null)
          classroom = classroom.copyWith(sunStart: fromTime);
        if (toTime != null) classroom = classroom.copyWith(sunEnd: toTime);
        return classroom;

      default:
    }
  }

  List<WeekdayClass> makeTimetableFromClassroom(ClassModel classroom) {
    //Monday
    WeekdayClass monday = WeekdayClass(0,
        day: "Monday",
        isEnabled: (classroom.mon),
        fromTime:
            formatter.format(classroom.monStart ?? DateTime(2000, 1, 1, 7, 00)),
        toTime:
            formatter.format(classroom.monEnd ?? DateTime(2000, 1, 1, 8, 00)));
    WeekdayClass tuesday = WeekdayClass(1,
        day: "Tuesday",
        isEnabled: (classroom.tue),
        fromTime:
            formatter.format(classroom.tueStart ?? DateTime(2000, 1, 1, 7, 00)),
        toTime:
            formatter.format(classroom.thuEnd ?? DateTime(2000, 1, 1, 8, 00)));
    WeekdayClass wednesday = WeekdayClass(2,
        day: "Wednesday",
        isEnabled: (classroom.wed),
        fromTime:
            formatter.format(classroom.wedStart ?? DateTime(2000, 1, 1, 7, 00)),
        toTime:
            formatter.format(classroom.wedEnd ?? DateTime(2000, 1, 1, 8, 00)));
    WeekdayClass thrusday = WeekdayClass(3,
        day: "Thrusday",
        isEnabled: (classroom.thu),
        fromTime:
            formatter.format(classroom.thuStart ?? DateTime(2000, 1, 1, 7, 00)),
        toTime:
            formatter.format(classroom.thuEnd ?? DateTime(2000, 1, 1, 8, 00)));
    WeekdayClass friday = WeekdayClass(4,
        day: "Friday",
        isEnabled: (classroom.fri),
        fromTime:
            formatter.format(classroom.friStart ?? DateTime(2000, 1, 1, 7, 00)),
        toTime:
            formatter.format(classroom.friEnd ?? DateTime(2000, 1, 1, 8, 00)));
    WeekdayClass saturday = WeekdayClass(5,
        day: "Saturday",
        isEnabled: (classroom.sat),
        fromTime:
            formatter.format(classroom.satStart ?? DateTime(2000, 1, 1, 7, 00)),
        toTime:
            formatter.format(classroom.satEnd ?? DateTime(2000, 1, 1, 8, 00)));

    WeekdayClass sunday = WeekdayClass(6,
        day: "Sunday",
        isEnabled: (classroom.sun),
        fromTime:
            formatter.format(classroom.sunStart ?? DateTime(2000, 1, 1, 7, 00)),
        toTime:
            formatter.format(classroom.sunEnd ?? DateTime(2000, 1, 1, 8, 00)));
    return [monday, tuesday, wednesday, thrusday, friday, saturday, sunday];
  }
}
