import 'package:flutter/services.dart';
import 'package:live/app/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:live/features/splash/provider/splash_provider.dart';
import '../../../app/core/utils/color_resources.dart';
import '../../../app/core/utils/images.dart';
import '../../../navigation/custom_navigation.dart';
import '../../auth/select_branch_screen/provider/auth_provider.dart';
import '../../dashBoard/provider/files_provider.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);


    Future.delayed(const Duration(milliseconds: 0), () async {

      Provider.of<SplashProvider>(CustomNavigator.navigatorState.currentContext!,
          listen: false)
          .startTheApp();
    });
    // Future.delayed(const Duration(milliseconds: 4500), () {Provider.of<AuthProvider>(context, listen: false).logOut();});

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

        body: Stack(
      alignment: Alignment.center,
      children: [
        Container(
            height: context.height,
            width: context.width,
            alignment: Alignment.center,

            child: const SizedBox()),
        Image.asset(
          Images.logo,
          width: 200,
        )
            .animate()
            .scale(duration: 1000.ms)
            .then(delay: 500.ms) // baseline=800ms
            .slide()
            .scaleXY(duration: 1000.ms)
            .then(delay: 200.ms)
            .shimmer(duration: 1000.ms),
      ],
    ));
  }
}
