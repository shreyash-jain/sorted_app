part of 'record_bloc.dart';

abstract class RecordEvent extends Equatable {
  const RecordEvent();
}

class TestEvent extends RecordEvent {
  @override
  List<Object> get props => [];
}

class GetRecordInitialData extends RecordEvent {
  @override
  List<Object> get props => [];
}
