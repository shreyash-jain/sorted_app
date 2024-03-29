import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:sorted/features/FEED/data/models/feed_model.dart';
import 'package:sorted/features/FEED/domain/entities/feed_post_entity.dart';
import 'package:sorted/features/HOME/data/datasources/home_cloud_data_source.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/data/models/blog_textbox.dart';
import 'package:sorted/features/HOME/data/models/blogs.dart';
import 'package:sorted/features/HOME/data/models/challenge_model.dart';
import 'package:sorted/features/HOME/data/models/inspiration.dart';
import 'package:sorted/features/HOME/data/models/motivation/pep_talks.dart';
import 'package:sorted/features/HOME/data/models/motivation/transformation.dart';
import 'package:sorted/features/HOME/data/models/recipes/recipe.dart';
import 'package:sorted/features/HOME/data/models/recipes/recipe_howto.dart';
import 'package:sorted/features/HOME/data/models/recipes/recipe_nutrition.dart';
import 'package:sorted/features/HOME/data/models/recipes/recipe_step.dart';
import 'package:sorted/features/HOME/data/models/recipes/recipe_to_ingredient.dart';
import 'package:sorted/features/HOME/data/models/recipes/tagged_recipe.dart';

import 'package:sorted/features/HOME/data/models/recipes/video_recipe.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:sorted/features/HOME/domain/entities/display_thumbnail.dart';
import 'package:sorted/features/PLANNER/data/models/diet_plan.dart';
import 'package:sorted/features/PLANNER/data/models/workout_plan.dart';

import '../../../../core/error/failures.dart';

abstract class HomeRepository {
  /// Gets the affirmations from cloud and favourates and also adds to local
  ///
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, List<DayAffirmation>>> get todayAffirmations;

  /// Gets the inspiration from cloud also adds to local
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, InspirationModel>> get inspiration;

  /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, List<DisplayThumbnail>>> get thumbnails;

  /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, void>> addToFav(AffirmationModel affirmation);

  /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, void>> removeFromFav(AffirmationModel affirmation);

  /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, void>> updateCurrentAffirmation(
      DayAffirmation affirmation);

  /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, List<BlogModel>>> get blogs;

  /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, BlogModel>> getBlogFromId(int id);

  /// Gets the textboxes of a article from cloud.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, List<BlogTextboxModel>>> getTextBoxesOfBlog(
      int blogId);

  /// Gets the tagged recipes [count] from cloud.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, List<TaggedRecipe>>> getTaggedRecipes(int count);

  /// Gets the tagged recipes of Id from cloud.
  ///
  /// returns [Either<Failure, TaggedRecipe>] the state of user
  Future<Either<Failure, TaggedRecipe>> getTaggedRecipesOfId(int id);

  /// Gets the video recipe from cloud.
  ///
  /// returns [Either<Failure, VideoRecipe>] the state of user
  Future<Either<Failure, RecipeModel>> getRecipeById(int id);

  /// Gets the video recipe from cloud.
  ///
  /// returns [Either<Failure, VideoRecipe>] the state of user
  Future<Either<Failure, VideoRecipe>> getVideoRecipe();

  /// Gets the transformation from cloud.
  ///
  /// returns [Either<Failure, TransformationModel>] the state of user
  Future<Either<Failure, TransformationModel>> getTransformationStory();
  Future<Either<Failure, List<BlogModel>>> getBlogs(count);

  Future<Either<Failure, ChallengeModel>> getChallengeOfTheDay();
  Future<Either<Failure, PepTalkModel>> getMotivationOfTheDay();

  Future<Either<Failure, FeedPostEntity>> getFeed(
      int limit, DocumentSnapshot lastDoc);
  Future<Either<Failure, int>> addPost(PostModel post);

  Future<Either<Failure, List<DietPlanModel>>> getGlobalDietPlans();
  Future<Either<Failure, List<WorkoutPlanModel>>> getGlobalWorkoutPlans();
}
