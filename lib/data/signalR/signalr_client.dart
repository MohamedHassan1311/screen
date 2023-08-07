import 'dart:developer';
import 'dart:io';

import 'dart:math' as r;
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:live/app/core/utils/app_storage_keys.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:http/http.dart' as http;
import '../../features/dashBoard/provider/files_provider.dart';
import '../../main_models/ScreenAction_model.dart';
import '../api/end_points.dart';
import '../config/di.dart';

class SignalrClient extends ChangeNotifier {
  static  HubConnection? sendOrdersRecvHubConnection;
  static  HubConnection? startSendOffersToUserConnectionHub;

  // static final SignalrClient _instance = SignalrClient();
  // static SignalrClient get instance => _instance;
  // factory SignalrClient() {
  //   return _instance;
  // }

  bool showFirst = false;
  Future<void> startConnection() async {
    log('SignalrConnection.StartConnection.');
    startSendOffersToUserConnection();
    startSendOrdersRecConnection();
  }

  Future<void> startSendOffersToUserConnection() async {
    log('SignalrConnection.SendOffersToUser.');

    // try {
      startSendOffersToUserConnectionHub = HubConnectionBuilder()
          .withUrl(
              EndPoints.baseUrlWebSocketOrders,
              HttpConnectionOptions(
                  skipNegotiation: false,
                  transport: HttpTransportType.webSockets,
                  accessTokenFactory: () async => await getAccessToken(),
                  client: await getClientToken(),
                  logging: (level, message) => log(message)))
          .withAutomaticReconnect()
          .build();

      _recreateConnection();

      await startSendOffersToUserConnectionHub!.start();
      startSendOffersToUserConnectionHub!.on("SendOffersToUser", (arguments) {
        log('SendOffersToUser${arguments}');
        log( prefs.getString(AppStorageKey.screenID)!);
        log( prefs.getInt(AppStorageKey.tentID).toString());
        ScreenAction screenAction = ScreenAction.listFromJson(arguments).first;
        log('tentId${screenAction.tentId } screenID ${screenAction.tbStoreScreensId } ');
        if (screenAction.tbStoreScreensId ==
            int.parse(prefs.getString(AppStorageKey.screenID)!) &&screenAction.tentId ==
            (prefs.getInt(AppStorageKey.tentID)!)) {
          log('relode');
          sl.get<MediaProvider>().getFilesByScreenID();

        }
      });
      log('SignalrClient Connection2 state${startSendOffersToUserConnectionHub!.state}');

      log('SignalrClient Connection2 id${startSendOffersToUserConnectionHub!.connectionId}');
      notifyListeners();
    // } catch (e) {
    //   log(e.toString());
    // }
  }

  Future<void> startSendOrdersRecConnection() async {
    log('SignalrConnection.StartConnection.');

    try {
      sendOrdersRecvHubConnection = HubConnectionBuilder()
          .withUrl(
              EndPoints.baseUrlWebSocketOrdersRec,
              HttpConnectionOptions(
                  skipNegotiation: false,
                  transport: HttpTransportType.webSockets,
                  accessTokenFactory: () async => await getAccessToken(),
                  client: await getClientToken(),
                  logging: (level, message) => log(message)))
          .withAutomaticReconnect()
          .build();

      _recreateConnection();

      await sendOrdersRecvHubConnection!.start();
      sendOrdersRecvHubConnection!.on("SendOrdersRecvHub", (arguments) {
        log('SendOrdersRecvHub${arguments!}');
        log( prefs.getString(AppStorageKey.screenID)!);
        log( prefs.getInt(AppStorageKey.tentID).toString());

        ScreenAction screenAction = ScreenAction.listFromJson(arguments).first;
        log("screenID ${screenAction.id}" );
        log("creatorUserId${screenAction.tentId}" );
        if (screenAction.screenId ==
                int.parse(prefs.getString(AppStorageKey.screenID)!) &&screenAction.tentId ==
              (prefs.getInt(AppStorageKey.tentID)!) &&
            screenAction.orderNo == "Res") {
          restartAppFunction();
        }
        if (screenAction.screenId ==
            int.parse(prefs.getString(AppStorageKey.screenID)!) &&screenAction.tentId ==
            (prefs.getInt(AppStorageKey.tentID)!) &&
            screenAction.orderNo == "shutDown") {
          shutDown();
        }
      });
      log('SignalrClient Connection2 state${sendOrdersRecvHubConnection!.state}');

      log('SignalrClient Connection2 id${sendOrdersRecvHubConnection!.connectionId}');
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  restartAppFunction() {
    log('Restart App');
    Restart.restartApp();
  }

  shutDown() {
    log('shutDown App');
    exit(0);
  }

  SharedPreferences prefs = sl.get<SharedPreferences>();
  Future<String> getAccessToken() async {
    return "${prefs.getString(AppStorageKey.token)}";
  }

  Future getClientToken() async {
    final httpClient = _HttpClient(defaultHeaders: {
      'Authorization': 'Bearer ${prefs.getString(AppStorageKey.token)}',
    });
    return httpClient;
  }

  _recreateConnection() {
    // _onReConnected();
    // sendOrdersRecvHubConnection!.onclose((exception) async {
    //   await disconnect();
    //
    //   _retryUntilSuccessfulConnection(exception);
    // });
  }

  void _onReConnected() {
    sendOrdersRecvHubConnection!.onreconnected((connectionId) {
      _retryUntilSuccessfulConnection(Exception());
    });
  }

  Future _retryUntilSuccessfulConnection(Exception? exception) async {
    while (true) {
      var delayTime = r.Random().nextInt(20);
      await Future.delayed(const Duration(seconds: 0));

      try {
        if (sendOrdersRecvHubConnection!.state == HubConnectionState.connected) {
          // if (Get.isSnackbarOpen && showFirst != false) {
          //   Get.closeAllSnackbars();
          // }
          showFirst = true;
          notifyListeners();
          // Get.snackbar(
          //   getTranslated(
          //       "connection_state", StipsRouter.navigatorKey.currentContext!),
          //   getTranslated("connected", StipsRouter.navigatorKey.currentContext!),
          //   colorText: Colors.white,
          //   icon: const Icon(Icons.wb_incandescent, color: Colors.white),
          //   backgroundColor: Colors.green,
          // );

          notifyListeners();
          return;
        } else if (sendOrdersRecvHubConnection!.state ==
            HubConnectionState.disconnected) {
          startConnection();
          notifyListeners();
          return;
        }
      } catch (e) {
        log('Exception here :( ${e.toString()}');
      }
    }
  }

  Future<void> disconnect() async {
    await sendOrdersRecvHubConnection!.stop();
    await startSendOffersToUserConnectionHub!.stop();
  }
}

class _HttpClient extends http.BaseClient {
  final _httpClient = http.Client();
  final Map<String, String> defaultHeaders;

  _HttpClient({required this.defaultHeaders});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(defaultHeaders);
    return _httpClient.send(request);
  }
}
