

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sorted/core/authentication/local_auth.dart';

import 'package:sorted/core/global/injection_container.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

import '../repositories/onstart_repository.dart';

class DoLocalAuth implements UseCase<void, NoParams> {
  final OnStartRepository repository;

  DoLocalAuth(this.repository);

  @override
  
  Future<Either<Failure, bool>> call(NoParams params) async {
     Either<Failure, bool> result=Right(false);
   
      Either<Failure, bool> biometricState =
          await repository.getBiometricState();
      
      await biometricState.fold((l) async {
            result = Left(l);
          }, (r) async {
            result =  Right(await sl<LocalAuthenticationService>().authenticate(r));
          });
      
   
    return result;
  }
}

class Params extends Equatable {
  final int number;

  Params({@required this.number});

  @override
  List<Object> get props => [number];
}
