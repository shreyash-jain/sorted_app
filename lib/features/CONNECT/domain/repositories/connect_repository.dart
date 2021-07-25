import 'package:dartz/dartz.dart';
import 'package:sorted/core/error/failures.dart';
import 'package:sorted/features/CONNECT/data/models/class_members.dart';
import 'package:sorted/features/CONNECT/data/models/client_enrolls_model.dart';
import 'package:sorted/features/CONNECT/data/models/expert_clients.dart';
import 'package:sorted/features/CONNECT/data/models/expert_profile.dart';
import 'package:sorted/features/CONNECT/data/models/instances/class_client_link.dart';
import 'package:sorted/features/CONNECT/data/models/instances/class_instance.dart';
import 'package:sorted/features/CONNECT/data/models/instances/client_instance.dart';
import 'package:sorted/features/HOME/data/models/class_model.dart';

abstract class ConnectRepository {
  Future<Either<Failure, ClassModel>> getClass(String id);
  Future<Either<Failure, ExpertProfileModel>> getExpertProfile(String id);
  Future<Either<Failure, ClientEnrollsModel>> getEnrollsOfClient();
  Future<Either<Failure, int>> enrollClass(ClassInstanceModel classroom,
      ClassClientLink link, String expertId, ClientInstance client);
}
