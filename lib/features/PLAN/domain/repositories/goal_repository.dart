import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/models/image.dart';
import 'package:sorted/core/global/models/log.dart';
import 'package:sorted/features/HOME/domain/entities/unsplash_image.dart';

import 'package:sorted/features/PLAN/data/models/goal.dart';
import 'package:sorted/features/PLAN/data/models/task_status.dart';

abstract class GoalRepository {

  /// Gets the affirmations from cloud and favourates and also adds to local 
  /// 
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, List<GoalModel>>> getGoals();

 

  /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, GoalModel>> addGoal(GoalModel goal);

  

   /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, GoalModel>> updateGoal(GoalModel goal);

    /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, List<UnsplashImage>>> getSearchImages(String search);

 /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, ImageModel>> storeImage(ImageModel image,File file);
 

  /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, void>> removeGoal(GoalModel goal);

   /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, List<String>>> getGradientUrls();
  
   /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, List<String>>> getWorkUrls();
  
   /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, List<String>>> getInspireUrls();
  
   /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, List<String>>> getStudyUrls();


  
  

  

}
