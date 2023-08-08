import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../app/core/utils/app_storage_keys.dart';
import '../../../../app/core/utils/app_strings.dart';
import '../../../../data/api/end_points.dart';
import '../../../../data/dio/dio_client.dart';
import '../../../../data/error/api_error_handler.dart';
import '../../../../data/error/failures.dart';

class AuthRepo {
  final SharedPreferences sharedPreferences;
  final DioClient dioClient;
  AuthRepo({required this.sharedPreferences, required this.dioClient});

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppStorageKey.isLogin);
  }

  setLoggedIn(username, pass, userId) {
    sharedPreferences.setBool(AppStorageKey.isLogin, true);
    sharedPreferences.setString(AppStorageKey.userName, username);
    sharedPreferences.setString(AppStorageKey.password, pass);
    sharedPreferences.setInt(AppStorageKey.tentID, userId);
  }

  setShowOrderScreen(
    showOrderScreen,
  ) async {
    await sharedPreferences.setBool(
        AppStorageKey.showOrderScreen, showOrderScreen);
  }

  getShowOrderScreen()  {
    return sharedPreferences.getBool(
      AppStorageKey.showOrderScreen,
    );
  }

  setToken(token) {
    sharedPreferences.setString(AppStorageKey.token, token);
  }

  setScreenID(id) {
    sharedPreferences.setString(AppStorageKey.screenID, id.toString());
  }

  setStoreID(id) {
    sharedPreferences.setString(AppStorageKey.storeId, id.toString());
  }

  getMail() {
    if (sharedPreferences.containsKey(
      AppStorageKey.mail,
    )) {
      return sharedPreferences.getString(
        AppStorageKey.mail,
      );
    }
  }

  remember(mail) {
    sharedPreferences.setString(AppStorageKey.mail, mail);
  }

  forget() {
    sharedPreferences.remove(AppStorageKey.mail);
  }
  updateBaseUrl(Url){
    dioClient.updateHeader(null);
  dioClient.updateBaseUrl(Url);
  }
  Future<Either<ServerFailure, Response>> logIn(user, password,TenId,baseUrl) async {
    try {
      dioClient.updateHeader(null);
      // dioClient.updateBaseUrl(baseUrl);
      Response response = await dioClient.post(uri: EndPoints.logIn, data: {
        "userNameOrEmailAddress": user.trim(),
        "password": password,
        "TenId": TenId,
        "rememberClient": true
      });

      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return left(ServerFailure(response.data['details']));
      }
    } catch (error) {
      return left(ServerFailure(ApiErrorHandler.getMessage(error)));
    }
  }

  Future<Either<ServerFailure, Response>> getBranches() async {
    try {
      Response response = await dioClient.get(
          uri: EndPoints.getBranches,
          queryParameters: {
            'TenId': sharedPreferences.getInt(AppStorageKey.tentID)
          });

      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return left(ServerFailure(response.data['message']));
      }
    } catch (error) {
      return left(ServerFailure(ApiErrorHandler.getMessage(error)));
    }
  }
  Future<Either<ServerFailure, Response>> getTents() async {
    try {
      Response response = await dioClient.get(
          uri: EndPoints.getTents,
        );

      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return left(ServerFailure(response.data['message']));
      }
    } catch (error) {
      return left(ServerFailure(ApiErrorHandler.getMessage(error)));
    }
  }

  Future<Either<ServerFailure, Response>> getTenentStatus() async {
    try {
      Response response = await dioClient.get(
          uri: EndPoints.GetStatus,
          queryParameters: {
            'TenId': sharedPreferences.getInt(AppStorageKey.tentID)
          });

      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return left(ServerFailure(response.data['message']));
      }
    } catch (error) {
      return left(ServerFailure(ApiErrorHandler.getMessage(error)));
    }
  }

  Future<Either<ServerFailure, Response>> getStoreSections(id) async {
    try {
      Response response = await dioClient.get(
          uri: EndPoints.GetStoreSections,
          queryParameters: {
            "storeId": id,
            'TenId': sharedPreferences.getInt(AppStorageKey.tentID)
          });

      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return left(ServerFailure(response.data['message']));
      }
    } catch (error) {
      return left(ServerFailure(ApiErrorHandler.getMessage(error)));
    }
  }

  Future<Either<ServerFailure, Response>> getStoreScreens(id) async {
    try {
      Response response = await dioClient.get(
          uri: EndPoints.getstoreScreens,
          queryParameters: {
            "SecationId": id,
            'TenId': sharedPreferences.getInt(AppStorageKey.tentID)
          });

      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return left(ServerFailure(response.data['message']));
      }
    } catch (error) {
      return left(ServerFailure(ApiErrorHandler.getMessage(error)));
    }
  }

  updateHeader(token) {
    dioClient.updateHeader(token);
  }

  Future<bool> clearScreensData() async {
    await sharedPreferences.remove(AppStorageKey.screenID);

    await sharedPreferences.remove(AppStrings.appMedia);
    await sharedPreferences.remove(AppStrings.lastNews);
    await sharedPreferences.remove(AppStorageKey.storeId);

    return true;
  }

  Future<bool> clearSharedDataAuth() async {
    await sharedPreferences.remove(AppStorageKey.screenID);
    await sharedPreferences.remove(AppStorageKey.tentID);
    await sharedPreferences.remove(AppStorageKey.userName);
    await sharedPreferences.remove(AppStorageKey.password);

    await sharedPreferences.remove(AppStrings.appMedia);
    await sharedPreferences.remove(AppStrings.lastNews);
    await sharedPreferences.remove(AppStorageKey.storeId);
    await sharedPreferences.remove(AppStorageKey.isLogin);
    await sharedPreferences.clear();

    return true;
  }
}
