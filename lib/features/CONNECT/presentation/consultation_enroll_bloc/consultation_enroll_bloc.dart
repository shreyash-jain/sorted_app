import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/database/cacheDataClass.dart';
import 'package:sorted/core/global/injection_container.dart';
import 'package:sorted/features/CONNECT/data/models/client_consultation_model.dart';
import 'package:sorted/features/CONNECT/data/models/client_enrolls_model.dart';
import 'package:sorted/features/CONNECT/data/models/expert/expert_calendar.dart';
import 'package:sorted/features/CONNECT/data/models/expert/expert_profile.dart';
import 'package:sorted/features/CONNECT/data/models/instances/class_client_link.dart';
import 'package:sorted/features/CONNECT/data/models/instances/class_instance.dart';
import 'package:sorted/features/CONNECT/data/models/instances/client_instance.dart';
import 'package:sorted/features/CONNECT/data/models/instances/consultation_client_instance.dart';
import 'package:sorted/features/CONNECT/data/models/instances/consultation_trainer_instance.dart';
import 'package:sorted/features/CONNECT/data/models/package_model.dart';
import 'package:sorted/features/CONNECT/domain/repositories/connect_repository.dart';
import 'package:sorted/features/HOME/data/models/class_model.dart';
part 'consultation_enroll_event.dart';
part 'consultation_enroll_state.dart';

/// userEnrollState
// 0 -> class not enrolled
// 1 -> class already enrolled, but not accepted
// 2 => class already accepted

class ConsultationEnrollBloc
    extends Bloc<ConsultationEnrollEvent, ConsultationEnrollState> {
  final ConnectRepository repository;
  ConsultationEnrollBloc(this.repository) : super(ConsultationEnrollInitial());
  @override
  Stream<ConsultationEnrollState> mapEventToState(
    ConsultationEnrollEvent event,
  ) async* {
    if (event is GetExpertDetails) {
      sl<FirebaseAnalytics>().logEvent(name: 'DynamicConsultationEnrollOpen', parameters: null);
      String expertId = event.trainerId;
      Failure failure;
      List<ConsultationPackageModel> packages;
      ClientEnrollsModel clientEnrollsModel;
      ExpertProfileModel profile;
      ExpertCalendarModel expertCalendarModel;
      var result = await repository.getExpertPackages(expertId);
      result.fold((l) => failure = l, (r) => packages = r);
      var profileResult = await repository.getExpertProfile(expertId);
      profileResult.fold((l) => failure = l, (r) => profile = r);
      var calendarResult = await repository.getExpertCalendar(expertId);
      calendarResult.fold((l) => failure = l, (r) => expertCalendarModel = r);
      var enrollResult = await repository.getEnrollsOfClient();
      enrollResult.fold((l) => failure = l, (r) => clientEnrollsModel = r);
      if (failure == null && packages.length > 0) {
        List<int> enrollStates = [];

        for (int i = 0; i < packages.length; i++) {
          ///done: get client status for class

          bool isPackageRequested = getStateOfClient(
              clientEnrollsModel, packages[i].id, 'pt_requested');
          bool isPackageAccepted = getStateOfClient(
              clientEnrollsModel, packages[i].id, 'pt_enrolled');
          int enrollState = (isPackageAccepted)
              ? 2
              : (isPackageRequested)
                  ? 1
                  : 0;

          enrollStates.add(enrollState);
        }
        yield ConsultationEnrollLoaded(
            packages,
            enrollStates,
            profile,
            [
              ["Vinyasa"]
            ],
            false,
            expertCalendarModel);
      } else {
        yield ConsultationEnrollError(Failure.mapToString(failure));
      }
    } else if (event is EnrollRequestEvent) {
      Failure failure;
      sl<FirebaseAnalytics>()
          .logEvent(name: 'DynamicConsultationClientEnrollRequest', parameters: null);

      ConsultationEnrollLoaded prevState = (state as ConsultationEnrollLoaded);

      var thisPackageIndex = prevState.packages.indexOf(event.package);
      if (thisPackageIndex != -1) {
        var thisPackage = prevState.packages[thisPackageIndex];

        yield ConsultationEnrollLoaded(
            prevState.packages,
            prevState.userEnrollState,
            prevState.expertProfile,
            [
              ["Vinyasa"]
            ],
            true,
            prevState.calendarModel);

        var userDetails = CacheDataClass.cacheData.getUserDetail();
        DateTime startDate = event.startDate;
        DateTime endDate = getEndDate(thisPackage.type, startDate);

        ClientConsultationModel consultation = event.consultation;
        consultation = consultation.copyWith(
            hasPackage: 1,
            packageId: thisPackage.id,
            email: userDetails.email,
            packageName: thisPackage.name,
            age: userDetails.age,
            startDate: startDate.toIso8601String(),
            endDate: endDate.toIso8601String(),
            name: userDetails.name,
            phoneNumber: userDetails.mobileNumber,
            imageUrl: userDetails.imageUrl,
            coachName: prevState.expertProfile.name,
            coachId: prevState.expertProfile.id);
        //Todo: add mobile number here;

        ConsultationClientInstanceModel clientLink =
            ConsultationClientInstanceModel(
                consultationId: "",
                packageName: event.package.name,
                clientName: userDetails.name,
                clientUrl: userDetails.imageUrl,
                packageId: event.package.id);

        ConsultationTrainerInstanceModel expertLink =
            ConsultationTrainerInstanceModel(
                consultationId: "",
                coachId: event.package.coachId,
                packageName: event.package.name,
                packageId: event.package.id,
                coachName: thisPackage.coachName,
                coachUrl: thisPackage.imageUrl);

        var result = await repository.enrollPackage(
            consultation, clientLink, expertLink);

        int isSuccess;
        result.fold((l) => failure = l, (r) => isSuccess = r);
        if (failure == null) {
          var newStateList = List<int>.from(prevState.userEnrollState);
          newStateList[thisPackageIndex] = (isSuccess == 1) ? 1 : 0;
          yield ConsultationEnrollLoaded(
              prevState.packages,
              newStateList,
              prevState.expertProfile,
              [
                ["Vinyasa"]
              ],
              false,
              prevState.calendarModel);
        } else {
          ConsultationEnrollError(Failure.mapToString(failure));
        }
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
                .singleWhere((it) => it.packageId == id, orElse: () => null)) !=
            null;
      case "pt_enrolled":
        return (clientEnrollsModel.enrolledConsultation
                .singleWhere((it) => it.packageId == id, orElse: () => null)) !=
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

  DateTime getEndDate(int type, DateTime startDate) {
    switch (type) {
      case 0:
        return startDate.add(Duration(days: 1));
      case 1:
        return startDate.add(Duration(days: 7));
      case 2:
        return startDate.add(Duration(days: 30));
      case 3:
        return startDate.add(Duration(days: 90));
      case 4:
        return startDate.add(Duration(days: 90));
      case 5:
        return startDate.add(Duration(days: 90));

      default:
        return startDate.add(Duration(days: 30));
    }
  }
}
