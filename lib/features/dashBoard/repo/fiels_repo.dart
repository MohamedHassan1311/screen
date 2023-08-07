import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../app/core/utils/app_storage_keys.dart';
import '../../../../data/api/end_points.dart';
import '../../../../data/dio/dio_client.dart';
import '../../../../data/error/api_error_handler.dart';
import '../../../../data/error/failures.dart';

class MediaRepo {
  final SharedPreferences sharedPreferences;
  final DioClient dioClient;
  MediaRepo({required this.sharedPreferences, required this.dioClient});

  Future<Either<ServerFailure, Response>> getFilesByScreenID() async {
    try {
      Response response = await dioClient.get(
          uri: EndPoints.GetStoreScreensFiles,
          queryParameters: {
            "screenId": sharedPreferences.getString(AppStorageKey.screenID),
            'TenId': sharedPreferences.getInt(AppStorageKey.tentID)
          }
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

  Future<Either<ServerFailure, Response>> getLastNews() async {
    try {
      Response response = await dioClient.get(uri: EndPoints.getLastNews,   queryParameters: {
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

  Future<Either<ServerFailure, Response>> storeDoneOrder(id) async {
    try {
      Response response =
          await dioClient.post(uri: EndPoints.storeDoneOrder, data: {
        "orderDate": DateTime.now().toUtc().toString(),
        "orderNo": "$id",
        "isDeleted": true
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
}
