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
import '../../../../main_models/StoreBranches.dart';
import '../../../app/core/utils/app_storage_keys.dart';
import '../../../app/core/utils/app_strings.dart';
import '../../../app/core/utils/color_resources.dart';
import '../../../app/core/utils/text_styles.dart';
import '../../../data/config/di.dart';
import '../../../main_models/MediaFile.dart';

import '../../../navigation/custom_navigation.dart';
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

class SpeakProvider extends ChangeNotifier {
  final MediaRepo mediaRepo;
  SpeakProvider({
    required this.mediaRepo,
  }) {
    initTts();
  }
  TextEditingController textEditingController = TextEditingController();

  String lang = 'ar';
  FlutterTts flutterTts = FlutterTts();
  List<String> orderStrings = [];
  restData() {
    orderStrings = [];
    orderNumber = [];
    cashedNumber = 0;
    notifyListeners();
  }

  initTts() async {
    AzureTts.init(
        subscriptionKey: "cecb8f6145154179ab0f12b42e9b5fa1",
        region: "eastus",
        withLogs: true); // enable logs

    await flutterTts.setLanguage(lang);

    await flutterTts.setVoice({"name": "ar-xa-x-ard-local", "locale": "ar"});
    await flutterTts.isLanguageAvailable(lang);

// iOS, Android and Web only
//see the "Pausing on Android" section for more info
//     await flutterTts.pause();
//
// // iOS, macOS, and Android only
    await flutterTts.synthesizeToFile(
        "Hello World", Platform.isAndroid ? "tts.wav" : "tts.caf");
    // ar-xa-x-ard-local
    await flutterTts.setVolume(1.0);
    await flutterTts.setSpeechRate(0.7);
    await flutterTts.setPitch(0.5);
//
// // iOS only
    await flutterTts.setSharedInstance(true);
//
// // Android only
    await flutterTts.setSilence(20);
//
    await flutterTts.getEngines;

    await flutterTts.isLanguageInstalled(lang);

    await flutterTts.areLanguagesInstalled([lang, "en-US"]);

    await flutterTts.setQueueMode(1);

    await flutterTts.getMaxSpeechInputLength;
  }

  storeOrder(id) async {
    try {
      notifyListeners();
      Either<ServerFailure, Response> response =
          await mediaRepo.storeDoneOrder(id);
    } catch (e) {}
  }

  bool _isOpen = false;
  azureTtsSpeak(orderNumber) async {

    final text = "الطلب رقم ${orderNumber} جاهز للتسليم";

    TtsParams params = TtsParams(
        // voice: voice,
        voice:  Voice(name: "(Microsoft Server Speech Text to Speech Voice (ar-AE, HamdanNeural)", displayName: "Hamdan", localName: "حمدان",
            shortName: "ar-AE-HamdanNeural", gender: "Male", locale: "ar-AE", sampleRateHertz: "48000", voiceType: "Neural", status: "GA"),
        audioFormat: AudioOutputFormat.audio16khz32kBitrateMonoMp3,
        // rate: 1.5, // optional prosody rate (default is 1.0)
        text: text);

    final ttsResponse = await AzureTts.getTts(params);

    //Get the audio bytes.
    await palyAudio(ttsResponse);
  }

  speak() async {
    if (_isOpen) {
      CustomNavigator.pop();
      _isOpen = false;
      notifyListeners();
    }
    cashedNumber = int.parse(orderNumber.join());
    showOrderDialog(orderNumber.join());
    await flutterTts.setVolume(1.0);
    await flutterTts.setSpeechRate(0.55);
    await flutterTts.setPitch(1.5);
    print("isOpen$_isOpen");
    azureTtsSpeak(orderNumber.join());
    storeOrder(orderNumber.join());
    orderStrings.add("الطلب رقم ${orderNumber.join()} جاهز للتسليم");

    orderNumber = [];
    notifyListeners();
  }

  Future<void> palyAudio(AudioSuccess ttsResponse) async {
    AudioPlayer player = AudioPlayer();
    await player.play(BytesSource(ttsResponse.audio));
  }

  List<int> orderNumber = [];
  int cashedNumber = 0;
  updateOrderNumber(int dieget) {
    orderNumber.add(dieget);
    textEditingController.text = orderNumber.join();
    notifyListeners();
  }

  nextNumber() {
    orderNumber.add(++cashedNumber);
    speak();
    notifyListeners();
  }

  previousNumber() {
    if (cashedNumber != 0) {
      orderNumber.add(--cashedNumber);
      speak();
    }
    notifyListeners();
  }

  Timer? _timer;

  showOrderDialog(orderNum) {
    _isOpen = true;
    notifyListeners();

    showDialog(
        context: CustomNavigator.navigatorState.currentContext!,
        builder: (BuildContext builderContext) {
          Future.delayed(Duration(seconds: 5)).then((_) {
            CustomNavigator.pop();
            orderNumber = [];
          });
          _timer = Timer(Duration(seconds: 5), () {
            CustomNavigator.pop();
            orderNumber = [];
          });

          return Dialog(
              backgroundColor: Colors.white,
              // title: Text('Title'),
              child: Container(
                // width: double.infinity/2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                height: 500.h,
                width: 250.w,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(30.h, 10.h, 30.h, 10.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 30.h, 0, 24.h),
                        child: Text(
                          "الطلب رقم",
                          style: AppTextStyles.w600
                              .copyWith(fontSize: 35, color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 30.h, 0, 24.h),
                        child: Text(
                          orderNum,
                          style: AppTextStyles.w600.copyWith(
                              fontSize: 55,
                              color: ColorResources.PRIMARY_COLOR),
                        ),
                      ),
                    ],
                  ),
                ),
              ));
        }).then((val) {
      _isOpen = false;
      orderNumber = [];
      notifyListeners();
      _timer?.cancel();
    });
  }
}
