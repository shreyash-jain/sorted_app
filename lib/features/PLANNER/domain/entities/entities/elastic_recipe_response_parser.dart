

class RecipeHits {
  String sIndex;
  String sType;
  String sId;
  double dScore;
  ElasticRecipe sSource;

  RecipeHits({this.sIndex, this.sType, this.sId, this.dScore, this.sSource});

  RecipeHits.fromJson(Map<String, dynamic> json) {
    sIndex = json['_index'];
    sType = json['_type'];
    sId = json['_id'];
    dScore = json['_score'];
    sSource =
        json['_source'] != null ? new ElasticRecipe.fromJson(json['_source']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_index'] = this.sIndex;
    data['_type'] = this.sType;
    data['_id'] = this.sId;
    data['_score'] = this.dScore;
    if (this.sSource != null) {
      data['_source'] = this.sSource.toJson();
    }
    return data;
  }
}

class ElasticRecipe {
  String description;
  String name;
  String isBreakfast;
  String isDinner;
  String isLunch;
  String isDieting;
  String isHighProtien;
  String isHighCalorie;
  String isLowSugar;
  String isWeightGain;
  String isLooseWeight;

  ElasticRecipe(
      {this.description,
      this.name,
      this.isBreakfast,
      this.isDinner,
      this.isLunch,
      this.isDieting,
      this.isHighProtien,
      this.isHighCalorie,
      this.isLowSugar,
      this.isWeightGain,
      this.isLooseWeight});

  ElasticRecipe.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    name = json['name'];
    isBreakfast = json['is_breakfast'];
    isDinner = json['is_dinner'];
    isLunch = json['is_lunch'];
    isDieting = json['is_dieting'];
    isHighProtien = json['is_high_protien'];
    isHighCalorie = json['is_high_calorie'];
    isLowSugar = json['is_low_sugar'];
    isWeightGain = json['is_weight_gain'];
    isLooseWeight = json['is_loose_weight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['name'] = this.name;
    data['is_breakfast'] = this.isBreakfast;
    data['is_dinner'] = this.isDinner;
    data['is_lunch'] = this.isLunch;
    data['is_dieting'] = this.isDieting;
    data['is_high_protien'] = this.isHighProtien;
    data['is_high_calorie'] = this.isHighCalorie;
    data['is_low_sugar'] = this.isLowSugar;
    data['is_weight_gain'] = this.isWeightGain;
    data['is_loose_weight'] = this.isLooseWeight;
    return data;
  }
}