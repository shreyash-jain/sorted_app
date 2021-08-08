import 'package:dartz/dartz.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/features/CONNECT/data/models/chat_message.dart';
import 'package:sorted/features/CONNECT/data/models/class_members.dart';
import 'package:sorted/features/CONNECT/data/models/client_consultation_model.dart';
import 'package:sorted/features/CONNECT/data/models/client_enrolls_model.dart';
import 'package:sorted/features/CONNECT/data/models/expert/expert_calendar.dart';
import 'package:sorted/features/CONNECT/data/models/expert/expert_clients.dart';
import 'package:sorted/features/CONNECT/data/models/expert/expert_profile.dart';
import 'package:sorted/features/CONNECT/data/models/instances/class_client_link.dart';
import 'package:sorted/features/CONNECT/data/models/instances/class_instance.dart';
import 'package:sorted/features/CONNECT/data/models/instances/client_instance.dart';
import 'package:sorted/features/CONNECT/data/models/instances/consultation_client_instance.dart';
import 'package:sorted/features/CONNECT/data/models/instances/consultation_trainer_instance.dart';
import 'package:sorted/features/CONNECT/data/models/noticeboard_message.dart';
import 'package:sorted/features/CONNECT/data/models/package_model.dart';
import 'package:sorted/features/CONNECT/data/models/resource_message.dart';
import 'package:sorted/features/CONNECT/domain/entities/chat_message_entity.dart';
import 'package:sorted/features/HOME/data/models/class_model.dart';
import 'package:sorted/features/PLANNER/data/models/activity.dart';
import 'package:sorted/features/PLANNER/data/models/diet_plan.dart';
import 'package:sorted/features/PLANNER/data/models/workout_plan.dart';

abstract class ConnectRepository {
  Future<Either<Failure, ClassModel>> getClass(String id);
  Future<Either<Failure, ExpertProfileModel>> getExpertProfile(String id);
  Future<Either<Failure, ClientEnrollsModel>> getEnrollsOfClient();
  Future<Either<Failure, int>> enrollClass(ClassInstanceModel classroom,
      ClassClientLink link, String expertId, ClientInstance client);
  Future<Either<Failure, List<ConsultationPackageModel>>> getExpertPackages(
      String expertId);
  Future<Either<Failure, ConsultationPackageModel>> getPackage(String id);
  Future<Either<Failure, int>> enrollPackage(
      ClientConsultationModel consultation,
      ConsultationClientInstanceModel clientLink,
      ConsultationTrainerInstanceModel expertLink);
  Future<Either<Failure, ExpertCalendarModel>> getExpertCalendar(String id);
  Future<Either<Failure, ChatMessageEntitiy>> addChatMessage(
      ChatMessage message, ClassModel classroom);

  Future<Either<Failure, List<ChatMessageEntitiy>>> getChatMessages(
      ClassModel classroom, ChatMessage startAfterChat, int limit);

  Future<Either<Failure, List<DietPlanModel>>> getConsultationDietPlans(
      ClientConsultationModel consultation);
  Future<Either<Failure, List<WorkoutPlanModel>>> getConsultationWorkoutPlans(
      ClientConsultationModel consultation);
  Future<Either<Failure, ClientConsultationModel>> getConsultationById(
      String id);
  Future<Either<Failure, List<NoticeboardMessage>>> getNoticeBoardMessages(
      ClassModel classroom);

  Future<Either<Failure, List<ResourceMessage>>> getClassResourceMessages(
      ClassModel classroom);

  Future<Either<Failure, ChatMessageEntitiy>> addConsultationChatMessage(
      ChatMessage message, ClientConsultationModel client);

  Future<Either<Failure, List<ChatMessageEntitiy>>> getConsultationChatMessages(
      ClientConsultationModel client, ChatMessage startAfterChat, int limit);
  Future<Either<Failure, List<DietPlanModel>>> getClassDietPlans(
      ClassModel classroom);
  Future<Either<Failure, List<WorkoutPlanModel>>> getClassWorkoutPlans(
      ClassModel classroom);

  Future<Either<Failure, ActivityModel>> getActivityById(int activityId);
}
