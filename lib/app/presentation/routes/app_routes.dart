import 'package:flutter/material.dart';
import 'package:app_ganaderia/app/presentation/modules/home/views/home_view.dart';
import 'package:app_ganaderia/app/presentation/modules/offline/of_line_view.dart';
import 'package:app_ganaderia/app/presentation/modules/sign_in/views/sign_in_view.dart';
import 'package:app_ganaderia/app/presentation/modules/splash/views/splash_view.dart';
import 'package:app_ganaderia/app/presentation/routes/routes.dart';

Map<String, Widget Function(BuildContext)> get appRoutes {
  return {
    Routes.splash: (context) => const SplashView(),
    Routes.signIn: (context) => const SignInView(),
    Routes.home: (context) => const HomeView(),
    Routes.ofLine: (context) => const OfLineView(),
  };
}
