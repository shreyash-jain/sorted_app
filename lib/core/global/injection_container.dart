import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:sorted/core/authentication/auth_native_data_source.dart';
import 'package:sorted/core/authentication/remote_auth_repository.dart';
import 'package:sorted/core/global/blocs/deeplink_bloc/deeplink_bloc.dart';
import 'package:sorted/core/global/database/cacheDataClass.dart';
import 'package:sorted/core/global/database/cache_deep_link.dart';
import 'package:sorted/core/global/database/datasources/attachments_sources/attachments_cloud_data_source.dart';
import 'package:sorted/core/global/database/datasources/attachments_sources/attachments_native_data_source.dart';

import 'package:sorted/core/global/database/shared_pref_helper.dart';
import 'package:sorted/core/global/database/sqflite_init.dart';
import 'package:sorted/core/routes/router.gr.dart';
import 'package:sorted/core/services/dynamic_link_service.dart';
import 'package:sorted/core/services/notifications/notification_remote_data_source.dart';
import 'package:sorted/core/services/notifications/notification_repository.dart';
import 'package:sorted/features/CONNECT/data/datasources/connect_cloud_data_source.dart';
import 'package:sorted/features/CONNECT/data/datasources/connect_remote_data_source.dart';
import 'package:sorted/features/CONNECT/data/repositories/connect_repository_impl.dart';
import 'package:sorted/features/CONNECT/domain/repositories/connect_repository.dart';

import 'package:sorted/features/HOME/data/datasources/home_cloud_data_source.dart';
import 'package:sorted/features/HOME/data/datasources/home_native_data_source.dart';
import 'package:sorted/features/HOME/data/datasources/home_remote_api_data_source.dart';
import 'package:sorted/features/HOME/data/datasources/home_shared_pref_data_source.dart';
import 'package:sorted/features/HOME/data/repositiries/home_repository_impl.dart';
import 'package:sorted/features/HOME/domain/repositories/home_repository.dart';
import 'package:sorted/features/HOME/presentation/bloc_affirmation/affirmation_bloc.dart';
import 'package:sorted/features/HOME/presentation/blogs_bloc/blogs_bloc.dart';
import 'package:sorted/features/HOME/presentation/home_stories_bloc/home_stories_bloc.dart';
import 'package:sorted/features/HOME/presentation/recipe_bloc/recipe_bloc.dart';
import 'package:sorted/features/HOME/presentation/transformation_bloc/transformation_bloc.dart';
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
import 'package:sorted/features/TRACKERS/PERMORMANCE/data/datasources/elastic_cloud_data_source.dart';
import 'package:sorted/features/TRACKERS/PERMORMANCE/data/datasources/performance_cloud_data_source.dart';
import 'package:sorted/features/TRACKERS/PERMORMANCE/data/repositories/performance_repository_impl.dart';
import 'package:sorted/features/TRACKERS/PERMORMANCE/domain/repositories/performance_repository.dart';

