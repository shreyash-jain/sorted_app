

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sorted/core/authentication/local_auth.dart';

import 'package:sorted/core/global/injection_container.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

import '../repositories/onstart_repository.dart';

class CancelLocalAuth implements UseCase<void, NoParams> {
  final OnStartRepository repository;

  CancelLocalAuth(this.repository);

  @override
  
  Future<Either<Failure, void>> call(NoParams params)  {
     
    
     
        sl<LocalAuthenticationService>().cancelAuthentication();
        return Future.value(Right(null));
    
    
  }
}

class Params extends Equatable {
  final int number;

  Params({@required this.number});

  @override
  List<Object> get props => [number];
}
