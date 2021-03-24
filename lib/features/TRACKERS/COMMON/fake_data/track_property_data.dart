import 'package:sorted/features/TRACKERS/COMMON/models/track_model.dart';
import 'package:sorted/features/TRACKERS/COMMON/models/track_property.dart';

//track model id global path -> tracking/data/tracks/1/
TrackProperty foodItems = new TrackProperty(
    id: 1,
    track_id: 1,
    property_type: 4,
    property_name: "Food Items",
    property_icon_url:
        "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2F1%2Ffood.png?alt=media&token=972b8ba5-dfa8-45f8-8238-37ce77236629",
    property_description: "Tracks the food items of a meal");
TrackProperty calories = new TrackProperty(
    id: 2,
    track_id: 1,
    property_type: 1,
    property_name: "Calories",
    n_max: 500,
    n_min: 0,
    n_u_aim_start: 300,
    n_aim_type: 0,
    n_u_aim_condition: 0,
    property_icon_url:
        "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2F1%2Fcalories.png?alt=media&token=bba7f04a-15f6-42b2-b362-3faa8d50b4a7",
    property_description: "Tracks the calories of a meal");
TrackProperty protien = new TrackProperty(
    id: 3,
    track_id: 1,
    property_type: 1,
    property_name: "Protien",
    property_icon_url:
        "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2F1%2Ficons8-protein-supplement-96.png?alt=media&token=d73b906a-f8da-469d-b3d0-f2244336453a",
    property_description: "Tracks the protien content of a meal");
TrackProperty carbohydrates = new TrackProperty(
    id: 4,
    track_id: 1,
    property_type: 1,
    property_name: "Carbs",
    property_icon_url:
        "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2F1%2Ffrench-fries%20(1).png?alt=media&token=0191e7f0-1b7a-4bb7-896c-08e993a3c28b",
    property_description: "Tracks the carbs content of a meal");
TrackProperty fats = new TrackProperty(
    id: 5,
    track_id: 1,
    property_type: 1,
    property_name: "Fats",
    property_icon_url:
        "https://firebasestorage.googleapis.com/v0/b/sorted-98c02/o/track_store%2Ftrack_icons%2F1%2Fcheese.png?alt=media&token=f518d5d5-3f53-49aa-ad41-ab5503a96e38",
    property_description: "Tracks the fat content of a meal");
