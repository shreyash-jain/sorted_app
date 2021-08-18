import 'package:sorted/features/TRACKERS/COMMON/models/track_model.dart';

List<TrackModel> getTracksForConsultation() {
  return [
    track_weight,
    track_water,
    track_body_fat,
    track_fasting,
  ];
}

List<TrackModel> getTracksForClasses() {
  return [
    track_weight,
    track_water,
    track_body_fat,
    track_fasting,
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
//! do not changes corousel images

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
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F1%2FiPhone%2011%20Pro%20Max%20-%2066.png?alt=media&token=e0c06f69-fc86-4f55-90c5-f41dc4018794",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F1%2FiPhone%2011%20Pro%20Max%20-%2067.png?alt=media&token=e9dd2941-28ca-4783-8b44-ee6f1e5f1cf3",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F1%2FiPhone%2011%20Pro%20Max%20-%2068.png?alt=media&token=8762651e-66f8-48d8-9e9f-9001f780162f",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F1%2FiPhone%2011%20Pro%20Max%20-%2070.png?alt=media&token=a575239e-824b-4d5a-a283-ee520068c391",
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
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F2%2FiPhone%2011%20Pro%20Max%20-%2010.png?alt=media&token=4182da1e-00c7-4afa-abeb-d4d762d71951",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F2%2FiPhone%2011%20Pro%20Max%20-%2011.png?alt=media&token=76f4a5a5-7636-4932-a515-b58b9f86a876",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F2%2FiPhone%2011%20Pro%20Max%20-%2012.png?alt=media&token=30871f05-9531-41e7-9c8c-a2ed899054a9",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F2%2FiPhone%2011%20Pro%20Max%20-%2013.png?alt=media&token=08ed8344-1392-40db-9285-cde3f256fc05"
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
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F3%2FiPhone%2011%20Pro%20Max%20-%2038.png?alt=media&token=d7f8a316-26c1-40a9-b2ae-86541ca5ee5b",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F3%2FiPhone%2011%20Pro%20Max%20-%2040.png?alt=media&token=4ffa8d25-b8f6-4983-b887-d12a463a1e91",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F3%2FiPhone%2011%20Pro%20Max%20-%2041.png?alt=media&token=36aa3cc8-92a3-4b52-9413-c207ac0ca979",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F3%2FiPhone%2011%20Pro%20Max%20-%2042.png?alt=media&token=2d4b098f-c720-4d2a-9566-7b5f2a35ca30"
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
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F4%2FiPhone%2011%20Pro%20Max%20-%2058.png?alt=media&token=db76da1c-0532-4444-8c22-4f90e72b4920",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F4%2FiPhone%2011%20Pro%20Max%20-%2059.png?alt=media&token=fef89cd2-2dd7-4b49-9fec-eb2ba5dc688f",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F4%2FiPhone%2011%20Pro%20Max%20-%2060.png?alt=media&token=904a87af-cebc-4f27-b435-a860310fa070",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F4%2FiPhone%2011%20Pro%20Max%20-%2061.png?alt=media&token=1a237883-5dbf-48a6-b6b4-de625e88b683"
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
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F5%2FiPhone%2011%20Pro%20Max%20-%2054.png?alt=media&token=9deaf098-7b62-42c5-9638-1e416830257a",
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F5%2FiPhone%2011%20Pro%20Max%20-%2055.png?alt=media&token=783f20b8-7deb-41ce-84ad-1cf741c6f067",
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F5%2FiPhone%2011%20Pro%20Max%20-%2056.png?alt=media&token=75cc98f7-621f-4c6d-9259-0abbc55274a9",
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F5%2FiPhone%2011%20Pro%20Max%20-%2057.png?alt=media&token=f509e88d-60fe-47aa-b965-87e00ad475db"
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
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F6%2FiPhone%2011%20Pro%20Max%20-%2035.png?alt=media&token=29f0e377-afd7-4e70-be9e-920d5e660e57",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F6%2FiPhone%2011%20Pro%20Max%20-%2036.png?alt=media&token=89f98d1c-f883-44c2-8181-5ae671076a35",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F6%2FiPhone%2011%20Pro%20Max%20-%2037.png?alt=media&token=198a3a89-b5ae-439e-abe0-70916267d155",
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
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F7%2FiPhone%2011%20Pro%20Max%20-%2062.png?alt=media&token=e063f999-7a49-452e-9bb3-a6cabc9845ea",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F7%2FiPhone%2011%20Pro%20Max%20-%2063.png?alt=media&token=6bef7e50-74b2-4a4b-ab22-d84d27f5c112",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F7%2FiPhone%2011%20Pro%20Max%20-%2064.png?alt=media&token=f4377ef2-9e32-458d-a43e-33ce0563f471",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F7%2FiPhone%2011%20Pro%20Max%20-%2065.png?alt=media&token=9b1eb32d-6089-40a4-afe3-a59cf5f83064"
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
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F8%2FiPhone%2011%20Pro%20Max%20-%2050.png?alt=media&token=911d7571-7295-42a6-b761-ee2da6f495e5",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F8%2FiPhone%2011%20Pro%20Max%20-%2051.png?alt=media&token=bfdb20dc-2ab0-4530-ae7c-df96f22fedfc",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F8%2FiPhone%2011%20Pro%20Max%20-%2052.png?alt=media&token=1d24af17-ae40-4acf-ba0c-8be34095fe2f",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F8%2FiPhone%2011%20Pro%20Max%20-%2053.png?alt=media&token=b75614e5-5709-40dd-afba-d7d4cbbf3c84"
  ],
  ts_autofill: 0,
  ts_default_sub_days: 0,
);

