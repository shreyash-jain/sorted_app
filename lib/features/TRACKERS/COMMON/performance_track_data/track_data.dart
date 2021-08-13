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

TrackModel getTrackById(int id) {
  return getAllTracks().firstWhere((element) => element.id == id,
      orElse: () => TrackModel(id: -1));
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
    track_anger,
    track_sleep,
    track_yoga,
    track_screentime,
    track_sugar_consumption,
    track_egg_intake,
    track_fasting
  ];
}

TrackModel diet_track = new TrackModel(
  id: 1,
  name: "Track Food",
  icon:
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2Ftrack_diet.png?alt=media&token=5681f96d-7d28-4b3b-8cbf-07792260d62d",
  m_description:
      "A calorie is a unit of energy gained by the consumption of food. On one hand, calories make us stronger and resistant but on the other they may add up to our body fat severely. Therefore our calorie intake should be strictly monitored. Here we come to assistance with our track to manage your calorie consumption daily.",
  ts_autofill: 0,
  primary_property_id: 2,
  m_facts:
      "The United States government states that the average man needs 2,700 kcal per day and the average woman needs 2,200 kcal per day. The United States government states that the average man needs 2,700 kcal per day and the average woman needs 2,200 kcal per day. Foods high in energy but low in nutritional value provide empty calories.",
  ts_default_sub_days: 0,
  ts_multifil: 1,
  ts_log_types: 5,
  m_reward:
      "Stay healthy and energetic. Grow your metabolism rate. Perform all tasks with high energy and no fatigue.",
  carousel: [
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F1%2FArtboard%201.png?alt=media&token=23b28b81-a565-46ed-b370-1cf48ec8454d",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F1%2FArtboard%202.png?alt=media&token=4e5f253a-8262-47d9-926e-670a3b65e47d",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F1%2FArtboard%204.png?alt=media&token=0cc75345-c5d4-4b3b-92a7-bec9b30ca22b",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F1%2FArtboard%205.png?alt=media&token=47861d14-f867-4e8b-8937-9c840b31e103",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F1%2FArtboard%206.png?alt=media&token=be60246f-5329-4b67-9d6d-6bb765a97711",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F1%2FArtboard%207.png?alt=media&token=2dddaf19-ffef-4e65-8ed6-afecc8550278"
  ],
);

TrackModel track_workout = new TrackModel(
  id: 2,
  name: "Track Workout",
  primary_property_id: 8,
  icon:
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2Ftrack_workout.png?alt=media&token=7d8cf6f1-86ac-4fed-8a39-daac9e81e8b7",
  m_description:
      "It will help you create and stick to your fitness routine. Fitness trackers help you develop healthy habits by managing your fitness activities, which allows you to live a healthier lifestyle. By being aware of how your body responds, moves, or rest, you can make the necessary changes in your daily activities to develop healthier habits.It helps a person develop healthy habits by being constantly reminded to move and avoid prolonged sitting or not doing anything. Also, it keeps you motivated to complete your daily workout regimen so you can achieve your health and fitness goals.",
  m_facts:
      "Researchers found that after using a fitness tracker for 12 weeks, participants were more likely to increase their levels of physical activity years later. Those who tracked their activity were also 44 percent less likely to have a bone fracture and 66 percent less likely to have a heart attack or stroke.",
  m_reward:
      "Have a sound life with a night of better sleep. Experience the peace of mind as it matters the most. Replenish your health as it affects your life directly and indirectly. Keep your bowel and muscular movements on point.",
  ts_autofill: 0,
  ts_default_sub_days: 0,
  carousel: [
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F2%2FiPhone%2011%20Pro%20Max%20-%2010.png?alt=media&token=7ecfe11b-9346-4afa-afcb-bde17f8a0b6c",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F2%2FiPhone%2011%20Pro%20Max%20-%2011.png?alt=media&token=2059bcf5-7d8e-446b-ad06-abf085ec054f",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F2%2FiPhone%2011%20Pro%20Max%20-%2012.png?alt=media&token=4d74e772-5a19-4a9d-99f2-5743c3aae147",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F2%2FiPhone%2011%20Pro%20Max%20-%2013.png?alt=media&token=e84f770a-a709-4c2c-9305-73e6e958a2a4"
  ],
  ts_multifil: 1,
);

