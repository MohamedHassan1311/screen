import 'package:shared_preferences/shared_preferences.dart';
import 'package:live/app/core/utils/app_storage_keys.dart';

class SplashRepo {
  final SharedPreferences sharedPreferences;
  SplashRepo({required this.sharedPreferences});

  bool isScreenSelected() {
    return sharedPreferences.getString(AppStorageKey.screenID)==null&&sharedPreferences.getString(AppStorageKey.storeId)==null;
  }


  bool isLogin() {
    return sharedPreferences.containsKey(AppStorageKey.isLogin);
  }

  setFirstTime() {
    sharedPreferences.setBool(AppStorageKey.notFirstTime, true);
  }
}
