import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:sorted/core/authentication/auth_native_data_source.dart';
import 'package:sorted/core/authentication/remote_auth_repository.dart';
import 'package:sorted/core/global/database/cacheDataClass.dart';
import 'package:sorted/core/global/database/datasources/attachments_sources/attachments_cloud_data_source.dart';
import 'package:sorted/core/global/database/datasources/attachments_sources/attachments_native_data_source.dart';

import 'package:sorted/core/global/database/shared_pref_helper.dart';
import 'package:sorted/core/global/database/sqflite_init.dart';
import 'package:sorted/features/FILES/data/datasources/note_sources/note_cloud_data_source.dart';
import 'package:sorted/features/FILES/data/datasources/note_sources/note_native_data_source.dart';
import 'package:sorted/features/FILES/data/datasources/note_sources/note_shared_pref_data_source.dart';
import 'package:sorted/features/FILES/data/repositories/note_repository_impl.dart';
import 'package:sorted/features/FILES/domain/repositories/note_repository.dart';
import 'package:sorted/features/FILES/presentation/note_bloc/note_bloc.dart';
import 'package:sorted/features/HOME/data/datasources/home_cloud_data_source.dart';
import 'package:sorted/features/HOME/data/datasources/home_native_data_source.dart';
import 'package:sorted/features/HOME/data/datasources/home_remote_api_data_source.dart';
import 'package:sorted/features/HOME/data/datasources/home_shared_pref_data_source.dart';
import 'package:sorted/features/HOME/data/repositiries/home_repository_impl.dart';
import 'package:sorted/features/HOME/domain/repositories/home_repository.dart';
import 'package:sorted/features/HOME/presentation/bloc_affirmation/affirmation_bloc.dart';
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
import 'package:sorted/features/PLAN/data/datasources/goal_sources/goal_cloud_data_source.dart';
import 'package:sorted/features/PLAN/data/datasources/goal_sources/goal_native_data_source.dart';
import 'package:sorted/features/PLAN/data/datasources/goal_sources/goal_shared_pref_data_source.dart';
import 'package:sorted/features/PLAN/data/datasources/task_sources/task_cloud_data_source.dart';
import 'package:sorted/features/PLAN/data/datasources/task_sources/task_native_data_source.dart';
import 'package:sorted/features/PLAN/data/datasources/task_sources/task_shared_pref_data_source.dart';
import 'package:sorted/features/PLAN/data/datasources/todo_sources/todo_cloud_data_source.dart';
import 'package:sorted/features/PLAN/data/datasources/todo_sources/todo_native_data_source.dart';
import 'package:sorted/features/PLAN/data/datasources/todo_sources/todo_shared_pref_data_source.dart';
import 'package:sorted/features/PLAN/data/repositories/goal_repository_impl.dart';
import 'package:sorted/features/PLAN/data/repositories/task_repository_impl.dart';
import 'package:sorted/features/PLAN/data/repositories/todo_repository_impl.dart';
import 'package:sorted/features/PLAN/domain/repositories/goal_repository.dart';
import 'package:sorted/features/PLAN/domain/repositories/task_repository.dart';
import 'package:sorted/features/PLAN/domain/repositories/todo_repository.dart';
import 'package:sorted/features/PLAN/presentation/bloc/cover_change_bloc/cover_bloc.dart';
import 'package:sorted/features/PLAN/presentation/bloc/goal_page_bloc/goal_page_bloc.dart';
import 'package:sorted/features/PLAN/presentation/bloc/plan_bloc/plan_bloc.dart';
import 'package:sorted/features/PROFILE/data/datasources/profile_cloud_data_source.dart';
import 'package:sorted/features/PROFILE/data/datasources/profile_native_data_source.dart';
import 'package:sorted/features/PROFILE/data/datasources/profile_shared_pref_data_source.dart';
import 'package:sorted/features/PROFILE/data/repositories/profile_repository_impl.dart';
import 'package:sorted/features/PROFILE/domain/repositories/profile_repository.dart';
import 'package:sorted/features/PROFILE/presentation/bloc/profile_bloc.dart';
import 'package:sorted/features/SETTINGS/data/datasources/settings_cloud_data_source.dart';
import 'package:sorted/features/SETTINGS/data/datasources/settings_native_data_source.dart';
import 'package:sorted/features/SETTINGS/data/datasources/settings_shared_pref_data_source.dart';
import 'package:sorted/features/SETTINGS/data/repository/settings_repository_impl.dart';
import 'package:sorted/features/SETTINGS/domain/repository/settings_repository.dart';
import 'package:sorted/features/SETTINGS/presentation/bloc/settings_bloc.dart';
import 'package:sorted/features/USER_INTRODUCTION/data/datasources/user_intro_cloud_data_source.dart';
import 'package:sorted/features/USER_INTRODUCTION/data/datasources/user_intro_native_data_source.dart';
import 'package:sorted/features/USER_INTRODUCTION/data/datasources/user_intro_shared_pref_data_source.dart';
import 'package:sorted/features/USER_INTRODUCTION/data/repositories/user_intro_repository_impl.dart';
import 'package:sorted/features/USER_INTRODUCTION/domain/repositories/user_intro_repository.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/flow_bloc/flow_bloc.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/interest_bloc/interest_bloc.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/data/datasources/track_store_cloud_data_source.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/data/datasources/track_store_native_data_source.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/data/datasources/track_store_shared_pref_data_source.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/data/repositories/track_store_repository_impl.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/domain/repositories/track_store_repository.dart';
import 'package:sorted/features/TRACKERS/TRACK_STORE/presentation/bloc/track_store_bloc.dart';
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

  ///* Settings Flow Page Bloc
  ///
  sl.registerFactory(
    () => SettingsBloc(settingsRepository: sl(), onstartRepository: sl()),
  );
  //* Plan Page Bloc
  ///
  sl.registerFactory(
    () => PlanBloc(sl(), sl()),
  );
  //* Goal Page Bloc
  ///
  sl.registerFactory(
    () => GoalPageBloc(sl(), sl(), sl()),
  );
  //* Cover select Bloc
  ///
  sl.registerFactory(
    () => CoverBloc(sl(), sl()),
  );

  sl.registerFactory(
    () => NoteBloc(sl(), sl()),
  );

  sl.registerFactory(
    () => ProfileBloc(sl()),
  );

  sl.registerFactory(
    () => AffirmationBloc(sl()),
  );

  sl.registerFactory(
    () => TrackStoreBloc(sl()),
  );

  //! Use cases

  sl.registerLazySingleton(() => DoLocalAuth(sl()));
  sl.registerLazySingleton(() => CancelLocalAuth(sl()));

  //! Repository

  sl.registerLazySingleton<NoteRepository>(
    () => NoteRepositoryImpl(
      remoteNoteDataSource: sl(),
      nativeNoteDataSource: sl(),
      nativeAttachmentDataSource: sl(),
      networkInfo: sl(),
      sharedPrefNote: sl(),
      remoteAttachmentDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(
      networkInfo: sl(),
      nativeTodoDataSource: sl(),
      remoteTodoDataSource: sl(),
      sharedPrefTodo: sl(),
    ),
  );

  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(
      remoteTaskDataSource: sl(),
      remoteGoalDataSource: sl(),
      nativeTaskDataSource: sl(),
      nativeGoalDataSource: sl(),
      nativeAttachmentDataSource: sl(),
      networkInfo: sl(),
      sharedPrefTask: sl(),
      remoteAttachmentDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<GoalRepository>(
    () => GoalRepositoryImpl(
      remoteTaskDataSource: sl(),
      remoteGoalDataSource: sl(),
      nativeTaskDataSource: sl(),
      nativeGoalDataSource: sl(),
      nativeAttachmentDataSource: sl(),
      networkInfo: sl(),
      sharedPrefGoal: sl(),
      remoteAttachmentDataSource: sl(),
    ),
  );

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
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      networkInfo: sl(),
      remoteDataSource: sl(),
      nativeDataSource: sl(),
      sharedPref: sl(),
      remoteApi: sl(),
    ),
  );

  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(
      networkInfo: sl(),
      remoteDataSource: sl(),
      nativeDataSource: sl(),
      sharedPref: sl(),
    ),
  );

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      networkInfo: sl(),
      remoteDataSource: sl(),
      nativeDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<TrackStoreRepository>(
    () => TrackStoreRepositoryImpl(
      networkInfo: sl(),
      remoteDataSource: sl(),
      nativeDataSource: sl(),
      nativeAuth: sl(),
      remoteAuth: sl(),
      sharedPref: sl(),
      cloudDataSource: sl(),
    ),
  );
  //! Data sources
  sl.registerLazySingleton<GoalNative>(
      () => GoalNativeDataSourceImpl(nativeDb: sl()));
  sl.registerLazySingleton<NoteNative>(
      () => NoteNativeDataSourceImpl(nativeDb: sl()));
  sl.registerLazySingleton<TaskNative>(
      () => TaskNativeDataSourceImpl(nativeDb: sl()));
  sl.registerLazySingleton<ProfileNative>(
      () => ProfileNativeDataSourceImpl(nativeDb: sl()));
  sl.registerLazySingleton<TodoNative>(
      () => TodoNativeDataSourceImpl(nativeDb: sl()));
  sl.registerLazySingleton<AttachmentsNative>(
      () => AttachmentNativeDataSourceImpl(nativeDb: sl()));
  sl.registerLazySingleton<AttachmentsCloud>(() =>
      AttachmentCloudDataSourceImpl(
          cloudDb: sl(), auth: sl(), nativeDb: sl(), cloudStorage: sl()));

  sl.registerLazySingleton<GoalSharedPref>(
      () => GoalSharedPrefDataSourceImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<ProfileSharedPref>(
      () => ProfileSharedPrefDataSourceImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<TaskSharedPref>(
      () => TaskSharedPrefDataSourceImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<NoteSharedPref>(
      () => NoteSharedPrefDataSourceImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<TodoSharedPref>(
      () => TodoSharedPrefDataSourceImpl(sharedPreferences: sl()));

  sl.registerLazySingleton<GoalCloud>(
      () => GoalCloudDataSourceImpl(cloudDb: sl(), auth: sl(), nativeDb: sl()));
  sl.registerLazySingleton<NoteCloud>(
      () => NoteCloudDataSourceImpl(cloudDb: sl(), auth: sl(), nativeDb: sl()));
  sl.registerLazySingleton<ProfileCloud>(() =>
      ProfileCloudDataSourceImpl(cloudDb: sl(), auth: sl(), nativeDb: sl()));

  sl.registerLazySingleton<TaskCloud>(
      () => TaskCloudDataSourceImpl(cloudDb: sl(), auth: sl(), nativeDb: sl()));
  sl.registerLazySingleton<TodoCloud>(
      () => TodoCloudDataSourceImpl(cloudDb: sl(), auth: sl(), nativeDb: sl()));
  sl.registerLazySingleton<HomeCloud>(
      () => HomeCloudDataSourceImpl(cloudDb: sl(), auth: sl(), nativeDb: sl()));

  sl.registerLazySingleton<SettingsNative>(
      () => SettingsDataSourceImpl(nativeDb: sl()));

  sl.registerLazySingleton<SettingsSharedPref>(
      () => SettingsPrefDataSourceImpl(sharedPreferences: sl()));

  sl.registerLazySingleton<SettingsCloud>(() =>
      SettingsCloudDataSourceImpl(cloudDb: sl(), auth: sl(), nativeDb: sl()));
  sl.registerLazySingleton<HomeNative>(
      () => HomeNativeDataSourceImpl(nativeDb: sl()));
  sl.registerLazySingleton<HomeSharedPref>(
      () => HomeSharedPrefDataSourceImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<HomeRemoteApi>(() => HomeRemoteApiDataSourceImpl());
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

  sl.registerLazySingleton<TrackStoreCloud>(
    () => TrackStoreCloudDataSourceImpl(
        cloudDb: sl(), auth: sl(), nativeDb: sl()),
  );
  sl.registerLazySingleton<TrackStoreNative>(
    () => TrackStoreNativeDataSourceImpl(nativeDb: sl()),
  );
  sl.registerLazySingleton<TrackStoreSharedPref>(
    () => TrackStoreSharedPrefDataSourceImpl(sharedPreferences: sl()),
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
  final FirebaseFirestore _fireDB = FirebaseFirestore.instance;
  final Reference refStorage = FirebaseStorage.instance.ref();

  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
  sl.registerLazySingleton(() => _auth);
  sl.registerLazySingleton(() => _fireDB);

  sl.registerLazySingleton(() => refStorage);
}
