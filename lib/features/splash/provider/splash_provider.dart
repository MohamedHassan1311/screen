import 'package:flutter/cupertino.dart';
import 'package:live/features/auth/select_branch_screen/provider/auth_provider.dart';
import 'package:live/navigation/custom_navigation.dart';
import 'package:live/navigation/routes.dart';
import '../repo/splash_repo.dart';

class SplashProvider extends ChangeNotifier {
  final SplashRepo splashRepo;
  final AuthProvider authProvider;
  SplashProvider( {required this.splashRepo,required this.authProvider,});

  startTheApp() {
    Future.delayed(const Duration(milliseconds: 4500), () {
      if (!splashRepo.isLogin()) {

        CustomNavigator.push(Routes.SginInScreen, clean: true);
        return;
      }    if (splashRepo.isScreenSelected()) {
        authProvider.getTentStatusTimer();
        CustomNavigator.push(Routes.selectBranch, clean: true);
      }  else {
        authProvider.getTentStatusTimer();
        CustomNavigator.push(Routes.DASHBOARD, clean: true, arguments: 0);
      }
      // splashRepo.setFirstTime();
    });
  }
}