import 'package:sorted/features/USER_INTRODUCTION/data/datasources/user_intro_cloud_data_source.dart';
import 'package:sorted/features/USER_INTRODUCTION/data/datasources/user_intro_native_data_source.dart';
import 'package:sorted/features/USER_INTRODUCTION/data/datasources/user_intro_shared_pref_data_source.dart';
import 'package:sorted/features/USER_INTRODUCTION/data/repositories/user_intro_repository_impl.dart';
import 'package:sorted/features/USER_INTRODUCTION/domain/repositories/user_intro_repository.dart';
import 'package:sorted/features/USER_INTRODUCTION/presentation/flow_bloc/flow_bloc.dart';

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
    () => UserIntroductionBloc(sl(), sl()),
  );

  ///* Settings Flow Page Bloc
  ///
  sl.registerFactory(
    () => SettingsBloc(settingsRepository: sl(), onstartRepository: sl()),
  );
  //* Plan Page Bloc
  ///

  sl.registerFactory(
    () => ProfileBloc(sl(), sl(), sl()),
  );

  sl.registerFactory(
    () => AffirmationBloc(sl()),
  );

  sl.registerFactory(
    () => BlogBloc(sl()),
  );

  sl.registerFactory(
    () => RecipeBloc(sl()),
  );

  sl.registerFactory(
    () => TransformationBloc(sl()),
  );

  sl.registerLazySingleton(() => DeeplinkBloc());
  sl.registerLazySingleton(() => HomeStoriesBloc(sl()));

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
  sl.registerLazySingleton(() => AuthenticationRepository(
      authDataSource: sl(), firebaseAuth: sl(), networkInfo: sl()));

  sl.registerLazySingleton(() => NotificationRepository(
      notificationDataSource: sl(), firebaseAuth: sl(), networkInfo: sl()));

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

  sl.registerLazySingleton<PerformanceRepository>(
    () => PerformanceRepositoryImpl(
      elasticRemoteApi: sl(),
      networkInfo: sl(),
      remoteDataSource: sl(),
      nativeDataSource: sl(),
      nativeAuth: sl(),
      remoteAuth: sl(),
      sharedPref: sl(),
      cloudDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<ConnectRepository>(
    () => ConnectRepositoryImpl(
      networkInfo: sl(),
      remoteApiDataSource: sl(),
      remoteDataSource: sl(),
    ),
  );

  //! Data sources

  sl.registerLazySingleton<NotificationRemoteDataSource>(() =>
      NotificationCloudDataSourceImpl(dio: sl(), auth: sl(), cloudDb: sl()));
  sl.registerLazySingleton<ConnectCloud>(() =>
      ConnectCloudDataSourceImpl(cloudDb: sl(), auth: sl(), nativeDb: sl()));

  sl.registerLazySingleton<AttachmentsNative>(
      () => AttachmentNativeDataSourceImpl(nativeDb: sl()));
  sl.registerLazySingleton<AttachmentsCloud>(() =>
      AttachmentCloudDataSourceImpl(
          cloudDb: sl(), auth: sl(), nativeDb: sl(), cloudStorage: sl()));

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

  sl.registerLazySingleton<ElasticRemoteApi>(
      () => ElasticRemoteApiDataSourceImpl(sl()));

  sl.registerLazySingleton<PerformanceCloud>(
    () => PerformanceCloudDataSourceImpl(
        cloudDb: sl(), auth: sl(), nativeDb: sl()),
  );

  sl.registerLazySingleton<ProfileCloud>(() =>
      ProfileCloudDataSourceImpl(cloudDb: sl(), auth: sl(), nativeDb: sl()));
  sl.registerLazySingleton<ProfileNative>(
      () => ProfileNativeDataSourceImpl(nativeDb: sl()));

  sl.registerLazySingleton<ProfileSharedPref>(
      () => ProfileSharedPrefDataSourceImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<ConnectRemoteCloudDataSource>(
      () => ConnectRemoteDataSourceImpl(sl(), sl()));

  //! Core
  //Global shared pref helper
  sl.registerLazySingleton<SharedPrefHelper>(
    () => SharedPrefHelperImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => LocalAuthenticationService());
  final CacheDataClass cacheData = CacheDataClass.cacheData;
  final CacheDeepLinkDataClass deepLinkData = CacheDeepLinkDataClass.cacheData;
  sl.registerLazySingleton(() => cacheData);
  sl.registerLazySingleton(() => deepLinkData);
  final SqlDatabaseService sqlProvider = SqlDatabaseService.db;
  sl.registerLazySingleton(() => sqlProvider);

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireDB = FirebaseFirestore.instance;
  final Reference refStorage = FirebaseStorage.instance.ref();
  final _appRouter = ARouter();
  final dio = Dio();
  final FirebaseAnalytics analytics = FirebaseAnalytics();

  sl.registerLazySingleton(() => analytics);
  final FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: sl());

  sl.registerLazySingleton(() => _appRouter);

  sl.registerLazySingleton(() => observer);
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
  sl.registerLazySingleton(() => _auth);
  sl.registerLazySingleton(() => _fireDB);
  sl.registerLazySingleton(() => dio);
  sl.registerLazySingleton(() => DynamicLinkService());

  sl.registerLazySingleton(() => refStorage);
}
