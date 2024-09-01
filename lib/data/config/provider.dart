import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:live/data/config/di.dart' as di;

import '../../app/localization/provider/localization_provider.dart';
import '../../app/theme/theme_provider/theme_provider.dart';
import '../../features/auth/select_branch_screen/provider/auth_provider.dart';

import '../../features/dashBoard/provider/SpeakProvider.dart';
import '../../features/dashBoard/provider/files_provider.dart';
import '../../features/splash/provider/splash_provider.dart';


abstract class ProviderList {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider(
      create: (_) => di.sl<ThemeProvider>(),
    ),
    ChangeNotifierProvider(create: (_) => di.sl<LocalizationProvider>()),
    ChangeNotifierProvider(create: (_) => di.sl<SpeakProvider>()),
    ChangeNotifierProvider(create: (_) => di.sl<SplashProvider>()),
    ChangeNotifierProvider(create: (_) => di.sl<AuthProvider>()),
    ChangeNotifierProvider(create: (_) => di.sl<MediaProvider>()),




  ];
}
