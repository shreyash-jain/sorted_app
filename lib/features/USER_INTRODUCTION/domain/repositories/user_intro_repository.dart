import 'package:dartz/dartz.dart';

import 'package:sorted/core/global/models/health_profile.dart';

import 'package:sorted/core/global/models/user_details.dart';


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
  Future<Either<Failure, bool>> isUserNameAvailable(String username);


  Future<Either<Failure, HealthProfile>>  getHealthProfile(); 


}
