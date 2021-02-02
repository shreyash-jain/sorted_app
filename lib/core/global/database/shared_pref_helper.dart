import 'package:shared_preferences/shared_preferences.dart';
import 'package:sorted_younes/core/global/injection_container.dart';
import 'package:meta/meta.dart';

abstract class SharedPrefHelper {

  void setThemeinSharedPref(String val);
  Future<String> getThemeFromSharedPref();
 

}
const THEME_TAG = 'theme';

class SharedPrefHelperImpl implements SharedPrefHelper {
  final SharedPreferences sharedPreferences;

  SharedPrefHelperImpl({@required this.sharedPreferences});

 

@override
Future<String> getThemeFromSharedPref() async {
  
  return sl.get<SharedPreferences>().getString(THEME_TAG);
}
@override
void setThemeinSharedPref(String val) async {
  
  sl.get<SharedPreferences>().setString(THEME_TAG, val);
}



  
}



