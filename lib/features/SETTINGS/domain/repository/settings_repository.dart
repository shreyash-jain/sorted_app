import 'package:dartz/dartz.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/global/models/user_details.dart';

import 'package:sorted/features/PROFILE/data/models/activity.dart';
import 'package:sorted/features/PROFILE/data/models/user_activity.dart';
import 'package:sorted/features/SETTINGS/data/models/settings_details.dart';


abstract class SettingsRepository {

  /// Gets the affirmations from cloud and favourates and also adds to local 
  /// 
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, SettingsDetails>> get settingsDetail;





  /// Gets the thumbnail details and convert them in urls.
  ///
  /// returns [Either<Failure, bool>] the state of user
  Future<Either<Failure, void>> updateSettingsDetails(SettingsDetails details);

 

}
