class ActivityHits {
  String sIndex;
  String sType;
  String sId;
  double dScore;
  ElasticActivity activity;

  ActivityHits({this.sIndex, this.sType, this.sId, this.dScore, this.activity});

  ActivityHits.fromJson(Map<String, dynamic> json) {
    sIndex = json['_index'];
    sType = json['_type'];
    sId = json['_id'];
    dScore = json['_score'];
    activity = json['_source'] != null
        ? new ElasticActivity.fromJson(json['_source'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_index'] = this.sIndex;
    data['_type'] = this.sType;
    data['_id'] = this.sId;
    data['_score'] = this.dScore;
    if (this.activity != null) {
      data['_source'] = this.activity.toJson();
    }
    return data;
  }
}

class ElasticActivity {
  int id;
  String link;
  String exerciseName;
  String imageUrl;
  String instructions;
  int requireInstrument;
  String howToStart;
  String benefits;
  int calorieBurn;
  int isYoga;
  int isWGain;
  int isWLoose;
  int hasReps;
  double timeInMin;
  int level;
  int isStrength;
  int isCardio;
  int isStreaching;
  String pmt;
  String smt;
  String trackingType;
  String gif;
  String contraindications;

  ElasticActivity(
      {this.id,
      this.link,
      this.exerciseName,
      this.imageUrl,
      this.instructions,
      this.requireInstrument,
      this.howToStart,
      this.benefits,
      this.calorieBurn,
      this.isYoga,
      this.isWGain,
      this.isWLoose,
      this.hasReps,
      this.timeInMin,
      this.level,
      this.isStrength,
      this.isCardio,
      this.isStreaching,
      this.pmt,
      this.smt,
      this.trackingType,
      this.gif,
      this.contraindications});

  ElasticActivity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    link = json['link'];
    exerciseName = json['exercise_name'];
    imageUrl = json['image_url'];
    instructions = json['instructions'];
    requireInstrument =
        (json['require_instrument'] is String) ? 0 : json['require_instrument'];
    howToStart = json['how_to_start'];
    benefits = json['benefits'];
    calorieBurn = json['calorie_burn'];
    isYoga = json['is_yoga'];
    isWGain = json['is_w_gain'];
    isWLoose = json['is_w_loose'];
    hasReps = json['has_reps'];
    timeInMin = (json['time_in_min'] is double)
        ? json['time_in_min']
        : (json['time_in_min']).toDouble() ?? 0.0;
    level = json['level'];
    isStrength = json['is_strength'];
    isCardio = json['is_cardio'];
    isStreaching = json['is_streaching'];
    pmt = json['pmt'];
    smt = json['smt'];
    trackingType = json['tracking_type'];
    gif = json['gif'];
    contraindications = json['contraindications'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['link'] = this.link;
    data['exercise_name'] = this.exerciseName;
    data['image_url'] = this.imageUrl;
    data['instructions'] = this.instructions;
    data['require_instrument'] = this.requireInstrument;
    data['how_to_start'] = this.howToStart;
    data['benefits'] = this.benefits;
    data['calorie_burn'] = this.calorieBurn;
    data['is_yoga'] = this.isYoga;
    data['is_w_gain'] = this.isWGain;
    data['is_w_loose'] = this.isWLoose;
    data['has_reps'] = this.hasReps;
    data['time_in_min'] = this.timeInMin;
    data['level'] = this.level;
    data['is_strength'] = this.isStrength;
    data['is_cardio'] = this.isCardio;
    data['is_streaching'] = this.isStreaching;
    data['pmt'] = this.pmt;
    data['smt'] = this.smt;
    data['tracking_type'] = this.trackingType;
    data['gif'] = this.gif;
    data['contraindications'] = this.contraindications;
    return data;
  }
}
