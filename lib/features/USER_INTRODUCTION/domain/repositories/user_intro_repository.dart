import 'package:dartz/dartz.dart';

import 'package:sorted/core/global/models/health_condition.dart';
import 'package:sorted/core/global/models/health_profile.dart';

import 'package:sorted/core/global/models/user_details.dart';
import 'package:sorted/features/PROFILE/data/models/activity.dart';
import 'package:sorted/features/PROFILE/data/models/user_activity.dart';
import 'package:sorted/features/USER_INTRODUCTION/data/models/user_tag.dart';

import '../../../../core/error/failures.dart';

abstract class UserIntroductionRepository {
  /// Check if the user is an old one, if yes then will download
  /// his/her previous data or if user is new then set up the
  /// database by downloading start data from cloud to Native
  ///
  /// return [Either<Failure,Stream<double>>] if cloud was reached then progress is retrned.
  Future<Either<Failure, Stream<double>>> doInitialDownload();

  /// Gets state of the old user from shared preference data source saved
  /// while on authentication
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, bool>> get oldUserState;

  /// Gets google name of the user from shared preference data source saved
  /// while on authentication
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, String>> get userName;

  /// Adds a user activity to the cloud and to the native
  ///
  /// returns the [Either<Failure, int>] value of the assigned Id

  Future<Either<Failure, int>> add(UserAModel activity);

  /// Deletes a user activity from the cloud and from the native
  ///
  /// returns the [Either<Failure, bool>] if succeeded -> true else -> false

  Future<Either<Failure, bool>> delete(UserAModel activity);

  /// Deletes a user activity table from the cloud and from the native
  ///
  /// returns the [Either<Failure, bool>] if succeeded -> true else -> false

  Future<Either<Failure, void>> deleteUserActivityTable();

  /// Adds the User Details at cloud and at native
  ///
  /// returns [Either<Failure, bool>] true if succeeded
  Future<Either<Failure, bool>> addUser(UserDetail detail);

  /// Updates the User Details at cloud and at native
  ///
  /// returns [Either<Failure, bool>] true if succeeded
  Future<Either<Failure, bool>> update(UserDetail detail);

  /// Gets all activities from start data path cloud
  ///
  /// returns [Either<Failure, List<ActivityModel>>] true if succeeded
  Future<Either<Failure, List<ActivityModel>>> get cloudActivities;

  /// Gets all user activities from user path from cloud
  ///
  /// returns [Either<Failure, List<UserAModel>>] true if succeeded
  Future<Either<Failure, List<UserAModel>>> get userActivities;

  /// Gets user details from user path from cloud
  ///
  /// returns [Either<Failure, List<UserAModel>>] true if succeeded
  Future<Either<Failure, UserDetail>> get userDetails;

  /// Gets user details from user path from native
  ///
  /// returns [Either<Failure, List<UserAModel>>] true if succeeded
  Future<Either<Failure, UserDetail>> getUserDetailsNative();

  /// Gets user details from user path from native
  ///
  /// returns [Either<Failure, List<UserAModel>>] true if succeeded
  Future<Either<Failure, bool>> saveHealthProfile(
    
      HealthProfile lifestyleProfile,
     );

  /// Gets user details from user path from native
  ///
  /// returns [Either<Failure, List<UserAModel>>] true if succeeded
  Future<Either<Failure, bool>> saveUserInterests(
      List<UserTag> fitnessTags,
      List<UserTag> mindfulTags,
      List<UserTag> foodTags,
      List<UserTag> productivityTags,
      List<UserTag> relationshipTags,
      List<UserTag> careerTags,
      List<UserTag> financeTags);

  /// Gets user details from user path from native
  ///
  /// returns [Either<Failure, List<UserAModel>>] true if succeeded
  Future<Either<Failure, bool>> isUserNameAvailable(String username);

  Future<Either<Failure, List<UserTag>>> getFitnessTags();
  Future<Either<Failure, List<UserTag>>> getMentalHealthTags();
  Future<Either<Failure, List<UserTag>>> getFoodTags();
  Future<Either<Failure, List<UserTag>>> getFinanceTags();
  Future<Either<Failure, List<UserTag>>> getProductivityTags();
  Future<Either<Failure, List<UserTag>>> getCareerTags();
  Future<Either<Failure, List<UserTag>>> getFamilyTags();
  Future<Either<Failure, List<UserTag>>> getChildrenOfTag(
      UserTag tag, String category);
}
