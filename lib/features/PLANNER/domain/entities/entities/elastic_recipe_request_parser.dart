
import 'package:sorted/features/PLANNER/domain/entities/entities/elastic_filter_match.dart';

class ElasticRequestModel {
  List<ElasticFilterMatch> match;
  List<ElasticFilterMatch> fuzzy;

  ElasticRequestModel({this.match, this.fuzzy});

  ElasticRequestModel.fromJson(Map<String, dynamic> json) {
    if (json['Match'] != null) {
      match = new List<ElasticFilterMatch>();
      json['Match'].forEach((v) {
        match.add(new ElasticFilterMatch.fromJson(v));
      });
    }
    if (json['Fuzzy'] != null) {
      fuzzy = new List<ElasticFilterMatch>();
      json['Fuzzy'].forEach((v) {
        fuzzy.add(new ElasticFilterMatch.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.match != null) {
      data['Match'] = this.match.map((v) => v.toJson()).toList();
    }
    if (this.fuzzy != null) {
      data['Fuzzy'] = this.fuzzy.map((v) => v.toJson()).toList();
    }

    data['Range'] = [];

    return data;
  }
}

