import '../../../navigation/custom_navigation.dart';
import '../../localization/localization/language_constant.dart';

class Validations {
  static String? name(String? value) {
    if (value!.isEmpty) {
      return getTranslated(
          "required", CustomNavigator.navigatorState.currentContext!);
    } else {
      return null;
    }
  }

  static String? mail(String? email) {
    if (email!.length < 8 || !email.contains("@") || !email.contains(".com")) {
      return getTranslated("please_enter_valid_email",
          CustomNavigator.navigatorState.currentContext!);
    } else {
      return null;
    }
  }
  static String? password(String? password) {
    if (password!.length < 8 ) {
      return getTranslated("please_enter_valid_password",
          CustomNavigator.navigatorState.currentContext!);
    } else {
      return null;
    }
  }

  static String? phone(String? value) {
    if (value!.isEmpty || value.length < 7) {
      return getTranslated("please_enter_valid_number",
          CustomNavigator.navigatorState.currentContext!);
    } else {
      return null;
    }
  }

  static String? code(String? value) {
    if (value!.isEmpty || value.length < 6) {
      return getTranslated("please_enter_valid_code",
          CustomNavigator.navigatorState.currentContext!);
    } else {
      return null;
    }
  }

  static String? city(Object? value) {
    if (value!.toString().isEmpty) {
      return getTranslated(
          "please_choose_city", CustomNavigator.navigatorState.currentContext!);
    } else {
      return null;
    }
  }
}
