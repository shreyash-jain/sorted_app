import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:sorted/core/authentication/auth_native_data_source.dart';
import 'package:sorted/core/authentication/remote_auth_repository.dart';
import 'package:sorted/core/global/database/cacheDataClass.dart';

import 'package:sorted/core/global/database/shared_pref_helper.dart';
import 'package:sorted/core/global/database/sqflite_init.dart';
import 'package:sorted/features/ONBOARDING/presentation/bloc/onboarding_bloc.dart';

import 'package:sorted/features/ONSTART/data/datasources/onstart_cloud_data_source.dart';
import 'package:sorted/core/authentication/local_auth.dart';
import 'package:sorted/features/ONSTART/data/datasources/onstart_shared_pref_data_source.dart';
import 'package:sorted/features/ONSTART/data/repositories/onstart_repository_impl.dart';
import 'package:sorted/features/ONSTART/domain/repositories/onstart_repository.dart';
import 'package:sorted/features/ONSTART/domain/usecases/do_local_auth.dart';
import 'package:sorted/features/ONSTART/domain/usecases/cancel_local_auth.dart';
import 'package:sorted/features/ONSTART/presentation/bloc/onstart_bloc.dart';
import 'package:sorted/core/authentication/auth_cloud_data_source.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sorted/features/USER_INTRODUCTION/data/datasources/user_intro_cloud_data_source.dart';
import 'package:sorted/features/USER_INTRODUCTION/data/datasources/user_intro_native_data_source.dart';
import 'package:sorted/features/USER_INTRODUCTION/data/datasources/user_intro_shared_pref_data_source.dart';
import 'package:sorted/features/USER_INTRODUCTION/data/repositories/user_intro_repository_impl.dart';
import 'package:sorted/features/USER_INTRODUCTION/domain/repositories/user_intro_repository.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/flow_bloc/flow_bloc.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/interest_bloc/interest_bloc.dart';

import '../network/network_info.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  //! Features
  //! ONSTART
  //! Bloc

  ///* On Start Page Bloc
  sl.registerFactory(
    () => OnstartBloc(localAuth: sl(), cancelAuth: sl()),
  );

  ///* OnBoarding Page Bloc
  ///
  sl.registerFactory(
    () => OnboardingBloc(authRepo: sl()),
  );

  ///* User Intro Flow Page Bloc
  ///
  sl.registerFactory(
    () => UserIntroductionBloc(sl()),
  );

  ///* User Interest Flow Page Bloc
  ///
  sl.registerFactory(
    () => UserInterestBloc(repository: sl(), flowBloc: sl()),
  );

  //! Use cases

  sl.registerLazySingleton(() => DoLocalAuth(sl()));
  sl.registerLazySingleton(() => CancelLocalAuth(sl()));

  //! Repository

  sl.registerLazySingleton<OnStartRepository>(
    () => OnStartRepositoryImpl(
      localDataSource: sl(),
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );
  sl.registerLazySingleton(
      () => AuthenticationRepository(authDataSource: sl(), firebaseAuth: sl()));

  sl.registerLazySingleton<UserIntroductionRepository>(
    () => UserIntroRepositoryImpl(
      remoteAuth: sl(),
      nativeAuth: sl(),
      networkInfo: sl(),
      remoteDataSource: sl(),
      nativeDataSource: sl(),
      sharedPref: sl(),
    ),
  );
  //! Data sources
  sl.registerLazySingleton<OnStartCloud>(
    () => OnStartCloudDataSourceImpl(cloudDb: sl()),
  );
  sl.registerLazySingleton<AuthCloudDataSource>(
    () => AuthCloudDataSourceImpl(cloudDb: sl(), auth: sl(), prefs: sl()),
  );
  sl.registerLazySingleton<AuthNativeDataSource>(
    () => AuthNativeDataSourceImpl(nativeDb: sl()),
  );

  sl.registerLazySingleton<OnStartSharedPref>(
    () => OnStartSharedPrefDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<UserIntroCloud>(
    () =>
        UserIntroCloudDataSourceImpl(cloudDb: sl(), auth: sl(), nativeDb: sl()),
  );
  sl.registerLazySingleton<UserIntroNative>(
    () => UserIntroNativeDataSourceImpl(nativeDb: sl()),
  );
  sl.registerLazySingleton<UserIntroductionSharedPref>(
    () => UserSharedPrefDataSourceImpl(sharedPreferences: sl()),
  );

  //! Core
  //Global shared pref helper
  sl.registerLazySingleton<SharedPrefHelper>(
    () => SharedPrefHelperImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => LocalAuthenticationService());
  final CacheDataClass cacheData = CacheDataClass.cacheData;
  sl.registerLazySingleton(() => cacheData);
  final SqlDatabaseService sqlProvider = SqlDatabaseService.db;
  sl.registerLazySingleton(() => sqlProvider);

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _fireDB = Firestore.instance;
  final FirebaseDatabase fbDB = FirebaseDatabase.instance;

  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
  sl.registerLazySingleton(() => _auth);
  sl.registerLazySingleton(() => _fireDB);
  sl.registerLazySingleton(() => fbDB);
}
