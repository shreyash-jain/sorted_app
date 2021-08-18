import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:sorted/features/HOME/data/models/recipes/recipe.dart';
import 'package:sorted/features/PLANNER/domain/entities/entities/elastic_activity_response_parser.dart';
import 'package:sorted/features/PLANNER/domain/entities/entities/elastic_filter_match.dart';
import 'package:sorted/features/PLANNER/domain/entities/entities/elastic_recipe_request_parser.dart';
import 'dart:convert';

import 'package:sorted/features/PLANNER/domain/entities/entities/elastic_recipe_response_parser.dart';
import 'package:sorted/features/PLANNER/domain/entities/entities/filter_query.dart';

abstract class ElasticRemoteApi {
  Future<List<ActivityHits>> getArticlesSearchResults(
      List<FilterQuery> filters);
  Future<List<RecipeModel>> getRecipeSearchResults(List<FilterQuery> filters);
}

const TAGGED_RECIPE_ENDPOINT =
    'https://us-central1-sorted-98c02.cloudfunctions.net/functions/recipebank/queryRecipe?startIndex=0&batchSize=20';

const ACTIVITY_ENDPOINT =
    'https://us-central1-sorted-98c02.cloudfunctions.net/functions/activity/queryActivity?startIndex=0&batchSize=20';

class ElasticRemoteApiDataSourceImpl implements ElasticRemoteApi {
  var _parsedResponse;
  final FirebaseAuth auth;

  ElasticRemoteApiDataSourceImpl(this.auth);
  Future<List<RecipeModel>> getRecipeSearchResults(
      List<FilterQuery> filters) async {
    List<ElasticFilterMatch> match = [];
    List<ElasticFilterMatch> fuzzy = [];

    filters.forEach((element) {
      if (element != null &&
          (element.key != "name" || element.key != "description")) {
        match.add(ElasticFilterMatch.fromFilterQuery(element));
      } else if (element != null) {
        fuzzy.add(ElasticFilterMatch.fromFilterQuery(element));
      }
    });

    ElasticRequestModel requestBody =
        ElasticRequestModel(match: match, fuzzy: fuzzy);
    print("Response  " + json.encode(requestBody.toJson()));
    var userToken = await auth.currentUser.getIdToken();
    http.Response response = await http.post(Uri.parse(TAGGED_RECIPE_ENDPOINT),
        body: json.encode(requestBody.toJson()),
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
          'Authorization': 'Bearer $userToken'
        });
    print("Response  " + response.body);

    print('Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      print("response successful #######");

      print(response.body);
      List<RecipeModel> hits = [];

      (json.decode(response.body))['hits']['hits'].forEach((v) {
        hits.add(new RecipeModel.fromMap(v['_source']));
      });
      return hits;
    }
    return [];
  }

  Future<List<ActivityHits>> getArticlesSearchResults(
      List<FilterQuery> filters) async {
    List<ElasticFilterMatch> match = [];
    List<ElasticFilterMatch> fuzzy = [];
    filters.forEach((element) {
      if (element != null && (element.key != "exercise_name")) {
        match.add(ElasticFilterMatch.fromFilterQuery(element));
      } else if (element != null) {
        fuzzy.add(ElasticFilterMatch.fromFilterQuery(element));
      }
    });
    ElasticRequestModel requestBody =
        ElasticRequestModel(match: match, fuzzy: fuzzy);
    print("Response  " + json.encode(requestBody.toJson()));
    var userToken = await auth.currentUser.getIdToken();
    http.Response response = await http.post(Uri.parse(ACTIVITY_ENDPOINT),
        body: json.encode(requestBody.toJson()),
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
          'Authorization': 'Bearer $userToken'
        });
    print("Response  " + response.body);
    print('Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      print("response successful #######");

      print(response.body);
      List<ActivityHits> hits = [];
      (json.decode(response.body))['hits']['hits'].forEach((v) {
        hits.add(new ActivityHits.fromJson(v));
      });
      return hits;
    }
    return [];
  }
}
