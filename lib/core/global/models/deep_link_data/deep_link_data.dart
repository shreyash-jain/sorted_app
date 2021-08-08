import 'package:sorted/features/CONNECT/data/models/package_model.dart';
import 'package:sorted/features/HOME/data/models/class_model.dart';

class DeepLinkType {
  final int type;
  final String link;
  DeepLinkType(this.type, this.link);
}

class ClassEnrollData {
  final String classId;
  final ClassModel classroom;
  ClassEnrollData(this.classId, this.classroom);
}

class ConsultationEnrollData {
  final String expertId;

  final List<ConsultationPackageModel> packages;

  ConsultationEnrollData(this.expertId, this.packages);
  
}

class PackageEnrollData {

  final String packageId;

  final ConsultationPackageModel package;

  PackageEnrollData(this.packageId, this.package);
}
