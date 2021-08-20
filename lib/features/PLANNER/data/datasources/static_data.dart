import 'package:sorted/features/PLANNER/data/models/diet_plan.dart';
import 'package:sorted/features/PLANNER/data/models/workout_plan.dart';

DietPlanModel dietPlan = DietPlanModel(
  id: 1,
  name: "Diet chart to lose weight for females- Vegetarian",
  foodsToAvoid:
      "['Highly sweetened beverages such as soda, aerated drinks, sports drinks' , ' Sweeteners like sugar, honey, condensed milk' , 'Foods which have high sugar such as candy, ice cream, cakes, cookies, rice pudding, high sugar cereals etc.' , 'Foods which have high fats such as French fries, chips, fried foods etc.' , 'Trans fats like Vanaspati, margarine, processed foods' , 'Refined oils such as canola oil, soybean oil, grapeseed oil etc.' , 'Refined grains like white bread, white pasta']",
  imageUrl:
      "https://global-uploads.webflow.com/5ca5fe687e34be0992df1fbe/5d9ebc7dd8c390367e58eacf_indian%20diet.jpeg",
  type: 1,
  foodsToEat:
      "['Fruits with buttermilk or green tea' , 'Protein shake with nuts and seeds' , 'Veg sandwich or milk and apple' , 'Walnuts and dates' , 'Vegetable/ fruit salads' , 'Fresh fruit smoothies or whey protein shakes' , 'Multigrain flour khakras' ]",
  length: 7,
  day1breakfastItems: "Sambar,Idlis,Mint chutney",
  day1breakfastIds: "6570:1,3418:2,4633:1",
  day1lunchItems: "Whole-grain roti,Vegetable sabzi,Dal,Brown rice",
  day1lunchIds: "4917:3,4756:1,595:1,949:1",
  day1dinnerItems:
      "Chana masala,Basmati rice,Green salad,One bowl of fruits and vegetables,Multigrain rotis",
  day1dinnerIds: "4278:1,3348:1,2014:1,2676:1,4921:3",
  day2breakfastItems: "Vegetable dalia,Glass of milk,Dal paddu,Sambar",
  day2breakfastIds: "2237:1,3418:2,4633:1,6570:1",
  day2lunchItems: "Large salad,Rajma curry,Quinoa Vegetable kadai",
  day2lunchIds: "513:1,6322:1,6238:1",
  day2dinnerItems:
      "Tofu curry with mixed vegetables,Fresh spinach salad,Multigrain rotis",
  day2dinnerIds: "7708:1,2759:1,4921:3",
  day3breakfastItems: "Vegetable uttapam,Sambhar",
  day3breakfastIds: "5218:1,6570:2",
  day3lunchItems: "Chickpea curry,Brown rice,Dal",
  day3lunchIds: "4283:1,949:1,2215:1",
  day3dinnerItems: "Khichdi,Sprout salad,Veg paratha,Raita",
  day3dinnerIds: "3785:1,4721:1,7038:3,6788:1",
  day4breakfastItems: "Buckwheat porridge,Fruit salad,Glass of milk",
  day4breakfastIds: "404:3,2584:1,3418:1",
  day4lunchItems: "Vegetable soup,Dal khichdi,Multigrain roti",
  day4lunchIds: "4747:1,3785:1,4921:3",
  day4dinnerItems: "Masala-baked tofu,Vegetable curry,Multigrain roti",
  day4dinnerIds: "7714:1,7974:1,4921:3",
  day5breakfastItems: "Chana dal pancakes,Glass of milk",
  day5breakfastIds: "1239:3,3418:1",
  day5lunchItems: "Chickpea curry,Brown rice,Dal",
  day5lunchIds: "4283:1,949:1,2215:1",
  day5dinnerItems: "Khichdi,Sprout salad,Veg paratha,Raita",
  day5dinnerIds: "3785:1,4721:1,7038:3,6788:1",
  day6breakfastItems: "Yogurt,Sliced fruits,Vegetable poha",
  day6breakfastIds: "580:1,2584:1,5948:1",
  day6lunchItems: "Whole-grain roti,Vegetable sabzi,Dal,Brown rice",
  day6lunchIds: "4921:3,4756:1,595:1,949:1",
  day6dinnerItems:
      "Chana masala,Basmati rice,Green salad,One bowl of fruits and vegetables,Multigrain rotis",
  day6dinnerIds: "4278:1,3348:1,2014:1,2676:1,4921:3",
  day7breakfastItems:
      "Multigrain parathas,Sliced papaya,Dal paratha,Mixed vegetables",
  day7breakfastIds: "388:1,2940:1,4819:3,4645:1",
  day7lunchItems: "Chickpea curry,Brown rice,Dal",
  day7lunchIds: "4283:1,949:1,2215:1",
  day7dinnerItems: "Khichdi,Sprout salad,Veg paratha,Raita",
  day7dinnerIds: "3785:1,4721:1,7038:3,6788:1",
);

