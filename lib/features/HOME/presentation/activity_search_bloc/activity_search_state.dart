part of 'activity_search_bloc.dart';

abstract class ActivitySearchState extends Equatable {
  const ActivitySearchState();
}

class ActivitySearchInitial extends ActivitySearchState {
  @override
  List<Object> get props => [];
}

class ActivitySearchListLoaded extends ActivitySearchState {

  final List<ActivityModel> activities;
  final List<int> filterFields;
 
  final bool isLoading;

  ActivitySearchListLoaded(this.activities,  this.filterFields, this.isLoading);

  @override
  List<Object> get props => [activities, isLoading, filterFields];
}

class ActivitySearchError extends ActivitySearchState {
  final String message;

  ActivitySearchError(this.message);
  @override
  List<Object> get props => [message];
}
