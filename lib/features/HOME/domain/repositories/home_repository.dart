import 'package:dartz/dartz.dart';
import 'package:sorted/core/global/models/user_details.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/data/models/blog_textbox.dart';
import 'package:sorted/features/HOME/data/models/blogs.dart';
import 'package:sorted/features/HOME/data/models/inspiration.dart';
import 'package:sorted/features/HOME/data/models/recipe.dart';
import 'package:sorted/features/HOME/data/models/tagged_recipe.dart';
import 'package:sorted/features/HOME/data/models/transformation.dart';
import 'package:sorted/features/HOME/data/models/video_recipe.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:sorted/features/HOME/domain/entities/display_thumbnail.dart';
import 'package:sorted/features/PROFILE/data/models/activity.dart';
import 'package:sorted/features/PROFILE/data/models/user_activity.dart';

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
}
