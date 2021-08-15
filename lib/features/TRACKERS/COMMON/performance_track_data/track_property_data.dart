import 'package:sorted/features/TRACKERS/COMMON/models/track_model.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_property_model.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_property_settings.dart';

//track model id global path -> tracking/data/tracks/1/

List<TrackPropertyModel> getPropertiesOfTrack(TrackModel track) {
  List<TrackPropertyModel> result =
      getAllProperties().where((element) => (element.track_id == track.id));
  return result;
}

List<TrackPropertyModel> getAllProperties() {
  return [
    foodItems,
    calories,
    protien,
    carbohydrates,
    fat,
    activityList,
    calorieBurnt,
    workoutTime,
    weight,
    water,
    bodyFatRatio,
    stepsCount,
    fasting,
    sugar,
    egg,
    greentea,
    moodrate,
    moodwhy,
    angerrate,
    angertrigger,
    sleep,
    screentime,
    bodyImage,
    bodyText
  ];
}

TrackPropertyModel getPropertyById(int id) {
  return getAllProperties().firstWhere((element) => element.id == id,
      orElse: () => TrackPropertyModel(id: -1));
}

List<TrackPropertySettings> getAllDefaultPropertySettings() {
  return [
    weightSettings,
    waterSettings,
    fatSettings,
    stepsSettings,
    fastingSettings,
    sugarSettings,
    eggSettings,
    greenteaSettings,
    moodSettings,
    moodwhySettings,
    angerrateSettings,
    angertriggerSettings,
    sleepSettings,
    screentimeSettings
  ];
}

//track model id global path -> tracking/data/tracks/1/



TrackPropertyModel foodItems = new TrackPropertyModel(
  id: 1,
  track_id: 1,
  property_type: 4,
  property_key: "food_item",
  is_manual_fill: 1,
  property_name: "Meals",
  property_description: "Track the food items of your meal",
);

TrackPropertyModel calories = new TrackPropertyModel(
  id: 2,
  track_id: 1,
  property_type: 1,
  auto_fill_status: 1,
  property_key: "calories",
  property_name: "Calories",
  n_max: 500,
  n_min: 0,
  n_aim_type: 0,
  property_description: "Track the calories of a meal",
  has_goal: 0,
);

TrackPropertyModel protien = new TrackPropertyModel(
    id: 3,
    track_id: 1,
    property_type: 1,
    property_key: "protien",
    property_name: "Protein",
    property_description: "Track the protien content of a meal",
    has_goal: 0);

TrackPropertyModel carbohydrates = new TrackPropertyModel(
  id: 4,
  track_id: 1,
  property_type: 1,
  property_key: "carbohydrates",
  property_name: "Carbs",
  property_description: "Track the carbs content of a meal",
);

TrackPropertyModel fat = new TrackPropertyModel(
  id: 5,
  track_id: 1,
  property_type: 1,
  property_key: "fat",
  property_name: "Fat",
  property_description: "Track the fat content of a meal",
);

TrackPropertyModel activityList = new TrackPropertyModel(
  id: 6,
  track_id: 2,
  property_type: 4,
  is_manual_fill: 1,
  property_key: "activity_list",
  property_name: "Activities",
  property_description: "Track the activities and exercises",
);

TrackPropertyModel calorieBurnt = new TrackPropertyModel(
    id: 7,
    track_id: 2,
    property_type: 4,
    is_manual_fill: 0,
    property_key: "calorie_burnt",
    property_name: "Calorie burnt",
    property_description: "Track the burnt calories",
    has_goal: 0);

TrackPropertyModel workoutTime = new TrackPropertyModel(
  id: 7,
  track_id: 2,
  property_type: 4,
  property_key: "workout_time",
  is_manual_fill: 1,
  property_name: "Workout duration",
  property_description: "Track the workout time",
);

TrackPropertyModel weight = new TrackPropertyModel(
    id: 8,
    track_id: 3,
    property_type: 2,
    is_manual_fill: 1,
    n_stat_condition: 0,
    property_name: "Body Weight",
    property_key: "weight",
    n_after_decimal: 1,
    n_max: 150,
    n_min: 0,
    n_unit: "Kg",
    property_question: "Update your weight",
    property_description: "Track the body Weight",
    has_goal: 0);

