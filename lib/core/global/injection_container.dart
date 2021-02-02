
import 'package:data_connection_checker/data_connection_checker.dart';


import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


final GetIt sl = GetIt.instance;

Future<void> init() async {
  //! Features
  //! ONSTART
  //! Bloc

 

  //! Use cases

 

  //! Repository

 
  
  //! Data sources
 
  //! Core
  //Global shared pref helper
  
 
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();


  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());

}
