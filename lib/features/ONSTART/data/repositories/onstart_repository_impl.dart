import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:sorted/core/network/network_info.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/onstart_repository.dart';
import '../datasources/onstart_cloud_data_source.dart';
import '../datasources/onstart_shared_pref_data_source.dart';

class OnStartRepositoryImpl implements OnStartRepository {
  final OnStartCloud remoteDataSource;
  final OnStartSharedPref localDataSource;
  final NetworkInfo networkInfo;

  OnStartRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, bool>> getBiometricState() async {
    try {
      final remoteTrivia = await localDataSource.getBiometricState();

      return Right(remoteTrivia);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> getFirstTimeState() async {
    try {
      final remoteTrivia = await localDataSource.getOnBoardState();

      return Right(remoteTrivia);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Either<Failure, void> setBiometricState(bool state) {
    try {
      localDataSource.setBiometricState(state);
      return Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
