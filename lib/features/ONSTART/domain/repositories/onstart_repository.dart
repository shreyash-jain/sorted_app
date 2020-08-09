import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';


abstract class OnStartRepository {
  Future<Either<Failure, bool>> getBiometricState();
  Future<Either<Failure, bool>> getFirstTimeState();



  //Set to false if biometeric state is null ->
  Either<Failure, void> setBiometricState(bool state);
  
}