TrackPropertySettings weightSettings =
    new TrackPropertySettings(track_id: 3, property_id: 8);

TrackPropertyModel water = new TrackPropertyModel(
    id: 9,
    track_id: 4,
    property_type: 2,
    is_manual_fill: 1,
    property_key: "water",
    property_name: "Water quantity",
    property_description: "Track the amount of water",
    property_question: "How much water did you drink ?",
    n_unit: "L",
    n_max: 8,
    n_min: 0,
    n_after_decimal: 1,
    n_stat_condition: 1,
    n_aim_type: 2,
    has_goal: 1);
TrackPropertySettings waterSettings =
    new TrackPropertySettings(track_id: 4, property_id: 9, n_u_aim_start: 2);

TrackPropertyModel bodyFatRatio = new TrackPropertyModel(
    id: 10,
    track_id: 5,
    property_type: 2,
    is_manual_fill: 1,
    property_key: "body_fat_ratio",
    property_name: "Body Fat ratio",
    property_description: "Track the body fat ratio",
    property_question: "Update your Body fat ratio",
    n_aim_type: 0,
    n_unit: "%",
    n_min: 0,
    n_after_decimal: 1,
    n_max: 100,
    has_goal: 1);
TrackPropertySettings fatSettings =
    new TrackPropertySettings(track_id: 5, property_id: 10, n_u_aim_start: 25);

TrackPropertyModel bodyImage = new TrackPropertyModel(
  id: 11,
  track_id: 6,
  property_type: 5,
  is_manual_fill: 1,
  property_key: "body_image",
  property_name: "Body Image",
  property_question: "Add your transformation journey image",
  property_description: "Track your body journey",
);

TrackPropertyModel bodyText = new TrackPropertyModel(
    id: 12,
    track_id: 6,
    property_type: 1,
    is_manual_fill: 1,
    property_key: "body_text",
    property_name: "body_text",
    property_question: "Share your jouney experiences",
    property_description: "Track jouney experiences",
    t_hint_text: "Describe the challenges you faced");

TrackPropertyModel stepsCount = new TrackPropertyModel(
    id: 13,
    track_id: 7,
    property_type: 2,
    is_manual_fill: 1,
    property_key: "steps_count",
    property_name: "Steps Count",
    property_description: "Track steps count",
    property_question: "Add your steps",
    n_min: 0,
    n_max: 20000,
    n_stat_condition: 1,
    n_aim_type: 2,
    n_after_decimal: 0,
    n_unit: "Steps",
    has_goal: 1);
TrackPropertySettings stepsSettings = new TrackPropertySettings(
    track_id: 7, property_id: 13, n_u_aim_start: 10000);

TrackPropertyModel fasting = new TrackPropertyModel(
    id: 14,
    track_id: 8,
    property_type: 4,
    is_manual_fill: 1,
    property_key: "fasting",
    property_name: "Fasting duration",
    property_description: "Track the time duration of your fast",
    property_question: "How much time did you fast ?",
    d_is_realtime: 1,
    d_max_duration_min: 24,
    has_goal: 1);
TrackPropertySettings fastingSettings =
    new TrackPropertySettings(track_id: 8, property_id: 14, d_u_day_aim: 6);

TrackPropertyModel sugar = new TrackPropertyModel(
    id: 15,
    track_id: 9,
    property_type: 2,
    is_manual_fill: 1,
    property_key: "sugar",
    property_name: "Sugar Intake",
    property_description: "Track the amount of water",
    property_question: "How much sugar did you consume today ?",
    n_unit: "Teaspoon",
    n_max: 50,
    n_min: 0,
    n_after_decimal: 0,
    n_stat_condition: 1,
    n_aim_type: 1,
    has_goal: 1);
TrackPropertySettings sugarSettings =
    new TrackPropertySettings(track_id: 9, property_id: 15, n_u_aim_start: 5);

TrackPropertyModel egg = new TrackPropertyModel(
    id: 16,
    track_id: 10,
    property_type: 2,
    is_manual_fill: 1,
    property_key: "egg",
    property_name: "Egg Intake",
    property_description: "Track the amount of water",
    property_question: "How much sugar did you consume today ?",
    n_unit: "Eggs",
    n_max: 12,
    n_min: 0,
    n_after_decimal: 0,
    n_stat_condition: 1,
    n_aim_type: 0,
    has_goal: 1);
