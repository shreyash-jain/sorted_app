import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/database/cacheDataClass.dart';
import 'package:sorted/features/CONNECT/data/models/client_enrolls_model.dart';
import 'package:sorted/features/CONNECT/data/models/expert_profile.dart';
import 'package:sorted/features/CONNECT/data/models/instances/class_client_link.dart';
import 'package:sorted/features/CONNECT/data/models/instances/class_instance.dart';
import 'package:sorted/features/CONNECT/data/models/instances/client_instance.dart';
import 'package:sorted/features/CONNECT/domain/repositories/connect_repository.dart';
import 'package:sorted/features/HOME/data/models/class_model.dart';
part 'class_enroll_event.dart';
part 'class_enroll_state.dart';

/// userEnrollState
// 0 -> class not enrolled
// 1 -> class already enrolled, but not accepted
// 2 => class already accepted

class ClassEnrollBloc extends Bloc<ClassEnrollEvent, ClassEnrollState> {
  final ConnectRepository repository;
  ClassEnrollBloc(this.repository) : super(ClassEnrollInitial());
  @override
  Stream<ClassEnrollState> mapEventToState(
    ClassEnrollEvent event,
  ) async* {
    if (event is GetClassDetails) {
      String classId = event.classId;
      Failure failure;
      ClassModel classroom;
      ClientEnrollsModel clientEnrollsModel;
      ExpertProfileModel profile;
      var result = await repository.getClass(classId);
      result.fold((l) => failure = l, (r) => classroom = r);
      if (failure == null && classroom.id != "") {
        print("classroom.coachUid   " + classroom.coachUid);
        var profileResult =
            await repository.getExpertProfile(classroom.coachUid);
        profileResult.fold((l) => failure = l, (r) => profile = r);
        var enrollResult = await repository.getEnrollsOfClient();
        enrollResult.fold((l) => failure = l, (r) => clientEnrollsModel = r);
        print("getEnrollsOfClient " +
            clientEnrollsModel.requestedClasses.length.toString());

        ///done: get client status for class
        if (failure == null) {
          bool isClassRequested =
              getStateOfClient(clientEnrollsModel, classId, 'class_requested');
          bool isClassAccepted =
              getStateOfClient(clientEnrollsModel, classId, 'class_enrolled');
          int state = (isClassAccepted)
              ? 2
              : (isClassRequested)
                  ? 1
                  : 0;
          yield ClassEnrollLoaded(
              classroom, state, profile, ["Vinyasa"], false);
        } else {
          yield ClassEnrollError(Failure.mapToString(failure));
        }
      } else {
        yield ClassEnrollError(Failure.mapToString(failure));
      }
    } else if (event is EnrollRequestEvent) {
      Failure failure;
      ClassEnrollLoaded prevState = (state as ClassEnrollLoaded);
      yield ClassEnrollLoaded(prevState.classroom, prevState.userEnrollState,
          prevState.expertProfile, ["Vinyasa"], true);
      var userDetails = CacheDataClass.cacheData.getUserDetail();
      ClassInstanceModel classInstance = ClassInstanceModel(
          classId: prevState.classroom.id,
          className: prevState.classroom.name,
          imageUrl: prevState.classroom.imageUrl);
      ClassClientLink classLink = ClassClientLink(
          classId: prevState.classroom.id,
          className: prevState.classroom.name,
          clientName: userDetails.name,
          clientImageUrl: userDetails.imageUrl);
      ClientInstance clientInstance = ClientInstance(
          imageUrl: userDetails.imageUrl, name: userDetails.name);

      var result = await repository.enrollClass(classInstance, classLink,
          prevState.classroom.coachUid, clientInstance);
      int isSuccess;
      result.fold((l) => failure = l, (r) => isSuccess = r);
      if (failure == null) {
        yield ClassEnrollLoaded(prevState.classroom, (isSuccess == 1) ? 1 : 0,
            prevState.expertProfile, ["Vinyasa"], false);
      } else {
        ClassEnrollError(Failure.mapToString(failure));
      }
    }
  }

  bool getStateOfClient(
      ClientEnrollsModel clientEnrollsModel, String id, String listName) {
    switch (listName) {
      case "class_requested":
        return (clientEnrollsModel.requestedClasses
                .singleWhere((it) => it.classId == id, orElse: () => null)) !=
            null;
      case "class_enrolled":
        return (clientEnrollsModel.enrolledClasses
                .singleWhere((it) => it.classId == id, orElse: () => null)) !=
            null;
      case "pt_requested":
        return (clientEnrollsModel.requestedConsultation
                .singleWhere((it) => it.id == id, orElse: () => null)) !=
            null;
      case "pt_enrolled":
        return (clientEnrollsModel.enrolledConsultation
                .singleWhere((it) => it.id == id, orElse: () => null)) !=
            null;
      case "it_requested":
        return (clientEnrollsModel.requestedInstitutes
                .singleWhere((it) => it.id == id, orElse: () => null)) !=
            null;
      case "it_enrolled":
        return (clientEnrollsModel.enrolledInstitutes
                .singleWhere((it) => it.id == id, orElse: () => null)) !=
            null;
        break;
      default:
    }
  }
}
