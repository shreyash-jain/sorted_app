import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/features/FILES/data/models/block_form_field.dart';
import 'package:sorted/features/FILES/data/models/block_info.dart';
import 'package:sorted/features/FILES/data/models/block_textbox.dart';
import 'package:sorted/features/FILES/domain/repositories/note_repository.dart';
import 'package:sorted/features/FILES/presentation/note_bloc/note_bloc.dart';
import 'package:sorted/features/PLAN/data/models/todo.dart';
import 'package:sorted/features/PLAN/data/models/todo_item.dart';
import 'package:sorted/features/PLAN/domain/repositories/todo_repository.dart';
import 'package:zefyr/zefyr.dart';
part 'date_event.dart';
part 'date_state.dart';

class DateBloc extends Bloc<DateEvent, DateState> {
  final NoteRepository noteRepository;
  final NoteBloc noteBloc;
  DateBloc(this.noteRepository, this.noteBloc) : super(DateInitial());
  final DateFormat mainFormatter = DateFormat('dd MMM, y');
  final DateFormat weekdayFormatter = DateFormat('EEEE');
  @override
  Stream<DateState> mapEventToState(
    DateEvent event,
  ) async* {
    if (event is GetDate) {
      print("GetDate  " + event.block.id.toString());
      Failure failure;
      FormFieldBlock formfield;
      var dateOrFailure = await noteRepository.getFormField(event.block.itemId);
      dateOrFailure.fold((l) {
        failure = l;
      }, (r) {
        formfield = r;
      });
      List<String> dates = [];

      DateTime date = DateTime.parse(formfield.field);
      dates.add(mainFormatter.format(date));
      dates.add(weekdayFormatter.format(date));
      dates.add(getDays(date));

      if (failure == null)
        yield DateLoaded(event.block, formfield, dates, date);
    } else if (event is UpdateDate) {
      DateTime date = DateTime.parse(event.block.field);
      List<String> dates = [];
      dates.add(mainFormatter.format(date));
      dates.add(weekdayFormatter.format(date));
      dates.add(getDays(date));

      yield DateLoaded(
          (state as DateLoaded).blockInfo, event.block, dates, date);
      noteRepository.updateFormField(event.block);
    }
  }

  String getDays(DateTime dateTime) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = DateTime(now.year, now.month, now.day - 1);
    DateTime tomorrow = DateTime(now.year, now.month, now.day + 1);
    final aDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    if (aDate == today) {
      return "Today";
    } else if (aDate == yesterday) {
      return "Yesterday";
    } else if (aDate == tomorrow) {
      return "Tomorrow";
    } else if (dateTime.isAfter(DateTime.now())) {
      return "In " + dateTime.difference(now).inDays.toString() + " days";
    } else {
      return dateTime.difference(now).inDays.abs().toString() + " days before";
    }
  }

  @override
  Future<void> close() {
    print(" update textbox");

    return super.close();
  }
}