WorkoutPlanModel workoutPlan = WorkoutPlanModel(
  id: 1,
  name: "7 Day Split Workout Program for Advanced Weight Training",
  imageUrl:
      "https://www.verywellfit.com/thmb/nyJUOzk6bXtKKU_zBARo0JbgEOY=/768x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/Pushups-5680bb925f9b586a9edf3927.jpg",
  length: 7,
  calorieBurnt: 1200,
  day1name: "Chest Day",
  day1activityIds: "[2,3,4,5]",
  day1sets: "[]",
  day1reps:
      "[2:[12,0],2:[10,0],2:[10,0],-1:[30],3:[12,0],3:[10,0],3:[10,0],-1:[30],4:[12,0],4:[10,0],4:[10,0],-1:[30],5:[12,0],5:[12,0],5:[12,0],-1:[60]]",
  day2name: "Legs Day",
  day2activityIds: "[6,7,8,9]",
  day2reps:
      "[6:[12,0],6:[10,0],6:[10,0],-1:[30],7:[12,0],7:[10,0],7:[10,0],-1:[30],8:[12,0],8:[10,0],8:[10,0],-1:[30],9:[12,0],9:[12,0],9:[12,0],-1:[60]]",
  day3name: "Chest Day",
  day3activityIds: "[10,11,12,13]",
  day3reps:
      "[10:[12,0],10:[10,0],10:[10,0],-1:[30],11:[12,0],11:[10,0],11:[10,0],-1:[30],12:[12,0],12:[10,0],12:[10,0],-1:[30],13:[12,0],13:[12,0],13:[12,0],-1:[60]]",
  day4name: "Upper Body Day",
  day4activityIds: "[14,15,16,17]",
  day4reps:
      "[14:[12,0],14:[10,0],14:[10,0],-1:[30],15:[12,0],15:[10,0],15:[10,0],-1:[30],16:[12,0],16:[10,0],16:[10,0],-1:[30],17:[12,0],17:[12,0],17:[12,0],-1:[60]]",
  day5name: "Lower Body day",
  day5activityIds: "[18,19,20,21]",
  day5reps:
      "[18:[12,0],18:[10,0],18:[10,0],-1:[30],19:[12,0],19:[10,0],19:[10,0],-1:[30],20:[12,0],20:[10,0],20:[10,0],-1:[30],21:[12,0],21:[12,0],21:[12,0],-1:[60]]",
  day6name: "Core Day",
  day6activityIds: "[22,23,24,25]",
  day6reps:
      "[22:[12,0],22:[10,0],22:[10,0],-1:[30],23:[12,0],23:[10,0],23:[10,0],-1:[30],24:[12,0],24:[10,0],24:[10,0],-1:[30],25:[12,0],25:[12,0],25:[12,0],-1:[60]]",
  day7activityIds: "[26]",
  day7name: "Break",
);
