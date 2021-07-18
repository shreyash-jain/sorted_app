import 'package:sorted/features/TRACKERS/COMMON/models/track_model.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_property_model.dart';

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
    fasting
  ];
}

//track model id global path -> tracking/data/tracks/1/

List<TrackPropertyModel> trackFood = [
  foodItems,
  calories,
  protien,
  carbohydrates,
  fat
];
List<TrackPropertyModel> trackWorkout = [
  activityList,
  calorieBurnt,
  workoutTime
];
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
  n_u_aim_start: 300,
  n_aim_type: 0,
  n_u_aim_condition: 0,
  property_description: "Track the calories of a meal",
  has_goal: "1,2,3",
);

TrackPropertyModel protien = new TrackPropertyModel(
    id: 3,
    track_id: 1,
    property_type: 1,
    property_key: "protien",
    property_name: "Protein",
    property_description: "Track the protien content of a meal",
    has_goal: "1,2,3");

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
    has_goal: "4,5,6");

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
    property_name: "Body Weight",
    property_key: "weight",
    property_description: "Track the body Weight",
    has_goal: "7");

TrackPropertyModel water = new TrackPropertyModel(
    id: 9,
    track_id: 4,
    property_type: 3,
    is_manual_fill: 1,
    property_key: "water",
    property_name: "Water quantity",
    property_description: "Track the amout of water",
    property_question: "How much water did you drink ?",
    has_goal: "8");

TrackPropertyModel bodyFatRatio = new TrackPropertyModel(
    id: 10,
    track_id: 5,
    property_type: 2,
    is_manual_fill: 1,
    property_key: "body_fat_ratio",
    property_name: "Body Fat ratio",
    property_description: "Track the body fat ratio",
    has_goal: "9");

TrackPropertyModel bodyImage = new TrackPropertyModel(
  id: 11,
  track_id: 6,
  property_type: 8,
  is_manual_fill: 1,
  property_key: "body_image",
  property_name: "Body Image",
  property_description: "Track your body journey",
);

TrackPropertyModel bodyText = new TrackPropertyModel(
  id: 12,
  track_id: 6,
  property_type: 8,
  is_manual_fill: 1,
  property_key: "body_text",
  property_name: "body_text",
  property_description: "Track jouney experiences",
);

TrackPropertyModel stepsCount = new TrackPropertyModel(
    id: 13,
    track_id: 7,
    property_type: 8,
    is_manual_fill: 1,
    property_key: "steps_count",
    property_name: "Steps Count",
    property_description: "Track steps count",
    has_goal: "10");

TrackPropertyModel fasting = new TrackPropertyModel(
    id: 14,
    track_id: 8,
    property_type: 8,
    is_manual_fill: 1,
    property_key: "fasting",
    property_name: "Fasting duration",
    property_description: "Track the time duration of your fast",
    has_goal: "11");
