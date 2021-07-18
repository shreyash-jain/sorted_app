import 'package:sorted/features/TRACKERS/COMMON/models/track_model.dart';
List<TrackModel> getTracksForClass() {
  return [
    diet_track,
    track_workout,
    track_weight,
    track_water,
    track_body_fat,
    track_my_transformation
  ];
}

List<TrackModel> getAllTracks() {
  return [
    diet_track,
    track_workout,
    track_weight,
    track_water,
    track_body_fat,
    track_my_transformation,
    track_my_steps,
    track_green_tea,
    track_mood,
    track_anxiety
  ];
}

//track model id global path -> tracking/data/tracks/1/
TrackModel food_track = new TrackModel(
    id: 1,
    name: "Track my Food",
    m_description: "",
    ts_autofill: 0,
    m_db_string: "8000 Recipes",
    ts_default_sub_days: 0,
    ts_reminder_state: 0,
    m_custom_db_string: "Add custom Recipe",
    m_template_string: "Weekly diet plan",
    ts_reminder_day_start_ts: 946697400000,
    ts_reminder_day_end_ts: 946740600000,
    ts_reminder_interval_days: 10,
    m_db_icon:
        "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2F1%2Frecipes.png?alt=media&token=3b98c93b-7bc1-4af4-b901-ede5fef88ff3",
    m_custom_db_icon:
        "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2F1%2Fchef.png?alt=media&token=b97e3448-5b8c-41c0-909a-fe2ba27f0319",
    m_template_icon:
        "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2F1%2Fdiet_plan.png?alt=media&token=1afabc6f-4124-4121-97b7-11262f889a9d");




TrackModel diet_track = new TrackModel(
    id: 1,
    name: "Track my Food",
    icon:
        "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2Ftrack_diet.png?alt=media&token=5681f96d-7d28-4b3b-8cbf-07792260d62d",
    m_description:
        "A calorie is a unit of energy gained by the consumption of food. On one hand, calories make us stronger and resistant but on the other they may add up to our body fat severely. Therefore our calorie intake should be strictly monitored. Here we come to assistance with our track to manage your calorie consumption daily.",
    ts_autofill: 0,
    m_facts:
        "The United States government states that the average man needs 2,700 kcal per day and the average woman needs 2,200 kcal per day. The United States government states that the average man needs 2,700 kcal per day and the average woman needs 2,200 kcal per day. Foods high in energy but low in nutritional value provide empty calories.",
    ts_default_sub_days: 0,
    ts_multifil: 1,
    ts_reminder_state: 0,
    ts_log_types: 5,
    m_reward:
        "Stay healthy and energetic. Grow your metabolism rate. Perform all tasks with high energy and no fatigue.",
    ts_reminder_day_start_ts: 946697400000,
    ts_reminder_day_end_ts: 946740600000,
    ts_reminder_interval_days: 10,
    num_colossals: 6,
    colossal_url_1:
        "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F1%2FArtboard%201.png?alt=media&token=23b28b81-a565-46ed-b370-1cf48ec8454d",
    colossal_url_2:
        "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F1%2FArtboard%202.png?alt=media&token=4e5f253a-8262-47d9-926e-670a3b65e47d",
    colossal_url_3:
        "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F1%2FArtboard%204.png?alt=media&token=0cc75345-c5d4-4b3b-92a7-bec9b30ca22b",
    colossal_url_4:
        "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F1%2FArtboard%205.png?alt=media&token=47861d14-f867-4e8b-8937-9c840b31e103",
    colossal_url_5:
        "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F1%2FArtboard%206.png?alt=media&token=be60246f-5329-4b67-9d6d-6bb765a97711",
    colossal_url_6:
        "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F1%2FArtboard%207.png?alt=media&token=2dddaf19-ffef-4e65-8ed6-afecc8550278");


TrackModel track_workout = new TrackModel(
  id: 2,
  name: "Track my Workout",
  icon:
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2Ftrack_workout.png?alt=media&token=7d8cf6f1-86ac-4fed-8a39-daac9e81e8b7",
  m_description: "",
  ts_autofill: 0,
  num_colossals: 0,
  ts_default_sub_days: 0,
  ts_reminder_state: 0,
  ts_reminder_day_start_ts: 946697400000,
  ts_reminder_day_end_ts: 946740600000,
  ts_reminder_interval_days: 10,
);

TrackModel track_weight = new TrackModel(
  id: 3,
  name: "Track my Weight",
  icon:
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2Ftrack_weight.png?alt=media&token=72a0c0f3-34f3-485e-9311-79e3edf6eb81",
  m_description: "",
  ts_autofill: 0,
  num_colossals: 0,
  ts_default_sub_days: 0,
  ts_reminder_state: 0,
  ts_reminder_day_start_ts: 946697400000,
  ts_reminder_day_end_ts: 946740600000,
  ts_reminder_interval_days: 10,
);

TrackModel track_water = new TrackModel(
  id: 4,
  name: "Track Water Intake",
  m_description: "",
  icon:
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2Ftrack_water.png?alt=media&token=677fae78-fa9b-45d5-b764-b86c9b1ca167",
  ts_autofill: 0,
  ts_default_sub_days: 0,
  num_colossals: 0,
  ts_reminder_state: 0,
  ts_reminder_day_start_ts: 946697400000,
  ts_reminder_day_end_ts: 946740600000,
  ts_reminder_interval_days: 10,
);

