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
