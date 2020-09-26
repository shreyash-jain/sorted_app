import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sorted/core/error/exceptions.dart';

abstract class AnalysisPref {
 
}



class AnalysisSharedPrefDataSourceImpl implements AnalysisPref {
  final SharedPreferences sharedPreferences;

  AnalysisSharedPrefDataSourceImpl({@required this.sharedPreferences});

  

 
}
