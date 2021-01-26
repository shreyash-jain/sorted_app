import 'dart:math';

import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:sorted/core/global/constants/constants.dart';
import 'package:sorted/core/global/database/sqflite_init.dart';
import 'package:sorted/features/HOME/data/models/affirmation.dart';
import 'package:sorted/features/HOME/data/models/inspiration.dart';
import 'package:sorted/features/HOME/domain/entities/day_affirmations.dart';
import 'package:sorted/features/HOME/data/models/placeholder_info.dart';
import 'package:sorted/features/HOME/domain/entities/unsplash_image.dart';

abstract class ProfileNative {}

class ProfileNativeDataSourceImpl implements ProfileNative {
  final SqlDatabaseService nativeDb;

  ProfileNativeDataSourceImpl({@required this.nativeDb});
}
