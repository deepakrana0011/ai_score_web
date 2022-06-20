

import 'package:ai_score/providers/home_provider.dart';
import 'package:ai_score/providers/login_provider.dart';
import 'package:ai_score/providers/score_analysis_provider.dart';
import 'package:ai_score/providers/score_management_provider.dart';
import 'package:ai_score/providers/test_page_provider.dart';
import 'package:ai_score/providers/user_management_provider.dart';
import 'package:ai_score/service/api.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
GetIt locator = GetIt.instance;

void setupLocator() {
  //locator.registerLazySingleton<UserDetail>(() => UserDetail());
  locator.registerLazySingleton(() => Api());
  locator.registerFactory<HomeProvider>(() => HomeProvider());
  locator.registerFactory<ScoreManagementProvider>(() => ScoreManagementProvider());
  locator.registerFactory<UserManagementProvider>(() => UserManagementProvider());
  locator.registerFactory<LoginProvider>(() => LoginProvider());
  locator.registerFactory<TestPageProvider>(() => TestPageProvider());
  locator.registerFactory<ScoreAnalysisProvider>(() => ScoreAnalysisProvider());

  locator.registerLazySingleton<Dio>(() {
    Dio dio =  Dio();
    //dio.interceptors.add(AppInterceptors(dio));
   // dio.interceptors.add(LogInterceptor(requestBody: false, responseBody: true, request: true, requestHeader: true, responseHeader: false, error: true));
    return dio;
  });
}