TrackModel track_weight = new TrackModel(
  id: 3,
  name: "Track Weight",
  primary_property_id: 8,
  icon:
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2Ftrack_weight.png?alt=media&token=72a0c0f3-34f3-485e-9311-79e3edf6eb81",
  m_description:
      "Human body weight refers to a person's mass or weight. It can be maintained with constant workout, exercise and controlled food intake. Keep a detailed track of your body weight, muscle weight, waist circumference etc with us and grow healthier and stronger.",
  m_facts:
      "BMI is a useful measure of overweight and obesity. It is calculated from your height and weight. BMI is an estimate of body fat and a good gauge of your risk for diseases that can occur with more body fat. The higher your BMI, the higher your risk for certain diseases such as heart disease, high blood pressure, type 2 diabetes, gallstones, breathing problems, and certain cancers Measuring waist circumference helps screen for possible health risks that come with overweight and obesity.",
  m_reward:
      "Your body more efficiently circulates blood. Your fluid levels are more easily managed. You are less likely to develop diabetes, heart disease, certain cancers, gallstones, osteoarthritis, breathing problems and sleep apnea. You may feel better about yourself and have more energy to make other positive health changes.",
  carousel: [
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F3%2FiPhone%2011%20Pro%20Max%20-%2038.png?alt=media&token=0a4681de-0590-4f82-975b-ad1aae1826c0",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F3%2FiPhone%2011%20Pro%20Max%20-%2040.png?alt=media&token=475886fb-85ea-4bfe-9854-2417264b6678",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F3%2FiPhone%2011%20Pro%20Max%20-%2041.png?alt=media&token=f0778771-6b5c-4a82-ba3e-fb1d986d5029",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F3%2FiPhone%2011%20Pro%20Max%20-%2042.png?alt=media&token=cc63642a-c608-42e5-acb2-b474ccb9bc3c"
  ],
  ts_autofill: 0,
);

TrackModel track_water = new TrackModel(
  id: 4,
  name: "Track Water Intake",
  primary_property_id: 9,
  m_description:
      "Keeping yourself hydrated is essential for health and well-being. Around 60% of the body is made up of water. Water keeps our body lubricated and it not only affects physical health but also mental health. Keep a track of your daily water consumption and get on the right path",
  icon:
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2Ftrack_water.png?alt=media&token=677fae78-fa9b-45d5-b764-b86c9b1ca167",
  ts_autofill: 0,
  m_facts:
      "Doctors state that a person should drink eight glasses of water per day. Water delivers oxygen throughout the body. Drinking water instead of soda can help with weight loss Water cushions the brain, spinal cord, and other sensitive tissues. Water regulates the body temperature",
  m_reward:
      "Maintained blood pressure with a healthy body with access to necessary minerals and nutrients. A boost in skin health and beauty. A healthy bowel system  ",
  carousel: [
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F4%2FiPhone%2011%20Pro%20Max%20-%2058.png?alt=media&token=94df9f0f-fe90-4ed1-b028-ab9c41150ac3",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F4%2FiPhone%2011%20Pro%20Max%20-%2059.png?alt=media&token=69123c42-e9a9-4fc8-a0cb-14b6fd5fd1dd",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F4%2FiPhone%2011%20Pro%20Max%20-%2060.png?alt=media&token=c532bb25-1b35-4043-821c-3655cb102c0e",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F4%2FiPhone%2011%20Pro%20Max%20-%2061.png?alt=media&token=fe3afd2c-a415-403b-9602-41edddc276ec"
  ],
  ts_default_sub_days: 0,
);

