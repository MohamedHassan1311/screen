import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../data/error/api_error_handler.dart';
import '../../../../data/error/failures.dart';
import '../../../../main_models/StoreBranches.dart';
import '../repo/auth_repo.dart';
import '../../../../../navigation/custom_navigation.dart';
import '../../../../../navigation/routes.dart';
import '../../../../app/core/utils/app_snack_bar.dart';
import '../../../../app/core/utils/color_resources.dart';
import '../../../../app/localization/localization/language_constant.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepo authRepo;
  AuthProvider({required this.authRepo,}){

  }



  String _token = "";
  String get token => _token;

  late final TextEditingController mailTEC= TextEditingController();
  late final TextEditingController baseUrlTEC= TextEditingController();
  final TextEditingController passwordTEC = TextEditingController();
  late TextEditingController tentIDTEC = TextEditingController();
  bool _isRememberMe = true;
  bool get isRememberMe => _isRememberMe;
  void onRememberMe(bool value) {
    _isRememberMe = value;
    notifyListeners();
  }

  bool _isAgree = true;
  bool get isAgree => _isAgree;
  void onAgree(bool value) {
    _isAgree = value;
    notifyListeners();
  }

  bool isChecked = true;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

changeCheckBoxValue(value) async {
  isChecked=value;
 await authRepo.setShowOrderScreen(isChecked);
  notifyListeners();

}
getShowOrderScreen()  =>

  authRepo.getShowOrderScreen();


  updateBaseUrl(){
    authRepo.updateBaseUrl("http://${baseUrlTEC.text.trim()}");
   getTents();
  }
  logIn({bool isFromLogin=false}) async {
    try {
        _isLoading = true;
        notifyListeners();
        Either<ServerFailure, Response> response = await authRepo.logIn(mailTEC.text.trim(),passwordTEC.text.trim(),tent?.id,"http://$baseUrlTEC");
        response.fold((fail) {
          CustomSnackBar.showSnackBar(
              notification: AppNotification(
                  message: fail.error,
                  isFloating: true,
                  backgroundColor: ColorResources.IN_ACTIVE,
                  borderColor: Colors.transparent));
          notifyListeners();
        },
                (success) {

          _token=success.data['result']["accessToken"];
          authRepo.updateHeader(_token);

          // authRepo.setLoggedIn(mailTEC.text.trim(),passwordTEC.text.trim(),success.data['result']['userId']);
          authRepo.setLoggedIn(mailTEC.text.trim(),passwordTEC.text.trim(),int.parse(tentIDTEC.text.trim()));
          authRepo.setToken(
              _token);
          getTentStatus();
          if(isFromLogin)
            {
              CustomNavigator.push(Routes.selectBranch, clean: true, );
            }

        });
        _isLoading = false;
        notifyListeners();

    } catch (e) {
      CustomSnackBar.showSnackBar(
          notification: AppNotification(
              message: ApiErrorHandler.getMessage(e),
              isFloating: true,
              backgroundColor: ColorResources.IN_ACTIVE,
              borderColor: Colors.transparent));
      _isLoading = false;
      notifyListeners();
    }
  }
  bool isLoadinBranches = true;
  bool isLoadintents = true;
  BaseItem? branch;
  BaseItem? tent;
  selectedBranch(value) {

    branch = value;
    if(branch!=null) {
      storeSection=null;
      getStoreSections(branch!.id);
      setStoreID(branch!.id);
    }
    notifyListeners();
  }  selectedTent(value) {

    tent = value;
    if(tent!=null) {
      tentIDTEC=TextEditingController(text: tent!.id!.toString());
print(tentIDTEC.text);
    }
    notifyListeners();
  }
  BaseItem? section;
  selectedSection(value) {
    section = value;
    if(section!=null) {
      getStoreScreen(section!.id);
    }
    notifyListeners();
  }

  BaseItem? screen;
  selectedScreen(value) {
    screen = value;
    if(screen!=null) {
      print(screen!.id);
      setScreenID(screen!.id);
    }
    notifyListeners();
  }

  StoreBranches? storeBranches ;
  List<BaseItem>? storeSection ;
  List<BaseItem>? storeScreen ;
  List<BaseItem>? tents ;
  getTents() async {
    isLoadintents = true;
    notifyListeners();
    Either<ServerFailure, Response> response = await authRepo.getTents();
    response.fold((l) => null, (response) {
      tents = List<BaseItem>.from(response.data["result"]!.map((x) => BaseItem.fromJson(x)));
      notifyListeners();

      isLoadintents = false;
      notifyListeners();
    });
  }
  getBranches() async {
    isLoadinBranches = true;
    notifyListeners();
    Either<ServerFailure, Response> response = await authRepo.getBranches();
    response.fold((l) => null, (response) {
      storeBranches = StoreBranches.fromJson(response.data);
      notifyListeners();

      isLoadinBranches = false;
      notifyListeners();
    });
  }

  bool isLoadingSection= true;
  getStoreSections(id) async {
    isLoadingSection = true;
    notifyListeners();
    Either<ServerFailure, Response> response = await authRepo.getStoreSections(id);
    response.fold((l) => null, (response) {
      storeSection = List<BaseItem>.from(response.data["result"]!.map((x) => BaseItem.fromJson(x)));
      notifyListeners();

      isLoadingSection = false;
      notifyListeners();
    });
  }


  bool isLoadingScreen= true;
  getStoreScreen(id) async {
    isLoadingScreen = true;
    notifyListeners();
    Either<ServerFailure, Response> response = await authRepo.getStoreScreens(id);
    response.fold((l) => null, (response) {
      storeScreen = List<BaseItem>.from(response.data!['result'].map((x) => BaseItem.fromJson(x)));
      notifyListeners();

      isLoadingScreen = false;
      notifyListeners();
    });
  }
  getTentStatusTimer(){
    getTentStatus();
    Timer.periodic(Duration(hours: 1), (Timer t) {
      getTentStatus();
    });
  }
  getTentStatus() async {

    notifyListeners();
    Either<ServerFailure, Response> response = await authRepo.getTenentStatus();
    response.fold((l) => null, (response) {

  if(response.data!['result']['isActive']==false){

    logOutFromAccount(fromLogout: false);

  }


      notifyListeners();
    });
  }



  setScreenID(id) {
    authRepo.setScreenID(id);
  }

  setStoreID(id) {
    authRepo.setStoreID(id);
  }

  logOutFromScreen() async {
    CustomNavigator.push(Routes.selectBranch, clean: true);
    screen=null;
    section=null;
    branch=null;
    await authRepo.clearScreensData();


    notifyListeners();
  }
  logOutFromAccount({fromLogout=true}) async {
    await authRepo.clearSharedDataAuth();

    CustomNavigator.push(Routes.SginInScreen, clean: true);
if(fromLogout) {
      CustomSnackBar.showSnackBar(
          notification: AppNotification(
              message: getTranslated("your_logged_out_successfully",
                  CustomNavigator.navigatorState.currentContext!),
              isFloating: true,
              backgroundColor: ColorResources.ACTIVE,
              borderColor: Colors.transparent));
    }
else {
  CustomSnackBar.showSnackBar(
      notification: AppNotification(
          message: "تم اغلاق حسابك من قبل الادارة",
          isFloating: true,
          backgroundColor: ColorResources.ACTIVE,
          borderColor: Colors.transparent));
}
    notifyListeners();
  }
}
