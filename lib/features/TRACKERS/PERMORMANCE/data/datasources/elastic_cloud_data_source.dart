
import 'package:http/http.dart' as http;
import 'package:sorted/features/PLANNER/domain/entities/entities/elastic_activity_response_parser.dart';
import 'package:sorted/features/PLANNER/domain/entities/entities/elastic_filter_match.dart';
import 'package:sorted/features/PLANNER/domain/entities/entities/elastic_recipe_request_parser.dart';
import 'dart:convert';

import 'package:sorted/features/PLANNER/domain/entities/entities/elastic_recipe_response_parser.dart';
import 'package:sorted/features/PLANNER/domain/entities/entities/filter_query.dart';

abstract class ElasticRemoteApi {

  Future<List<ActivityHits>> getArticlesSearchResults(
      List<FilterQuery> filters);
}

const TAGGED_RECIPE_ENDPOINT =
    'https://us-central1-sorted-98c02.cloudfunctions.net/functions/recipe/queryReciepe?startIndex=0&batchSize=20';

const ACTIVITY_ENDPOINT =
    'https://us-central1-sorted-98c02.cloudfunctions.net/functions/activity/queryActivity?startIndex=0&batchSize=20';

class ElasticRemoteApiDataSourceImpl implements ElasticRemoteApi {
  var _parsedResponse;

  ElasticRemoteApiDataSourceImpl();

 

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

    http.Response response = await http.post(Uri.parse(ACTIVITY_ENDPOINT),
        body: json.encode(requestBody.toJson()),
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
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