TrackModel track_body_fat = new TrackModel(
    id: 5,
    name: "Track Body Fat",
    primary_property_id: 10,
    icon:
        "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2Ftrack_body_fat.png?alt=media&token=41760681-f09d-46c8-a4ed-760bb78f3b31",
    m_description:
        "Fat surrounds and cushions vital organs like the kidneys and insulates us against the cold. Body fat also signifies health, conferring beauty when distributed in the right amounts and locations. But critically, fat is our fuel tank—a strategic calorie reserve to protect against starvation. Track and maintain your body fat to stay fit and fine.",
    m_facts:
        "According to the Centers for Disease Control and Prevention (CDC)Trusted Source, a healthy diet to maintain body fat includes: vegetables, fruit, whole grains, and fat-free or low fat dairy products lean meats, fish, poultry, eggs, nuts, and beans minimal added sugars, salt, cholesterol, saturated fats, and trans fats",
    carousel: [
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F5%2FiPhone%2011%20Pro%20Max%20-%2054.png?alt=media&token=92200893-591f-4cc3-988a-c1128d4b4973",
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F5%2FiPhone%2011%20Pro%20Max%20-%2055.png?alt=media&token=9afe029c-27a9-4fa5-9c71-ce996e3bf0eb",
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F5%2FiPhone%2011%20Pro%20Max%20-%2056.png?alt=media&token=78bf62c1-5b38-48b1-8c94-1ca4f70c0eea",
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F5%2FiPhone%2011%20Pro%20Max%20-%2057.png?alt=media&token=774a8215-990c-433b-bf31-392a453523fb"
    ],
    m_reward:
        "Freedom from obesity A strong cardiovascular system. A balanced physique to conquer all arenas of work.");

TrackModel track_my_transformation = new TrackModel(
  id: 6,
  name: "Track fitness journey",
  primary_property_id: 11,
  icon:
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2Ftrack_transformation.png?alt=media&token=e792ad90-f3eb-42aa-8ab3-892ee5672094",
  m_description: "",
  carousel: [
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F6%2FiPhone%2011%20Pro%20Max%20-%2035.png?alt=media&token=9e708760-62f4-4775-9e15-8341c3cc5a12",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F6%2FiPhone%2011%20Pro%20Max%20-%2036.png?alt=media&token=087b9245-1143-44b2-962d-3c3d4e9e9041",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F6%2FiPhone%2011%20Pro%20Max%20-%2037.png?alt=media&token=8a7c3a99-dc69-4df1-bf80-9598e57600b2",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F6%2FiPhone%2011%20Pro%20Max%20-%2038.png?alt=media&token=1ec0090b-87a3-4ae5-8057-8b402c43864d"
  ],
  ts_autofill: 0,
  ts_default_sub_days: 0,
);

TrackModel track_my_steps = new TrackModel(
  id: 7,
  name: "Track Steps",
  primary_property_id: 13,
  carousel: [
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F7%2FiPhone%2011%20Pro%20Max%20-%2062.png?alt=media&token=ddc106cb-fbbf-4210-a9dd-1c91ec2c89b6",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F7%2FiPhone%2011%20Pro%20Max%20-%2063.png?alt=media&token=4551339c-7276-4699-87e5-9ace3076c28a",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F7%2FiPhone%2011%20Pro%20Max%20-%2064.png?alt=media&token=4cf642dd-6694-4fc3-95e0-d1284371707a",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F7%2FiPhone%2011%20Pro%20Max%20-%2065.png?alt=media&token=17e89c0c-aa8f-4c6d-93fd-65d251df23a4"
  ],
  icon:
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2Ftrack_steps.png?alt=media&token=8ce18b74-84cf-4d6b-b1e9-0f65ef6f7339",
  m_description: "",
  ts_autofill: 0,
  ts_default_sub_days: 0,
);

