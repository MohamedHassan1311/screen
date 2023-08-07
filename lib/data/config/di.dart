import 'package:dio/dio.dart';

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/localization/provider/language_provider.dart';
import '../../app/localization/provider/localization_provider.dart';
import '../../app/theme/theme_provider/theme_provider.dart';
import '../../features/auth/select_branch_screen/provider/auth_provider.dart';
import '../../features/auth/select_branch_screen/repo/auth_repo.dart';

import '../../features/dashBoard/provider/files_provider.dart';
import '../../features/dashBoard/repo/fiels_repo.dart';
import '../../main_providers/calender_provider.dart';
import '../api/end_points.dart';
import '../network/netwok_info.dart';
import '../dio/dio_client.dart';
import '../dio/logging_interceptor.dart';

import '../../features/splash/provider/splash_provider.dart';
import '../../features/splash/repo/splash_repo.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => NetworkInfo(sl()));
  sl.registerLazySingleton(() => DioClient(
        EndPoints.baseUrl,
        dio: sl(),
        loggingInterceptor: sl(),
        sharedPreferences: sl(),
      ));

  // Repository
  sl.registerLazySingleton(() => SplashRepo(
        sharedPreferences: sl(),
      ));
  sl.registerLazySingleton(
      () => AuthRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => MediaRepo(sharedPreferences: sl(), dioClient: sl()));

  //provider
  sl.registerLazySingleton(() => LocalizationProvider(sharedPreferences: sl()));
  sl.registerLazySingleton(() => LanguageProvider());
  sl.registerLazySingleton(() => ThemeProvider(sharedPreferences: sl()));
  sl.registerLazySingleton(() => SplashProvider(splashRepo: sl(), authProvider: sl()));
  sl.registerLazySingleton(() => AuthProvider(authRepo: sl()));
  sl.registerLazySingleton(() => MediaProvider(mediaRepo: sl()));
  sl.registerLazySingleton(() => SpeakProvider(mediaRepo: sl()));
  sl.registerLazySingleton(() => CalenderProvider());
;


  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
}