TrackModel track_sugar_consumption = new TrackModel(
  id: 9,
  name: "Track Sugar intake",
  primary_property_id: 15,
  icon:
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2Ftrack_sugar.png?alt=media&token=92f47b6b-a7e5-4861-97ae-5fb596f68a9e",
  m_description:
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2Ftrack_sugar.png?alt=media&token=0f9151c0-30b7-4bf9-8961-e76de4dedcee",
  ts_autofill: 0,
  carousel: [
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F9%2FiPhone%2011%20Pro%20Max%20-%2030.png?alt=media&token=1fb585c4-eb4a-4d08-b264-c8f25811b49b",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F9%2FiPhone%2011%20Pro%20Max%20-%2031.png?alt=media&token=d7858b69-57d5-4683-96ca-7402065850d5",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F9%2FiPhone%2011%20Pro%20Max%20-%2033.png?alt=media&token=14c911d4-140e-42bc-8b9b-bec6f42c476e",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F9%2FiPhone%2011%20Pro%20Max%20-%2034.png?alt=media&token=a25fff54-162e-49fc-8d4e-5c0268c184f9"
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
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F12%2FiPhone%2011%20Pro%20Max%20-%2014.png?alt=media&token=5fc897e5-e284-4ccd-a440-bc10cc5a2188",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F12%2FiPhone%2011%20Pro%20Max%20-%2015.png?alt=media&token=9e60ed74-2b33-4d28-9885-e5e9ad69b1a7",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F12%2FiPhone%2011%20Pro%20Max%20-%2016.png?alt=media&token=abce695b-e6cf-42af-9d90-2d03a4579c81",
    "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F12%2FiPhone%2011%20Pro%20Max%20-%2017.png?alt=media&token=f907caa7-2b10-47ef-b099-18b0ed79c874"
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
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F13%2FiPhone%2011%20Pro%20Max%20-%2071.png?alt=media&token=e8070a26-17e0-46df-bf1d-ae05c29909fd",
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F13%2FiPhone%2011%20Pro%20Max%20-%2072.png?alt=media&token=a5167ae9-74c2-43ab-ab53-c9cac6571549",
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F13%2FiPhone%2011%20Pro%20Max%20-%2074.png?alt=media&token=48cce181-1520-47e1-b743-52cf9e88b96b",
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F13%2FiPhone%2011%20Pro%20Max%20-%2075.png?alt=media&token=d8696e0a-3905-44c0-a196-56c0df9bca4c"
    ]);
TrackModel track_sleep = new TrackModel(
    id: 14,
    name: "Track Sleep",
    primary_property_id: 22,
    icon:
        "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2Ftrack_sleep.png?alt=media&token=21463253-5a01-4e59-8c01-efcaa3e77780",
    m_description: "",
    ts_autofill: 0,
    carousel: [
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F14%2FiPhone%2011%20Pro%20Max%20-%2026.png?alt=media&token=2899b724-a0bd-4381-a8b3-f19f468fe68e",
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F14%2FiPhone%2011%20Pro%20Max%20-%2027.png?alt=media&token=0afaace6-84d6-456c-8b07-b060887faa0d",
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F14%2FiPhone%2011%20Pro%20Max%20-%2028.png?alt=media&token=64f35c15-3771-4a4c-854e-fbf398e9e3d3",
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F14%2FiPhone%2011%20Pro%20Max%20-%2029.png?alt=media&token=c8cac6ea-3190-4ce7-9116-51a8f1eecf84"
    ]);
TrackModel track_yoga = new TrackModel(
    id: 2,
    name: "Track Yoga workout",
    primary_property_id: 2,
    icon:
        "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2Ftrack_yoga.png?alt=media&token=bfd1c0d4-6bd8-41f7-8f14-5477ade74f66",
    m_description: "",
    ts_autofill: 0,
    carousel: [
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2Fyoga%2FiPhone%2011%20Pro%20Max%20-%205.png?alt=media&token=09bcf4fa-1512-4ecc-8234-28e1e5ba6818",
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2Fyoga%2FiPhone%2011%20Pro%20Max%20-%206.png?alt=media&token=e1ad66b8-9ded-4ff2-990f-bd6a366a10bb",
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2Fyoga%2FiPhone%2011%20Pro%20Max%20-%207.png?alt=media&token=d33214d1-5716-409a-98d1-3e84f4899a50",
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2Fyoga%2FiPhone%2011%20Pro%20Max%20-%208.png?alt=media&token=8cc9939a-de69-4770-b03c-f769ddef7d7a"
    ]);
TrackModel track_screentime = new TrackModel(
    id: 16,
    name: "Track Screentime",
    primary_property_id: 23,
    icon:
        "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2Ftrack_screentime.png?alt=media&token=55ecb46e-9cba-4f42-abd3-cb155a7d9013",
    m_description: "",
    ts_autofill: 0,
    carousel: [
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F16%2FiPhone%2011%20Pro%20Max%20-%2018.png?alt=media&token=8aa73ae1-3718-4a99-aa40-4aa9e68a2a96",
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F16%2FiPhone%2011%20Pro%20Max%20-%2019.png?alt=media&token=aa4b315b-263c-47d4-9397-f3c76248d02e",
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F16%2FiPhone%2011%20Pro%20Max%20-%2020.png?alt=media&token=f5368b74-a1d2-4764-940d-fdee2ffa5a56",
      "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_colossal%2F16%2FiPhone%2011%20Pro%20Max%20-%2021.png?alt=media&token=7266c4f8-3ab9-472a-a228-b5a44b52d9ab"
    ]);
