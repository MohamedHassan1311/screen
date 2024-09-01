import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_azure_tts/flutter_azure_tts.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:live/app/core/utils/dimensions.dart';
import 'package:rxdart/rxdart.dart';
import 'package:video_player/video_player.dart';

import '../../../app/core/utils/color_resources.dart';
import '../../../app/core/utils/text_styles.dart';
import '../../../data/error/failures.dart';
import '../../../navigation/custom_navigation.dart';
import '../repo/fiels_repo.dart';

class SpeakProvider extends ChangeNotifier {
  final MediaRepo mediaRepo;
  SpeakProvider({
    required this.mediaRepo,
  }) {
    // initAzure();
    focusTextField.requestFocus();
    initTts();
    finshSpeek.stream.listen((v) {
      log("TTS finish Speek  $v  ");
      // popUpFuture=   Timer(Duration(seconds: 00), () {
      if (v == 1) {
        CustomNavigator.pop();

        // focusTextField.requestFocus();

        _isOpen = false;
        orderNumber = [];

        if (!_controller.value.isPlaying) {
          _controller.play();
        }
      }
      // });
    });
  }
  TextEditingController textEditingController = TextEditingController();
  late VideoPlayerController _controller;

  getVideoPlayerController(VideoPlayerController controller) {
    _controller = controller;
  }

  String lang = 'ar';
  FlutterTts flutterTts = FlutterTts();
  List<String> orderStrings = [];
  restData() {
    orderStrings = [];
    orderNumber = [];
    cashedNumber = 0;
    notifyListeners();
  }

  initAzure() {
    AzureTts.init(
        subscriptionKey: "cecb8f6145154179ab0f12b42e9b5fa1",
        region: "eastus",
        withLogs: true);
  }

  initTts() async {
    // enable logs
    log("Init local TTS");
    await flutterTts.setLanguage(lang);
    //
    await flutterTts.setVoice({"name": "ar-xa-x-ard-local", "locale": "ar"});
    await flutterTts.isLanguageAvailable(lang);
    await flutterTts.awaitSynthCompletion(true);
// iOS, Android and Web only
//see the "Pausing on Android" section for more info
    await flutterTts.pause();
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
    await flutterTts.awaitSynthCompletion(true);
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.getMaxSpeechInputLength;
  }

  bool isTtsFinshed = true;
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
        voice: Voice(
            name:
                "(Microsoft Server Speech Text to Speech Voice (ar-AE, HamdanNeural)",
            displayName: "Hamdan",
            localName: "حمدان",
            shortName: "ar-AE-HamdanNeural",
            gender: "Male",
            locale: "ar-AE",
            sampleRateHertz: "48000",
            voiceType: "Neural",
            status: "GA"),
        audioFormat: AudioOutputFormat.audio16khz32kBitrateMonoMp3,
        // rate: 1.5, // optional prosody rate (default is 1.0)
        text: text);

    final ttsResponse = await AzureTts.getTts(params);

    //Get the audio bytes.
    palyAudio(ttsResponse);
  }

  final finshSpeek = BehaviorSubject<int>();
  ttsSpeak(orderNumber) async {
    final text = "الطلب رقم ${orderNumber} جاهز للتسليم";
    flutterTts.setStartHandler(() {
      log("TTS Start  ");
      isTtsFinshed = false;
    });
    flutterTts.setCompletionHandler(() {
      isTtsFinshed = true;
      finshSpeek.sink.add(1);
      log("TTS Completion   ");
    });

    await flutterTts.setVolume(1.0);
    await flutterTts.setSpeechRate(0.55);
    await flutterTts.setPitch(1.5);
    flutterTts.speak(text);
  }

  FocusNode focusTextField = FocusNode();
  List<int> orderNumberList = [];
  Timer? checkerTimer;
  speak() async {
    cashedNumber = int.parse(orderNumber.join());
    orderNumberList.add(cashedNumber);
    checkerTimer?.cancel();
    checkerTimer = Timer.periodic(Duration(seconds: 1), (Timer t) async {
      print("orderNumberList$orderNumberList  " + "$_isOpen");
      for (var orderNum in orderNumberList) {
        Future.delayed(Duration(milliseconds: 10), () {
          if (_isOpen == false) {
            CustomNavigator.pop();

            showOrderDialog(orderNum);
            ttsSpeak(orderNum);
            // azureTtsSpeak(orderNum);

            textEditingController.clear();
            storeOrder(orderNumber.join());
            orderStrings.add("الطلب رقم ${orderNumber.join()} جاهز للتسليم");
          }
        });
      }
    });

    // orderNumber = [];
    notifyListeners();
  }

  List<AudioSuccess> audioList = [];

  Future<void> palyAudio(AudioSuccess ttsResponse) async {
    final player = AudioPlayer();
    player.stop();
    player.play(BytesSource(ttsResponse.audio));
  }

  List<int> orderNumber = [];
  int cashedNumber = 0;
  updateOrderNumber(int dieget) {
    orderNumber.add(dieget);
    textEditingController.text = orderNumber.join();
    notifyListeners();
  }

  updateOrderNumberBarcode(int dieget) {
    orderNumber.add(dieget);
    textEditingController.text = orderNumber.join();
    speak();
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
  Timer? popUpFuture;
  Future showOrderDialog(orderNum) async {
    _isOpen = true;
    popUpFuture?.cancel();
    orderNumberList.remove(orderNum);
    notifyListeners();

    await showDialog(
        context: CustomNavigator.navigatorState.currentContext!,
        barrierDismissible: false,
        builder: (BuildContext builderContext) {
          return Dialog(
              backgroundColor: Colors.white,
              child: Container(
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
                          orderNum.toString(),
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
      orderNumber = [];
      _isOpen = false;

      notifyListeners();
      _timer?.cancel();
    });
  }
}
