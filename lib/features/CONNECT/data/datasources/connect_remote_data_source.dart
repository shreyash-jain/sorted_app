import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sorted/core/error/failures.dart';

abstract class ConnectRemoteCloudDataSource {
  Future<Either<Failure, int>> leaveClassClient(
      String trainerId, String clientId, String classroomId);
  Future<Either<Failure, int>> leaveConsultationClient(
      String trainerId, String clientId, String consultationId);
  Future<Either<Failure, int>> notifyExpertforNewClass(String trainerId);
  Future<Either<Failure, int>> notifyExpertforNewConsultation(String trainerId);
}

class ConnectRemoteDataSourceImpl implements ConnectRemoteCloudDataSource {
  final Dio dio;
  final FirebaseAuth auth;

  String removeClientFromClassEndpoint =
      "https://us-central1-sorted-98c02.cloudfunctions.net/serverutility/removeClientFromClass";
  String removeClientFromConsultationEndpoint =
      "https://us-central1-sorted-98c02.cloudfunctions.net/serverutility/removeClientFromConsultation";
  String notifyExpertforNewClassEndpoint =
      "https://us-central1-sorted-98c02.cloudfunctions.net/serverutility/notifyExpertforNewClass";
  String notifyExpertforNewConsultationEndpoint =
      "https://us-central1-sorted-98c02.cloudfunctions.net/serverutility/notifyExpertforNewConsultation";

  ConnectRemoteDataSourceImpl(this.dio, this.auth);

  @override
  Future<Either<Failure, int>> leaveClassClient(
      String trainerId, String clientId, String classroomId) async {
    try {
      var token = await auth.currentUser.getIdToken();

      dio.options.headers["Authorization"] = "Bearer $token";

      var response = await dio.get(
        removeClientFromClassEndpoint,
        queryParameters: {
          "trainerId": trainerId,
          "clientId": clientId,
          "classroomId": classroomId
        },
      );

      return (Right(1));
    } on DioError catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, int>> leaveConsultationClient(
      String trainerId, String clientId, String consultationId) async {
    try {
      var token = await auth.currentUser.getIdToken();

      dio.options.headers["Authorization"] = "Bearer $token";

      var response = await dio.get(
        removeClientFromConsultationEndpoint,
        queryParameters: {
          "trainerId": trainerId,
          "clientId": clientId,
          "consultationId": consultationId
        },
      );

      return (Right(1));
    } on DioError catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, int>> notifyExpertforNewClass(String trainerId) async {
    try {
      var token = await auth.currentUser.getIdToken();

      dio.options.headers["Authorization"] = "Bearer $token";

      var response = await dio.get(
        notifyExpertforNewClassEndpoint,
        queryParameters: {
          "expertId": trainerId,
        },
      );

      return (Right(1));
    } on DioError catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, int>> notifyExpertforNewConsultation(
      String trainerId) async {
    try {
      var token = await auth.currentUser.getIdToken();

      dio.options.headers["Authorization"] = "Bearer $token";

      var response = await dio.get(
        notifyExpertforNewConsultationEndpoint,
        queryParameters: {
          "expertId": trainerId,
        },
      );

      return (Right(1));
    } on DioError catch (e) {
      return Left(ServerFailure());
    }
  }
}
