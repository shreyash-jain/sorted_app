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
import 'package:sorted/features/SETTINGS/data/models/settings_details.dart';

abstract class SettingsNative {
  Future<void> updateSettings(SettingsDetails inspirations);
  Future<SettingsDetails> getSettings();
}

class SettingsDataSourceImpl implements SettingsNative {
  final SqlDatabaseService nativeDb;

  SettingsDataSourceImpl({@required this.nativeDb});

  @override
  Future<SettingsDetails> updateSettings(SettingsDetails details) async {
    final db = await nativeDb.database;
    print("update settings native" + details.toString());
    List<Map<String, dynamic>> result = await db.query('SettingsDetails');
    if (result.length==0)await db.insert('SettingsDetails', details.toMap());

    await db.update('SettingsDetails', details.toMap());
  }

  @override
  Future<SettingsDetails> getSettings() async {
    final db = await nativeDb.database;
    List<Map<String, dynamic>> result;

    result = await db.query('SettingsDetails');

    List<SettingsDetails> details = result.isNotEmpty
        ? result.map((item) => SettingsDetails.fromMap(item)).toList()
        : [
            new SettingsDetails(
                unfilledSurveyPreference: false,
                currency: "₹",
                budget: 1000.0,
                reminderTime: DateTime(2020, 1, 1, 21, 00),
                theme: "dark",
                surveyTime: 20),
          ];
    return details[0];
  }
}