TrackPropertySettings eggSettings =
    new TrackPropertySettings(track_id: 10, property_id: 16);

TrackPropertyModel greentea = new TrackPropertyModel(
    id: 17,
    track_id: 11,
    property_type: 2,
    is_manual_fill: 1,
    property_key: "greentea",
    property_name: "Green tea Intake",
    property_description: "Track the Green tea intake",
    property_question: "How many Tea cups you consume today ?",
    n_unit: "Cups",
    n_max: 10,
    n_min: 0,
    n_after_decimal: 1,
    n_stat_condition: 1,
    n_aim_type: 2,
    has_goal: 1);
TrackPropertySettings greenteaSettings =
    new TrackPropertySettings(track_id: 11, property_id: 17, n_u_aim_start: 2);

TrackPropertyModel moodrate = new TrackPropertyModel(
  id: 18,
  track_id: 12,
  property_type: 3,
  is_manual_fill: 1,
  property_key: "moodrate",
  property_name: "Mood rating",
  property_description: "Track the mood",
  property_question: "How are you now ?",
  r_max: 5,
  r_min: 0,
  r_max_string: "Awesome",
  r_min_string: "Terrible",
);
TrackPropertySettings moodSettings = new TrackPropertySettings(
  track_id: 12,
  property_id: 18,
);

TrackPropertyModel moodwhy = new TrackPropertyModel(
    id: 19,
    track_id: 12,
    property_type: 6,
    is_manual_fill: 1,
    property_key: "moodwhy",
    property_name: "Why",
    property_description: "What made you feel so",
    property_question: "What made you feel so ?",
    rl_items: [
      "Work",
      "Relationship",
      "Studies",
      "Food",
      "Friends",
      "Work",
      "Sleep",
      "Family",
      "Health",
      "Exercise",
      "Weather",
      "Travel"
    ],
    rl_is_multi_choice: 1);
TrackPropertySettings moodwhySettings =
    new TrackPropertySettings(track_id: 12, property_id: 19);

TrackPropertyModel angerrate = new TrackPropertyModel(
  id: 20,
  track_id: 13,
  property_type: 3,
  is_manual_fill: 1,
  property_key: "angerrate",
  property_name: "Anger rating",
  property_description: "Track the anger",
  property_question: "Rate your anger level ?",
  r_max: 5,
  r_min: 0,
  r_max_string: "Raged",
  r_min_string: "Chilled",
);
TrackPropertySettings angerrateSettings =
    new TrackPropertySettings(track_id: 13, property_id: 20);

TrackPropertyModel angertrigger = new TrackPropertyModel(
  id: 21,
  track_id: 13,
  property_type: 1,
  is_manual_fill: 1,
  property_key: "angertrigger",
  property_name: "Anger trigger",
  property_description: "Track the anger trigger",
  property_question: "What are the trigger points for your anger ?",
  t_hint_text: "Describe what made you angry",
);
TrackPropertySettings angertriggerSettings =
    new TrackPropertySettings(track_id: 13, property_id: 21);

TrackPropertyModel sleep = new TrackPropertyModel(
    id: 22,
    track_id: 14,
    property_type: 4,
    is_manual_fill: 1,
    property_key: "sleep",
    rl_default_aim_index: 2,
    property_question: "Add your sleep duration",
    property_name: "Sleep duration",
    property_description: "Track the time duration of your fast",
    d_is_realtime: 0,
    d_max_duration_min: 24,
    has_goal: 1);
TrackPropertySettings sleepSettings =
    new TrackPropertySettings(track_id: 14, property_id: 22, d_u_day_aim: 7);

TrackPropertyModel screentime = new TrackPropertyModel(
    id: 23,
    track_id: 16,
    property_type: 4,
    is_manual_fill: 1,
    property_key: "screentime",
    property_name: "Screentime",
    property_question: "Add your screentime",
    property_description: "What was your total screen time ?",
    d_is_realtime: 0,
    d_max_duration_min: 12,
    rl_default_aim_index: 1,
    has_goal: 1);
TrackPropertySettings screentimeSettings =
    new TrackPropertySettings(track_id: 16, property_id: 23, d_u_day_aim: 2);
