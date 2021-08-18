import 'package:dartz/dartz.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/core/network/network_info.dart';
import 'package:sorted/features/CONNECT/data/datasources/connect_cloud_data_source.dart';
import 'package:sorted/features/CONNECT/data/datasources/connect_remote_data_source.dart';
import 'package:sorted/features/CONNECT/data/models/chat_message.dart';
import 'package:sorted/features/CONNECT/data/models/class_members.dart';
import 'package:sorted/features/CONNECT/data/models/client_consultation_model.dart';
import 'package:sorted/features/CONNECT/data/models/client_enrolls_model.dart';
import 'package:sorted/features/CONNECT/data/models/expert/expert_calendar.dart';
import 'package:sorted/features/CONNECT/data/models/expert/expert_clients.dart';
import 'package:sorted/features/CONNECT/data/models/expert/expert_profile.dart';
import 'package:sorted/features/CONNECT/data/models/instances/client_instance.dart';
import 'package:sorted/features/CONNECT/data/models/instances/class_instance.dart';
import 'package:sorted/features/CONNECT/data/models/instances/class_client_link.dart';
import 'package:sorted/features/CONNECT/data/models/noticeboard_message.dart';
import 'package:sorted/features/CONNECT/data/models/package_model.dart';
import 'package:sorted/features/CONNECT/data/models/instances/consultation_trainer_instance.dart';
import 'package:sorted/features/CONNECT/data/models/instances/consultation_client_instance.dart';
import 'package:sorted/features/CONNECT/domain/entities/chat_message_entity.dart';
import 'package:sorted/features/CONNECT/data/models/resource_message.dart';
import 'package:sorted/features/CONNECT/domain/repositories/connect_repository.dart';
import 'package:sorted/features/HOME/data/models/class_model.dart';
import 'package:sorted/features/PLANNER/data/models/activity.dart';
import 'package:sorted/features/PLANNER/data/models/workout_plan.dart';
import 'package:sorted/features/PLANNER/data/models/diet_plan.dart';

class ConnectRepositoryImpl implements ConnectRepository {
  final ConnectCloud remoteDataSource;
  final ConnectRemoteCloudDataSource remoteApiDataSource;

  final NetworkInfo networkInfo;

  ConnectRepositoryImpl(
      {this.remoteApiDataSource, this.remoteDataSource, this.networkInfo});

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

