import '../../localization/provider/language_provider.dart';
class AppStorageKey {
  static const String token = "token";
  static const String storeId = "storeId";
  static const String screenID = "screenID";
  static const String role = "role";
  static const String feedbacks = "feedbacks";
  static const String notFirstTime = "not_first_time";
  static const String isCompleteProfile = "is_complete_profile";
  static const String isLogin = "is_login";
  static const String userName = "userName";
  static const String tentID = "userID";
  static const String showOrderScreen = "showOrderScreen";
  static const String password = "password";
  static const String mail = "mail";
  static const String location = "location";
  static const String cityName = "city_name";
  static const String cityId = "city_id";
  static String cartItems = "cart_items";
  static String firstTimeOnApp = "first_time";
  static const String languageCode = "languageCode";
  static const String countryCode = "countryCode";
  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: 'Images.united_kingdom', languageName: 'english', countryCode: 'US', languageCode: 'en'),
    LanguageModel(imageUrl: 'Images.arabic', languageName: 'arabic', countryCode: 'SA', languageCode: 'ar'),
  ];

}