TrackModel track_fasting = new TrackModel(
  id: 8,
  name: "Track Fasting",
  primary_property_id: 14,
  icon:
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2Ftrack_fasting.png?alt=media&token=a61c4d5a-3bde-4d19-b8c2-81560c58742b",
  m_description: "",
  carousel: [
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F8%2FiPhone%2011%20Pro%20Max%20-%2050.png?alt=media&token=090dc3f1-a4e8-48d0-90e3-b88750beb323",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F8%2FiPhone%2011%20Pro%20Max%20-%2051.png?alt=media&token=bd4c2dd8-31a7-43af-a303-d4fe8b89b4f5",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F8%2FiPhone%2011%20Pro%20Max%20-%2052.png?alt=media&token=fb948425-b21a-4453-903e-d08ec082feae",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F8%2FiPhone%2011%20Pro%20Max%20-%2053.png?alt=media&token=3a613c2a-3f32-4834-ac99-ee15f5805c51"
  ],
  ts_autofill: 0,
  ts_default_sub_days: 0,
);

TrackModel track_sugar_consumption = new TrackModel(
  id: 9,
  name: "Track Sugar intake",
  primary_property_id: 15,
  icon:
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2Ftrack_fasting.png?alt=media&token=a61c4d5a-3bde-4d19-b8c2-81560c58742b",
  m_description:
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2Ftrack_sugar.png?alt=media&token=0f9151c0-30b7-4bf9-8961-e76de4dedcee",
  ts_autofill: 0,
  carousel: [
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F9%2FiPhone%2011%20Pro%20Max%20-%2030.png?alt=media&token=84dd027b-3375-47d0-abff-4e1efd267f29",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F9%2FiPhone%2011%20Pro%20Max%20-%2031.png?alt=media&token=0591cea8-5e98-463f-a1a9-99fc263b84f2",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F9%2FiPhone%2011%20Pro%20Max%20-%2033.png?alt=media&token=355d4ead-bd0a-4cac-8875-6f1c27ae565a",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F9%2FiPhone%2011%20Pro%20Max%20-%2034.png?alt=media&token=631bf02d-95d9-4ef0-b2ac-a4eee3df58cd"
  ],
  ts_default_sub_days: 0,
);

TrackModel track_egg_intake = new TrackModel(
  id: 10,
  name: "Track Egg intake",
  primary_property_id: 16,
  icon:
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2Ftrack_egg.png?alt=media&token=edc57ac2-37a0-40a1-8996-1f594c47ce81",
  m_description: "",
  ts_autofill: 0,
);

TrackModel track_green_tea = new TrackModel(
  id: 11,
  name: "Track Green tea intake",
  primary_property_id: 17,
  icon:
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2Ftrack_green_tea.png?alt=media&token=caffeb93-0532-4972-8cb9-52f02a6d9f55",
  m_description: "",
  ts_autofill: 0,
  ts_default_sub_days: 0,
);

TrackModel track_mood = new TrackModel(
  id: 12,
  name: "Track Mood",
  primary_property_id: 18,
  icon:
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2Ftrack_mood.png?alt=media&token=ac418155-7abf-44f5-950b-8ffe64298f34",
  m_description: "",
  carousel: [
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F12%2FiPhone%2011%20Pro%20Max%20-%2014.png?alt=media&token=64b5d31b-b0e2-444a-83d6-81d6214a828f",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F12%2FiPhone%2011%20Pro%20Max%20-%2015.png?alt=media&token=c016bdd6-17a3-4702-a688-ee72124d7f83",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F12%2FiPhone%2011%20Pro%20Max%20-%2016.png?alt=media&token=52d90446-e4bd-4a70-8437-69f43031fd8b",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F12%2FiPhone%2011%20Pro%20Max%20-%2017.png?alt=media&token=2dcf7147-48f1-4b6d-b2a6-515e4f294158"
  ],
  ts_autofill: 0,
  ts_default_sub_days: 0,
);