  @override
  Future<Either<Failure, int>> enrollPackage(
      ClientConsultationModel consultation,
      ConsultationClientInstanceModel clientLink,
      ConsultationTrainerInstanceModel expertLink) async {
    if (await networkInfo.isConnected) {
      try {
        var result = await remoteDataSource.enrollPackage(
            consultation, clientLink, expertLink);
        return (Right(result));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, ExpertCalendarModel>> getExpertCalendar(
      String id) async {
    if (await networkInfo.isConnected) {
      try {
        var result = await remoteDataSource.getExpertCalendar(id);
        return (Right(result));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, List<ConsultationPackageModel>>> getExpertPackages(
      String expertId) async {
    if (await networkInfo.isConnected) {
      try {
        var result = await remoteDataSource.getExpertPackages(expertId);
        return (Right(result));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, ConsultationPackageModel>> getPackage(
      String id) async {
    if (await networkInfo.isConnected) {
      try {
        var result = await remoteDataSource.getPackage(id);
        return (Right(result));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, ChatMessageEntitiy>> addChatMessage(
      ChatMessage message, ClassModel classroom) async {
    if (await networkInfo.isConnected) {
      try {
        var result = await remoteDataSource.addChatMessage(message, classroom);
        return (Right(result));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, ChatMessageEntitiy>> addConsultationChatMessage(
      ChatMessage message, ClientConsultationModel client) async {
    if (await networkInfo.isConnected) {
      try {
        var result =
            await remoteDataSource.addConsultationChatMessage(message, client);
        return (Right(result));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, List<ChatMessageEntitiy>>> getChatMessages(
      ClassModel classroom, ChatMessage startAfterChat, int limit) async {
    if (await networkInfo.isConnected) {
      try {
        var result = await remoteDataSource.getChatMessages(
            classroom, startAfterChat, limit);
        return (Right(result));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, List<DietPlanModel>>> getClassDietPlans(
      ClassModel classroom) async {
    if (await networkInfo.isConnected) {
      try {
        var result = await remoteDataSource.getClassDietPlans(classroom);
        return (Right(result));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, List<ResourceMessage>>> getClassResourceMessages(
      ClassModel classroom) async {
    if (await networkInfo.isConnected) {
      try {
        var result = await remoteDataSource.getResourceMessages(classroom);
        return (Right(result));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, List<WorkoutPlanModel>>> getClassWorkoutPlans(
      ClassModel classroom) async {
    if (await networkInfo.isConnected) {
      try {
        var result = await remoteDataSource.getClasWorkoutPlans(classroom);
        return (Right(result));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, ClientConsultationModel>> getConsultationById(
      String id) async {
    if (await networkInfo.isConnected) {
      try {
        var result = await remoteDataSource.getConsultationById(id);
        return (Right(result));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, List<ChatMessageEntitiy>>> getConsultationChatMessages(
      ClientConsultationModel client,
      ChatMessage startAfterChat,
      int limit) async {
    if (await networkInfo.isConnected) {
      try {
        var result = await remoteDataSource.getConsultationChatMessages(
            client, startAfterChat, limit);
        return (Right(result));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, List<DietPlanModel>>> getConsultationDietPlans(
      ClientConsultationModel consultation) async {
    if (await networkInfo.isConnected) {
      try {
        var result =
            await remoteDataSource.getConsultationDietPlans(consultation);
        return (Right(result));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, List<WorkoutPlanModel>>> getConsultationWorkoutPlans(
      ClientConsultationModel consultation) async {
    if (await networkInfo.isConnected) {
      try {
        var result =
            await remoteDataSource.getConsultationWorkoutPlans(consultation);
        return (Right(result));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, List<NoticeboardMessage>>> getNoticeBoardMessages(
      ClassModel classroom) async {
    if (await networkInfo.isConnected) {
      try {
        var result = await remoteDataSource.getNoticeBoardMessages(classroom);
        return (Right(result));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, ActivityModel>> getActivityById(int activityId) async {
    if (await networkInfo.isConnected) {
      try {
        ActivityModel activity =
            await remoteDataSource.getActivityById(activityId);

        return (Right(activity));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, int>> leaveClassClient(
      String trainerId, String clientId, String classroomId) async {
    if (await networkInfo.isConnected) {
      try {
        return (await remoteApiDataSource.leaveClassClient(
            trainerId, clientId, classroomId));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, List<ResourceMessage>>>
      getConsultationResourceMessages(
          ClientConsultationModel consultation) async {
    if (await networkInfo.isConnected) {
      try {
        var result = await remoteDataSource
            .getConsultationResourceMessages(consultation);
        return (Right(result));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, int>> leaveConsultationClient(
      String trainerId, String clientId, String consultationId) async {
    if (await networkInfo.isConnected) {
      try {
        return (await remoteApiDataSource.leaveConsultationClient(
            trainerId, clientId, consultationId));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, int>> notifyExpertforNewClass(String trainerId) async {
    if (await networkInfo.isConnected) {
      try {
        return (await remoteApiDataSource.notifyExpertforNewClass(trainerId));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, int>> notifyExpertforNewConsultation(
      String trainerId) async {
    if (await networkInfo.isConnected) {
      try {
        return (await remoteApiDataSource
            .notifyExpertforNewConsultation(trainerId));
      } on Exception {
        return Left(ServerFailure());
      }
    } else
      return Left(NetworkFailure());
  }
}
