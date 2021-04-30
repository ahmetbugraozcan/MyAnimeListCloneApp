import 'package:flutter_anichat/model/user.dart';
import 'package:flutter_anichat/repository/user_repository.dart';
import 'package:flutter_anichat/services/firebase_auth_service.dart';
import 'package:flutter_anichat/services/firebase_user_service.dart';
import 'package:flutter_anichat/services/myanimelist_api_call_methods.dart';
import 'package:flutter_anichat/services/oauth_auth_service.dart';
import 'package:flutter_anichat/utils/utils.dart';
import 'package:flutter_anichat/viewmodel/user_model.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => UserModel());
  locator.registerLazySingleton(() => MyAnimeListApiCall());
  locator.registerLazySingleton(() => OAuthService());
  locator.registerLazySingleton(() => FirebaseUserService());
  locator.registerLazySingleton(() => Utils());
}
