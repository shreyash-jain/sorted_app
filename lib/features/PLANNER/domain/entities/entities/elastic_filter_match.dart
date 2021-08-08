

import 'package:sorted/features/PLANNER/domain/entities/entities/filter_query.dart';

class ElasticFilterMatch {
  String fieldName;
  String value;
  bool equality;

  ElasticFilterMatch({this.fieldName, this.value, this.equality});

  ElasticFilterMatch.fromJson(Map<String, dynamic> json) {
    fieldName = json['fieldName'];
    value = json['value'];
    equality = json['equality'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fieldName'] = this.fieldName;
    data['value'] = this.value;
    data['equality'] = this.equality;
    return data;
  }

  ElasticFilterMatch.fromFilterQuery(FilterQuery filter) {
    fieldName = filter.key;
    value = filter.value;
    equality = true;
  }
}