TrackModel track_body_fat = new TrackModel(
  id: 5,
  name: "Track my Body Fat",
  icon:
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2Ftrack_body_fat.png?alt=media&token=41760681-f09d-46c8-a4ed-760bb78f3b31",
  m_description: "",
  ts_autofill: 0,
  num_colossals: 0,
  ts_default_sub_days: 0,
  ts_reminder_state: 0,
  ts_reminder_day_start_ts: 946697400000,
  ts_reminder_day_end_ts: 946740600000,
  ts_reminder_interval_days: 10,
);

TrackModel track_my_transformation = new TrackModel(
  id: 6,
  name: "Track my fitness journey",
  icon:
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2Ftrack_transformation.png?alt=media&token=e792ad90-f3eb-42aa-8ab3-892ee5672094",
  m_description: "",
  ts_autofill: 0,
  ts_default_sub_days: 0,
  ts_reminder_state: 0,
  num_colossals: 0,
  ts_reminder_day_start_ts: 946697400000,
  ts_reminder_day_end_ts: 946740600000,
  ts_reminder_interval_days: 10,
);

TrackModel track_my_steps = new TrackModel(
  id: 7,
  name: "Track my Steps",
  icon:
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2Ftrack_steps.png?alt=media&token=8ce18b74-84cf-4d6b-b1e9-0f65ef6f7339",
  m_description: "",
  ts_autofill: 0,
  ts_default_sub_days: 0,
  num_colossals: 0,
  ts_reminder_state: 0,
  ts_reminder_day_start_ts: 946697400000,
  ts_reminder_day_end_ts: 946740600000,
  ts_reminder_interval_days: 10,
);

TrackModel track_fasting = new TrackModel(
  id: 8,
  name: "Track my Fast",
  icon:
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2Ftrack_fasting.png?alt=media&token=a61c4d5a-3bde-4d19-b8c2-81560c58742b",
  m_description: "",
  ts_autofill: 0,
  ts_default_sub_days: 0,
  num_colossals: 0,
  ts_reminder_state: 0,
  ts_reminder_day_start_ts: 946697400000,
  ts_reminder_day_end_ts: 946740600000,
  ts_reminder_interval_days: 10,
);

TrackModel track_sugar_consumption = new TrackModel(
  id: 9,
  name: "Track Sugar intake",
  m_description:
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2Ftrack_sugar.png?alt=media&token=0f9151c0-30b7-4bf9-8961-e76de4dedcee",
  ts_autofill: 0,
  ts_default_sub_days: 0,
  ts_reminder_state: 0,
  num_colossals: 0,
  ts_reminder_day_start_ts: 946697400000,
  ts_reminder_day_end_ts: 946740600000,
  ts_reminder_interval_days: 10,
);

TrackModel track_egg_intake = new TrackModel(
  id: 10,
  name: "Track Egg intake",
  icon:
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2Ftrack_egg.png?alt=media&token=edc57ac2-37a0-40a1-8996-1f594c47ce81",
  m_description: "",
  ts_autofill: 0,
  num_colossals: 0,
  ts_default_sub_days: 0,
  ts_reminder_state: 0,
  ts_reminder_day_start_ts: 946697400000,
  ts_reminder_day_end_ts: 946740600000,
  ts_reminder_interval_days: 10,
);

TrackModel track_green_tea = new TrackModel(
  id: 11,
  name: "Track Green tea intake",
  icon:
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2Ftrack_green_tea.png?alt=media&token=caffeb93-0532-4972-8cb9-52f02a6d9f55",
  m_description: "",
  ts_autofill: 0,
  ts_default_sub_days: 0,
  num_colossals: 0,
  ts_reminder_state: 0,
  ts_reminder_day_start_ts: 946697400000,
  ts_reminder_day_end_ts: 946740600000,
  ts_reminder_interval_days: 10,
);

TrackModel track_mood = new TrackModel(
  id: 12,
  name: "Track my Mood",
  icon:
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2Ftrack_mood.png?alt=media&token=ac418155-7abf-44f5-950b-8ffe64298f34",
  m_description: "",
  ts_autofill: 0,
  ts_default_sub_days: 0,
  num_colossals: 0,
  ts_reminder_state: 0,
  ts_reminder_day_start_ts: 946697400000,
  ts_reminder_day_end_ts: 946740600000,
  ts_reminder_interval_days: 10,
);

TrackModel track_anxiety = new TrackModel(
  id: 12,
  name: "Track my Anxiety",
  icon:
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2Ftrack_anxiety.png?alt=media&token=c0685ad9-84c3-41aa-9681-7f1011103f49",
  m_description: "",
  ts_autofill: 0,
  num_colossals: 0,
  ts_default_sub_days: 0,
  ts_reminder_state: 0,
  ts_reminder_day_start_ts: 946697400000,
  ts_reminder_day_end_ts: 946740600000,
  ts_reminder_interval_days: 10,
);
