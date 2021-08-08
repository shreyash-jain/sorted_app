import 'dart:async';
import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:share/share.dart';
import 'package:sorted/features/CONNECT/data/datasources/expert_speciality_db.dart';
import 'package:sorted/features/CONNECT/data/models/class_private.dart';
import 'package:sorted/features/CONNECT/data/models/timetable.dart';
import 'package:sorted/features/CONNECT/domain/repositories/connect_repository.dart';
import 'package:sorted/features/HOME/data/models/class_model.dart';
part 'class_summary_event.dart';
part 'class_summary_state.dart';

class ClassSummaryBloc extends Bloc<ClassSummaryEvent, ClassSummaryState> {
  final ConnectRepository repository;

  ClassSummaryBloc(this.repository)
      : super(ClassSummaryInitial());
  @override
  Stream<ClassSummaryState> mapEventToState(
    ClassSummaryEvent event,
  ) async* {
    if (event is LoadClassSummary) {
      List<String> topic = [];
      ClassModel classroom = event.classroom;
      // ClassModel classroom = ClassModel(
      //     id: "",
      //     name: "Morning Yoga Classes",
      //     description: "",
      //     coverUrl:
      //         "https://static.india.com/wp-content/uploads/2015/07/yoga-class.jpg",
      //     shareId: 84521,
      //     type: 1,
      //     topics: "Pranayama,Asanas",
      //     hasTimeTable: 0);

      if (classroom.topics == null) classroom.topics = "";
      topic = (classroom.topics.split(","));
      List<String> topicNames = [];
      topic.forEach((element) {
        if (element != "") topicNames.add(getStringFromId(int.parse(element)));
      });

      ClassTimetableModel timetable = ClassTimetableModel(id: 12, classId: 1);
      ClassPrivateModel classFeeModel = ClassPrivateModel(id: 12, classId: 1);

      yield ClassSummaryLoaded(
          classroom, topicNames, timetable, classFeeModel, false);
    }
      
  }

  Future<String> createClassLink(String classId) async {
    print('GetClassLink class ID ' + classId);
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        link: Uri.parse('https://www.getsortit.com/class?id=$classId'),
        androidParameters: AndroidParameters(
          packageName: 'com.stay.sorted',
          minimumVersion: 1,
        ),
        uriPrefix: 'https://connect.getsortit.com/enroll');
    final link = await parameters.buildUrl();
    print('GetClassLink class link ' + link.toString());
    return link.toString();
  }
}
