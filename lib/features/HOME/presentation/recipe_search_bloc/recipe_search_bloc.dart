import 'dart:async';
import 'package:bloc/bloc.dart';


import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/features/HOME/data/models/recipes/recipe.dart';
import 'package:sorted/features/PLANNER/domain/entities/entities/filter_query.dart';
import 'package:sorted/features/TRACKERS/PERMORMANCE/domain/repositories/performance_repository.dart';
part 'recipe_search_event.dart';
part 'recipe_search_state.dart';

class RecipeSearchBloc extends Bloc<RecipeSearchEvent, RecipeSearchState> {
  final PerformanceRepository repository;
  RecipeSearchBloc(this.repository) : super(RecipeSearchInitial());
  @override
  Stream<RecipeSearchState> mapEventToState(
    RecipeSearchEvent event,
  ) async* {
    if (event is SearchByQuery) {
      print(SearchByQuery);
      Failure failure;
      yield RecipeSearchListLoaded(
          (event.prevState is RecipeSearchListLoaded)
              ? (event.prevState as RecipeSearchListLoaded).recipes
              : [],
          (event.prevState is RecipeSearchListLoaded)
              ? (event.prevState as RecipeSearchListLoaded).filterFields
              : [],
          true);

      List<FilterQuery> filters = [];
      if (event.text != null && event.text != "") {
        filters.add(FilterQuery(key: "name", value: event.text));
        filters.add(FilterQuery(key: "description", value: event.text));
      }
      event.fields.forEach((element) {
        var filter = getKeyValuePair(element);
        if (filter != null) filters.add(filter);
      });
      List<RecipeModel> recipes = [];

      var searchResults = await repository.getSearchRecipe(filters);
      searchResults.fold((l) => failure = l, (r) => recipes = r);

      if (failure == null)
        yield RecipeSearchListLoaded(recipes, event.fields, false);
      else
        yield RecipeSearchError(Failure.mapToString(failure));
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
