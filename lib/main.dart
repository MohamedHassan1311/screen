
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:media_cache_manager/media_cache_manager.dart';
import 'package:provider/provider.dart';
import 'app/core/utils/app_storage_keys.dart';
import 'app/core/utils/dimensions.dart';
import 'app/core/utils/un_focus.dart';
import 'app/localization/localization/app_localization.dart';
import 'app/localization/provider/localization_provider.dart';

import 'app/theme/light_theme.dart';

import 'data/config/provider.dart';
import 'package:flutter/material.dart';

import 'app/core/utils/app_strings.dart';


import 'features/splash/page/splash.dart';
import 'navigation/custom_navigation.dart';
import 'navigation/routes.dart';
import 'package:live/data/config/di.dart' as di;
import 'package:keep_screen_on/keep_screen_on.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChannels.textInput.invokeMethod('TextInput.hide');
  await di.init();
  await MediaCacheManager.instance.init();
  KeepScreenOn.turnOn();
  runApp(
      MultiProvider(providers: ProviderList.providers, child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    List<Locale> locals = [];
    for (var language in AppStorageKey.languages) {
      locals.add(Locale(language.languageCode!, language.countryCode));
    }


    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light));

    return MaterialApp(
      builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor:getDeviceType() ==DeviceType.Phone?1.3: 2.0),
          child: UnFocus(child: child!)),
      initialRoute: Routes.SPLASH,
      navigatorKey: CustomNavigator.navigatorState,
      onGenerateRoute: CustomNavigator.onCreateRoute,
      navigatorObservers: [CustomNavigator.routeObserver],
      title: AppStrings.appName,
      home: const Splash(),
      scaffoldMessengerKey: CustomNavigator.scaffoldState,
      debugShowCheckedModeBanner: false,
      theme: light,
      supportedLocales: locals,
      locale: Provider.of<LocalizationProvider>(
        context,
      ).locale,
      localizationsDelegates: const [
        AppLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
