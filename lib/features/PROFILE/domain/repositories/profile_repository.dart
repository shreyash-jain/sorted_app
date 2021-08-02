import 'package:dartz/dartz.dart';
import 'package:sorted/core/global/models/health_profile.dart';

import '../../../../core/error/failures.dart';

abstract class ProfileRepository {
  Future<Either<Failure, HealthProfile>> getFitnessProfileFromCloud();

  Future<Either<Failure, HealthProfile>> updateProfileFromCloud(HealthProfile profile);
}
