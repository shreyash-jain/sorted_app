import 'dart:async';
import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/features/CONNECT/data/models/resource_message.dart';
import 'package:sorted/features/CONNECT/domain/repositories/connect_repository.dart';
import 'package:sorted/features/HOME/data/models/class_model.dart';
part 'class_resource_event.dart';
part 'class_resource_state.dart';

class ClassResourceBloc extends Bloc<ClassResourceEvent, ClassResourceState> {
  final ConnectRepository repository;
  ClassResourceBloc(this.repository) : super(ClientInitial());
  @override
  Stream<ClassResourceState> mapEventToState(
    ClassResourceEvent event,
  ) async* {
    if (event is GetClassMembers) {
      // Failure failure;
      // var result = await repository.getClassEnrolls(event.classroom);

      // ClassMembersModel classEnrollsModel;
      // result.fold((l) => failure = l, (r) => classEnrollsModel = r);
      // if (failure == null) {
      //   yield (ClassResourcesLoaded([], event.classroom));
      // } else {
      //   yield ClassResourcesError(Failure.mapToString(failure));
      // }
    }
  }
}
