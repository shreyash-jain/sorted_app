import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/features/CONNECT/data/models/client_enrolls_model.dart';
import 'package:sorted/features/CONNECT/domain/repositories/connect_repository.dart';
import 'package:sorted/features/CONNECT/presentation/class_enroll_bloc/class_enroll_bloc.dart';
import 'package:sorted/features/HOME/data/models/class_model.dart';
part 'enroll_event.dart';
part 'enroll_state.dart';

class ClientEnrollBloc extends Bloc<ClientEnrollEvent, ClientEnrollState> {
  final ConnectRepository repository;
  ClientEnrollBloc(this.repository) : super(ClientEnrollInitial());
  @override
  Stream<ClientEnrollState> mapEventToState(
    ClientEnrollEvent event,
  ) async* {
    if (event is GetClientEnrolls) {
      Failure failure;
      ClientEnrollsModel clientEnrollsModel;
      List<ClassModel> requestedClasses = [];
      List<ClassModel> enrolledClasses = [];

      var enrollResult = await repository.getEnrollsOfClient();
      enrollResult.fold((l) => failure = l, (r) => clientEnrollsModel = r);
      if (failure == null) {
        try {
          List<Either<Failure, ClassModel>> requestedResponses =
              await Future.wait((clientEnrollsModel.requestedClasses
                  .map((e) => repository.getClass(e.classId))
                  .toList()));
          requestedResponses.forEach((element) {
            element.fold((l) => failure = l, (r) => requestedClasses.add(r));
          });
        } catch (e) {
          failure = ServerFailure();
        }
        try {
          List<Either<Failure, ClassModel>> enrolledResponses =
              await Future.wait((clientEnrollsModel.enrolledClasses
                  .map((e) => repository.getClass(e.classId))
                  .toList()));
          enrolledResponses.forEach((element) {
            element.fold((l) => failure = l, (r) => enrolledClasses.add(r));
          });
        } catch (e) {
          failure = ServerFailure();
        }

        if (failure == null) {
          yield ClientEnrollLoaded(requestedClasses, enrolledClasses);
        } else
          yield ClientEnrollError(Failure.mapToString(failure));
      } else {
        yield ClientEnrollError(Failure.mapToString(failure));
      }
    }
  }
}
