import 'dart:async';
import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/features/CONNECT/data/models/client_consultation_model.dart';
import 'package:sorted/features/CONNECT/data/models/resource_message.dart';
import 'package:sorted/features/CONNECT/domain/repositories/connect_repository.dart';
import 'package:sorted/features/HOME/data/models/class_model.dart';
part 'resource_event.dart';
part 'resource_state.dart';

class ResourceBloc extends Bloc<ResourceEvent, ResourceState> {
  final ConnectRepository repository;
  ResourceBloc(this.repository) : super(ResourceInitial());
  @override
  Stream<ResourceState> mapEventToState(
    ResourceEvent event,
  ) async* {
    if (event is LoadClassResources) {
      Failure failure;
      List<ResourceMessage> messages = [];
      var result = await repository.getClassResourceMessages(event.classroom);
      result.fold((l) => failure = l, (r) => messages = r);
      if (failure == null) {
        yield ResourceLoaded(messages);
      } else
        yield ResourceError(Failure.mapToString(failure));
    } else if (event is LoadConsultationResources) {
      Failure failure;
      List<ResourceMessage> messages = [];
      var result =
          await repository.getConsultationResourceMessages(event.consultation);
      result.fold((l) => failure = l, (r) => messages = r);
      if (failure == null) {
        yield ResourceLoaded(messages);
      } else
        yield ResourceError(Failure.mapToString(failure));
    }
  }
}
