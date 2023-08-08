import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_azure_tts/flutter_azure_tts.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:live/app/core/utils/dimensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../data/error/failures.dart';
import '../../../app/core/utils/app_storage_keys.dart';
import '../../../app/core/utils/app_strings.dart';

import '../../../data/config/di.dart';
import '../../../main_models/MediaFile.dart';


import '../repo/fiels_repo.dart';

class MediaProvider extends ChangeNotifier {
  final MediaRepo mediaRepo;

  MediaProvider({
    required this.mediaRepo,
  }) {
    getLastNews();
  }
  SharedPreferences prefs = sl.get<SharedPreferences>();
  List<MediaFile>? mediaFiles = [];
  TextEditingController textEditingController = TextEditingController();
  bool isLoadingScreen = true;
  Timer? timer;

  remove() async {
    await prefs.remove(AppStrings.appMedia);
    mediaFiles = [];
    notifyListeners();
  }

  getShowOrderScreen() => prefs.getBool(
        AppStorageKey.showOrderScreen,
      );
  getFilesByScreenID() async {
    await getLastNews();
    if (prefs.getString(AppStrings.appMedia) != null) {
      mediaFiles = List<MediaFile>.from(
          jsonDecode(prefs.getString(AppStrings.appMedia)!)
              .map((x) => MediaFile.fromJson(x)));
    }
    isLoadingScreen = true;
    notifyListeners();

    Either<ServerFailure, Response> response =
        await mediaRepo.getFilesByScreenID();
    response.fold((l) {
      if (prefs.getString(AppStrings.appMedia) != null) {
        mediaFiles = List<MediaFile>.from(
            jsonDecode(prefs.getString(AppStrings.appMedia)!)
                .map((x) => MediaFile.fromJson(x)));
      }

      isLoadingScreen = false;
      notifyListeners();
    }, (response) {
      prefs.setString(
        AppStrings.appMedia,
        jsonEncode(response.data!['result']),
      );
      mediaFiles = [];
      notifyListeners();
      mediaFiles = List<MediaFile>.from(
          jsonDecode(prefs.getString(AppStrings.appMedia)!)
              .map((x) => MediaFile.fromJson(x)));

      isLoadingScreen = false;
      notifyListeners();
    });
  }

  String? lastNews;
  getLastNews() async {
    if (prefs.getString(AppStrings.lastNews) != null) {
      lastNews = prefs.getString(AppStrings.lastNews);
    }

    notifyListeners();

    Either<ServerFailure, Response> response = await mediaRepo.getLastNews();
    response.fold((l) {
      if (prefs.getString(AppStrings.lastNews) != null) {
        lastNews = prefs.getString(AppStrings.lastNews);
      }
      notifyListeners();
    }, (response) {
      if (response.data!['result'] != null) {
        prefs.setString(
          AppStrings.lastNews,
          jsonEncode(response.data!['result']['aname']),
        );
      } else {
        prefs.setString(
          AppStrings.lastNews,
          '',
        );
      }

      lastNews = prefs.getString(AppStrings.lastNews);

      notifyListeners();
    });
  }

  String lang = 'ar';

  List<String> orderStrings = [];
}


