import 'dart:async';
import 'package:bloc/bloc.dart';


import 'package:equatable/equatable.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/features/PLANNER/data/models/activity.dart';
import 'package:sorted/features/PLANNER/domain/entities/entities/filter_query.dart';
import 'package:sorted/features/TRACKERS/PERMORMANCE/domain/repositories/performance_repository.dart';
part 'activity_search_event.dart';
part 'activity_search_state.dart';

class ActivitySearchBloc
    extends Bloc<ActivitySearchEvent, ActivitySearchState> {
  final PerformanceRepository repository;
  ActivitySearchBloc(this.repository) : super(ActivitySearchInitial());
  @override
  Stream<ActivitySearchState> mapEventToState(
    ActivitySearchEvent event,
  ) async* {
    if (event is SearchByQuery) {
      print(SearchByQuery);
      Failure failure;
      yield ActivitySearchListLoaded(
          (event.prevState is ActivitySearchListLoaded)
              ? (event.prevState as ActivitySearchListLoaded).activities
              : [],
          (event.prevState is ActivitySearchListLoaded)
              ? (event.prevState as ActivitySearchListLoaded).filterFields
              : [],
          true);

      List<FilterQuery> filters = [];
      if (event.text != null && event.text != "") {
        filters.add(FilterQuery(key: "exercise_name", value: event.text));
      }
      event.fields.forEach((element) {
        var filter = getKeyValuePair(element);
        if (filter != null) filters.add(filter);
      });
      List<ActivityModel> activities = [];

      var searchResults = await repository.getSearchActivities(filters);
      searchResults.fold((l) => failure = l, (r) => activities = r);
      if (failure == null)
        yield ActivitySearchListLoaded(activities, event.fields, false);
      else
        yield ActivitySearchError(Failure.mapToString(failure));
    }
  }

  FilterQuery getKeyValuePair(int filterId) {
    switch (filterId) {
      case 1:
        return FilterQuery(key: 'is_breakfast', value: 'y');
        break;
      case 2:
        return FilterQuery(key: 'is_lunch', value: 'y');
        break;
      case 3:
        return FilterQuery(key: 'is_dinner', value: 'y');
        break;
      case 4:
        return FilterQuery(key: 'is_loose_weight', value: 'y');
        break;
      case 5:
        return FilterQuery(key: 'is_weight_gain', value: 'y');
        break;
      case 6:
        return null;
        break;
      case 7:
        return null;
        break;
      case 8:
        return null;
        break;
      default:
        return null;
    }
  }
}