TrackModel track_anger = new TrackModel(
    id: 13,
    name: "Track Anger",
    primary_property_id: 20,
    icon:
        "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2Ftrack_anxiety.png?alt=media&token=c0685ad9-84c3-41aa-9681-7f1011103f49",
    m_description: "",
    ts_autofill: 0,
    carousel: [
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F13%2FiPhone%2011%20Pro%20Max%20-%2071.png?alt=media&token=e1c8720f-eade-444a-8912-816ea601a511",
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F13%2FiPhone%2011%20Pro%20Max%20-%2072.png?alt=media&token=7145beda-0137-49bb-8230-d5bf90de7f23",
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F13%2FiPhone%2011%20Pro%20Max%20-%2074.png?alt=media&token=566aa555-ea2a-4c81-9ba1-432e9e3b4d44",
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F13%2FiPhone%2011%20Pro%20Max%20-%2075.png?alt=media&token=cf1dc055-f5e7-4756-bf13-8d05174f42ef"
    ]);
TrackModel track_sleep = new TrackModel(
    id: 14,
    name: "Track Sleep",
    primary_property_id: 22,
    icon:
        "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2Ftrack_anxiety.png?alt=media&token=c0685ad9-84c3-41aa-9681-7f1011103f49",
    m_description: "",
    ts_autofill: 0,
    carousel: [
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F14%2FiPhone%2011%20Pro%20Max%20-%2026.png?alt=media&token=87ca256a-868d-4063-a846-250f0e233570",
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F14%2FiPhone%2011%20Pro%20Max%20-%2027.png?alt=media&token=e2bc8e04-f773-4050-8af5-117f75a377c3",
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F14%2FiPhone%2011%20Pro%20Max%20-%2028.png?alt=media&token=4c15755f-5d26-4897-b994-02668ff1dc0b",
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F14%2FiPhone%2011%20Pro%20Max%20-%2030.png?alt=media&token=2aaae052-54f8-4046-8b46-daa2d8729415"
    ]);
TrackModel track_yoga = new TrackModel(
    id: 2,
    name: "Track Yoga workout",
    primary_property_id: 2,
    icon:
        "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2Ftrack_anxiety.png?alt=media&token=c0685ad9-84c3-41aa-9681-7f1011103f49",
    m_description: "",
    ts_autofill: 0,
    carousel: [
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F15%2FiPhone%2011%20Pro%20Max%20-%205.png?alt=media&token=bb89cafb-a95d-4df6-a447-79602b744ba6",
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F15%2FiPhone%2011%20Pro%20Max%20-%206.png?alt=media&token=cc60b252-ad93-44e0-89d0-c1ac6bd5bc2f",
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F15%2FiPhone%2011%20Pro%20Max%20-%207.png?alt=media&token=3c99e1e0-5081-431e-a913-9e5f7611599b",
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F15%2FiPhone%2011%20Pro%20Max%20-%208.png?alt=media&token=f8b153c3-551b-4fcf-add2-8501d91d574e"
    ]);
TrackModel track_screentime = new TrackModel(
    id: 16,
    name: "Track Screentime",
    primary_property_id: 23,
    icon:
        "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2Ftrack_anxiety.png?alt=media&token=c0685ad9-84c3-41aa-9681-7f1011103f49",
    m_description: "",
    ts_autofill: 0,
    carousel: [
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F16%2FiPhone%2011%20Pro%20Max%20-%2018.png?alt=media&token=84508902-9225-446f-86f7-200aa860e388",
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F16%2FiPhone%2011%20Pro%20Max%20-%2019.png?alt=media&token=1bc4bb62-8bc7-4fc7-9a55-c79ea9adc060",
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F16%2FiPhone%2011%20Pro%20Max%20-%2020.png?alt=media&token=ad6f372c-cc6f-4dd6-b14b-0ae2fbcf0cb1",
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F16%2FiPhone%2011%20Pro%20Max%20-%2021.png?alt=media&token=908b90a1-103d-4f9c-9670-a1313fed2a6e"
    ]);
