import 'package:dartz/dartz.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/network/network_info.dart';
import 'package:sorted/features/CONNECT/data/datasources/connect_cloud_data_source.dart';
import 'package:sorted/features/CONNECT/data/models/class_members.dart';
import 'package:sorted/features/CONNECT/data/models/client_enrolls_model.dart';
import 'package:sorted/features/CONNECT/data/models/expert_clients.dart';
import 'package:sorted/features/CONNECT/data/models/expert_profile.dart';
import 'package:sorted/features/CONNECT/data/models/instances/client_instance.dart';
import 'package:sorted/features/CONNECT/data/models/instances/class_instance.dart';
import 'package:sorted/features/CONNECT/data/models/instances/class_client_link.dart';
import 'package:sorted/features/CONNECT/domain/repositories/connect_repository.dart';
import 'package:sorted/features/HOME/data/models/class_model.dart';

class ConnectRepositoryImpl implements ConnectRepository {
  final ConnectCloud remoteDataSource;

  final NetworkInfo networkInfo;

  ConnectRepositoryImpl({this.remoteDataSource, this.networkInfo});

  @override
  Future<Either<Failure, ClassModel>> getClass(String id) async {
    Failure failure;
    ClassModel classroom = ClassModel();
    if (await networkInfo.isConnected) {
      try {
        classroom = await remoteDataSource.getClass(id);
        return (Right(classroom));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, ExpertProfileModel>> getExpertProfile(
      String id) async {
    Failure failure;
    ExpertProfileModel classroom = ExpertProfileModel();

    if (await networkInfo.isConnected) {
      try {
        classroom = await remoteDataSource.getExpertProfile(id);
        return (Right(classroom));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, ClientEnrollsModel>> getEnrollsOfClient() async {
    Failure failure;
    ClientEnrollsModel model = ClientEnrollsModel();

    if (await networkInfo.isConnected) {
      try {
        model = await remoteDataSource.getEnrollsOfClient();
        return (Right(model));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, int>> enrollClass(ClassInstanceModel classroom,
      ClassClientLink link, String expertId, ClientInstance client) async {
    Failure failure;
    int result;

    if (await networkInfo.isConnected) {
      try {
        result = await remoteDataSource.enrollClass(
            classroom, link, expertId, client);
        return (Right(result));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }
}
