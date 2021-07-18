import 'package:dartz/dartz.dart';
import 'package:sorted/core/global/models/lifestyle_profile.dart';
import 'package:sorted/core/global/models/physical_health_profile.dart';
import 'package:sorted/core/global/models/mental_health_profile.dart';
import 'package:sorted/features/PROFILE/data/models/profile.dart';
import '../../../../core/error/failures.dart';

abstract class ProfileRepository {
  Future<Either<Failure, PhysicalHealthProfile>> getFitnessProfileFromCloud();
  Future<Either<Failure, MentalHealthProfile>> getMindfulProfileFromCloud();
  Future<Either<Failure, LifestyleProfile>> getLifestyleFromCloud();
  Future<Either<Failure, ProfileModel>> getProfileFromCloud();
  Future<Either<Failure, ProfileModel>> updateProfileFromCloud(ProfileModel profile);
}